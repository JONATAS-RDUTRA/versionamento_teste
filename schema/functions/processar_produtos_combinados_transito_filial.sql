CREATE OR REPLACE FUNCTION public.processar_produtos_combinados_transito_filial(f_id_produto_combinado character varying DEFAULT NULL::character varying)
 RETURNS void
 LANGUAGE plpgsql
 PARALLEL SAFE
AS $function$
    declare
    rec_transito record;
    qtde_dias_delay int;
    BEGIN

    IF trim(f_id_produto_combinado) = '' THEN
        f_id_produto_combinado = NULL;
    END IF;

    qtde_dias_delay = 2;

    update produtos_combinados_transito_filial set flag = 'D' WHERE (f_id_produto_combinado = id_produto_combinado OR f_id_produto_combinado IS NULL);

    for rec_transito in(
         SELECT
            b.id_grupo,
            b.filial,
            b.id_produto_combinado,
            b.compra_transito * b.fator_conversao AS compra_transito,
            b.consumo_transito * b.fator_conversao AS consumo_transito,
            b.saldo_futuro * b.fator_conversao AS saldo_futuro,
            b.status,
            CASE
                WHEN b.status = 'PREVISÃO FUTURA EM EXCESSO'::text AND abs(b.lote_compras) > b.compra_transito::double precision THEN (b.compra_transito * b.fator_conversao * '-1'::integer::numeric)::double precision
                ELSE gerar_lote_embalagem((b.lote_compras * b.fator_conversao::double precision)::numeric, b.lote_minimo::numeric * b.fator_conversao)::double precision
            END AS lote_compras,
            b.data_ultima_requisicao,
            'now'::text::date - b.data_ultima_requisicao AS tempo_pedido,
            CASE
                WHEN ('now'::text::date - b.data_ultima_requisicao - qtde_dias_delay) < 0 THEN NULL::integer
                ELSE 'now'::text::date - b.data_ultima_requisicao - qtde_dias_delay
            END AS gatilho_transito
        FROM (
            SELECT
                a.id_grupo,
                a.filial,
                a.id_produto_combinado,
                a.compra_transito,
                a.consumo_transito,
                a.saldo_futuro,
                a.fator_conversao,
                a.lote_minimo,
                a.data_ultima_requisicao,
                CASE
                    WHEN a.status_compra::numeric = 0::numeric AND ('now'::text::date - a.data_ultima_requisicao) > qtde_dias_delay AND a.saldo_futuro::double precision > a.estoque_maximo THEN 'PREVISÃO FUTURA EM EXCESSO'::text
                    WHEN a.status_compra::numeric = 0::numeric AND ('now'::text::date - a.data_ultima_requisicao) > qtde_dias_delay AND a.saldo_futuro::double precision > a.ponto_pedido AND a.saldo_futuro::double precision <= a.estoque_maximo AND (a.saldo_futuro::double precision - a.consumo_medio_mensal * 0.5::double precision) > a.ponto_pedido THEN 'PREVISÃO FUTURA ADEQUADA'::text
                    WHEN a.status_compra::numeric = 0::numeric AND ('now'::text::date - a.data_ultima_requisicao) > qtde_dias_delay AND a.saldo_futuro::double precision > a.ponto_pedido AND a.saldo_futuro::double precision <= a.estoque_maximo AND (a.saldo_futuro::double precision - a.consumo_medio_mensal * 0.5::double precision) <= a.ponto_pedido THEN 'PREVISÃO COM SUTIL EXPOSIÇÃO A RUPTURA'::text
                    WHEN a.status_compra::numeric = 0::numeric AND ('now'::text::date - a.data_ultima_requisicao) > qtde_dias_delay AND a.saldo_futuro::double precision <= a.ponto_pedido THEN 'PREVISÃO COM ELEVADA EXPOSIÇÃO A RUPTURA'::text
                    WHEN a.status_compra::numeric = 0::numeric AND ('now'::text::date - a.data_ultima_requisicao) < qtde_dias_delay THEN 'PRODUTO EM TRANSITO'::text
                    ELSE 'PRIMEIRA COMPRA'::text
                END AS status,
                CASE
                    WHEN a.status_compra::numeric = 0::numeric AND ('now'::text::date - a.data_ultima_requisicao) > qtde_dias_delay AND a.saldo_futuro::double precision > a.estoque_maximo THEN a.estoque_maximo - a.saldo_futuro::double precision
                    WHEN a.status_compra::numeric = 0::numeric AND ('now'::text::date - a.data_ultima_requisicao) > qtde_dias_delay AND a.saldo_futuro::double precision > a.ponto_pedido AND a.saldo_futuro::double precision <= a.estoque_maximo AND (a.saldo_futuro::double precision - a.consumo_medio_mensal * 0.5::double precision) > a.ponto_pedido THEN 0::double precision
                    WHEN a.status_compra::numeric = 0::numeric AND ('now'::text::date - a.data_ultima_requisicao) > qtde_dias_delay AND a.saldo_futuro::double precision > a.ponto_pedido AND a.saldo_futuro::double precision <= a.estoque_maximo AND (a.saldo_futuro::double precision - a.consumo_medio_mensal * 0.5::double precision) <= a.ponto_pedido THEN round((a.estoque_maximo - a.saldo_futuro::double precision)::numeric, 2)::double precision
                    WHEN a.status_compra::numeric = 0::numeric AND ('now'::text::date - a.data_ultima_requisicao) > qtde_dias_delay AND a.saldo_futuro::double precision <= a.ponto_pedido THEN round((a.estoque_maximo - a.saldo_futuro::double precision)::numeric, 2)::double precision
                    ELSE 0::double precision
                END AS lote_compras
            FROM (
                SELECT
                    p.id_grupo,
                    p.filial,
                    p.id_produto_combinado,
                    p.compra_transito,
                    sum(getconsumo_transito_filial(p.filial::numeric, spci.idproduto) / spci.fator_conversao) AS consumo_transito,
                    sum(getsaldohorizontefuturo_projetado_filial(p.filial::numeric, spci.idproduto, p.id_grupo::numeric) / spci.fator_conversao) AS saldo_futuro,
                    sum(amplitude_transito_atual_filial(p.filial::numeric, spci.idproduto)) AS amplitude_atual,
                    COALESCE(p.estoque_maximo::double precision, 0::double precision) AS estoque_maximo,
                    COALESCE(p.ponto_pedido::double precision, 0::double precision) AS ponto_pedido,
                    CASE
                        WHEN p.perfil_demanda::text = 'OCASIONAL'::text THEN p.consumo_medio_mensal::double precision / 2::double precision
                        ELSE p.consumo_medio_mensal::double precision
                    END AS consumo_medio_mensal,
                    (
                        SELECT CASE WHEN count(*) > 0 THEN 0 ELSE 1 END
                        FROM entrada_mercadorias
                        WHERE entrada_mercadorias.data_entrada <= 'now'::text::date AND entrada_mercadorias.idproduto::text = ANY (p.produtos) AND entrada_mercadorias.qtde > 0::double PRECISION
                    ) AS status_compra,
                    p.fator_conversao,
                    COALESCE(p.lote_minimo::double precision, 1::double precision) AS lote_minimo,
                    p.data_ultima_requisicao,
                    p.arvore_decisao
                FROM produtos_combinados_compras_filial p
                    INNER JOIN sys_produtos_combinados_itens spci ON spci.id_produto_combinado = p.id_produto_combinado
                WHERE
                    p.compra_transito > 0
                    AND (f_id_produto_combinado = spci.id_produto_combinado OR f_id_produto_combinado IS NULL)
                GROUP BY
                    p.id_grupo,
                    p.filial,
                    p.id_produto_combinado,
                    p.compra_transito,
                    p.estoque_maximo,
                    p.ponto_pedido,
                    p.perfil_demanda,
                    p.consumo_medio_mensal,
                    p.produtos,
                    p.fator_conversao,
                    p.lote_minimo,
                    p.data_ultima_requisicao,
                    p.arvore_decisao
            ) a
            WHERE a.compra_transito > 0::NUMERIC
        ) b
    )
    loop

        update produtos_combinados_transito_filial
        set
            compra_transito = rec_transito.compra_transito,
            consumo_transito = rec_transito.consumo_transito,
            saldo_futuro = rec_transito.saldo_futuro,
            status = rec_transito.status,
            lote_compras = rec_transito.lote_compras,
            data_ultima_requisicao = rec_transito.data_ultima_requisicao,
            tempo_pedido = rec_transito.tempo_pedido,
            gatilho_transito = rec_transito.gatilho_transito,
            flag = NULL,
            processamento = current_timestamp
        where
            id_grupo = rec_transito.id_grupo
            and filial = rec_transito.filial
            and id_produto_combinado = rec_transito.id_produto_combinado;


        if not found then

             insert into produtos_combinados_transito_filial (
                    id_grupo,
                    filial,
                    id_produto_combinado,
                    compra_transito,
                    consumo_transito,
                    saldo_futuro,
                    status,
                    lote_compras,
                    data_ultima_requisicao,
                    tempo_pedido,
                    gatilho_transito,
                    flag,
                    processamento
                )
                values(
                    rec_transito.id_grupo,
                    rec_transito.filial,
                    rec_transito.id_produto_combinado,
                    rec_transito.compra_transito,
                    rec_transito.consumo_transito,
                    rec_transito.saldo_futuro,
                    rec_transito.status,
                    rec_transito.lote_compras,
                    rec_transito.data_ultima_requisicao,
                    rec_transito.tempo_pedido,
                    rec_transito.gatilho_transito,
                    null,
                    current_timestamp
                );

            end if;

        end loop;

    DELETE FROM produtos_combinados_transito_filial WHERE flag ='D';

    end $function$

