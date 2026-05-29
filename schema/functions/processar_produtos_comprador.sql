CREATE OR REPLACE FUNCTION public.processar_produtos_comprador()
 RETURNS void
 LANGUAGE plpgsql
AS $function$
    DECLARE
        ult_data_referencia date;
        max_data_saldo date;
        existe boolean;
        rec record;
    BEGIN
        SELECT max(data_referencia) IS NULL INTO existe FROM analise_produtos_comprador apc;
        SELECT max(apc.data_referencia) INTO ult_data_referencia::date FROM analise_produtos_comprador apc;
        SELECT max(sf.data) INTO max_data_saldo::date FROM saldo_filiais sf;

        IF existe THEN
            FOR rec IN (
                WITH ult_data_mes AS (
                    SELECT
                        DISTINCT
                        CASE WHEN last_day(to_char(DAY::date, '01/MM/YYYY')::date) > '2022-07-20'::date - 1
                            THEN '2022-07-20'::date - 1
                            ELSE last_day(to_char(DAY::date, '01/MM/YYYY')::date)
                        END AS data_referencia
                    FROM
                        generate_series('2022-07-20'::date - 365, '2022-07-20'::date, '1 day') DAY
                    ORDER BY
                        data_referencia
                ),
                produtos_ressuprimento AS (
                    SELECT
                        '2022-07-20'::date - 1 AS data_referencia,
                        w.filial,
                        w.idfornecedor,
                        w.idcomprador,
                        count(*) AS qtde_itens_ressuprir,
                        COALESCE(round(sum(w.sugestao * pf.preco_compra)::NUMERIC, 2), 0) AS tot_ressuprir
                    FROM
                        vw_lista_compras_dinamica_grupo_filial w
                    JOIN produtos_filial AS pf ON pf.filial = w.filial AND pf.idproduto = w.idproduto
                    WHERE
                        (w.idfornecedor, w.idproduto) NOT IN (
                            SELECT
                                npb.idfornecedor ,
                                npb.idproduto
                            FROM
                                notificacao_produtos_blacklist npb
                            WHERE
                                data_limite >= '2022-07-20'::date
                                AND deleted_at IS NULL
                        )
                    GROUP BY
                        w.filial,
                        w.idfornecedor,
                        w.idcomprador
                )
                SELECT
                    udms.data_referencia,
                    sf.ano,
                    sf.mes,
                    gf.id_grupo,
                    sf.filial,
                    f.id AS idfornecedor,
                    c.id AS idcomprador,
                    COALESCE(sum(sf.emax * pf.custo_unitario), 0) AS  custo_emax,
                    COALESCE(sum(sf.estoque * pf.custo_unitario), 0) AS  custo_estoque,
                    COALESCE(count(DISTINCT sf.idproduto), 0) AS  qtde_total_produto,
                    COALESCE(count(1) FILTER (WHERE sf.estoque > sf.emax), 0) AS qtde_produtos_excesso,
                    COALESCE(sum(sf.estoque * pf.custo_unitario) FILTER (WHERE sf.estoque > sf.emax AND pf.consumo_medio_mensal > 0), 0) AS valor_excesso,
                    COALESCE(count(1) FILTER (WHERE sf.estoque > sf.ppd AND sf.estoque < sf.emax), 0) AS qtde_produtos_adequado,
                    COALESCE(count(1) FILTER (WHERE pf.consumo_medio_mensal > 0 AND sf.estoque < sf.ppd), 0) AS qtde_produtos_a_comprar,
                    COALESCE(count(1) FILTER (WHERE sf.estoque = 0), 0) AS qtde_produtos_zerados,
                    COALESCE(count(pr.qtde_itens_ressuprir), 0) AS qtde_produtos_transito,
                    COALESCE(sum(pr.tot_ressuprir), 0) AS compra_prevista,
                    COALESCE(sum(sf.estoque * pf.custo_unitario), 0) AS total_estoque_periodo
                FROM
                    saldo_filiais AS sf
                    JOIN ult_data_mes AS udms ON udms.data_referencia = sf.DATA
                    LEFT JOIN requisicoes r ON r.idfilial = sf.filial
                        AND r.idproduto = sf.idproduto
                        AND to_char(r.data_solicitacao, '01/MM/YYYY')::date = first_day(udms.data_referencia)
                        AND r.qtde <> r.qtde_entregue
                        AND r.qtde_pendente > 0
                    JOIN produtos_filial AS pf ON pf.filial = sf.filial
                        AND pf.idproduto = sf.idproduto
                    LEFT JOIN produtos_ressuprimento pr ON pr.filial = pf.filial
                        AND pr.idfornecedor = pf.idfornecedor
                        AND pr.idcomprador = pf.idcomprador
                        AND pr.data_referencia = udms.data_referencia
                    JOIN grupo_filial AS gf ON gf.filial = sf.filial
                    JOIN comprador AS c ON c.id = pf.idcomprador
                    JOIN fornecedor AS f ON f.id = pf.idfornecedor
                GROUP BY
                    udms.data_referencia,
                    sf.ano,
                    sf.mes,
                    gf.id_grupo,
                    sf.filial,
                    f.id,
                    c.id
            )
            LOOP
                INSERT INTO analise_produtos_comprador (
                    data_referencia,
                    ano,
                    mes,
                    id_grupo,
                    filial,
                    idfornecedor,
                    idcomprador,
                    qtde_total_produto,
                    qtde_produtos_excesso,
                    valor_excesso,
                    excesso_toleravel,
                    diferenca_dinheiro,
                    excesso_realizado,
                    qtde_produtos_adequado,
                    qtde_produtos_a_comprar,
                    qtde_produtos_zerados,
                    qtde_produtos_transito,
                    compra_prevista,
                    total_estoque_periodo
                ) VALUES (
                    rec.data_referencia,
                    rec.ano,
                    rec.mes,
                    rec.id_grupo,
                    rec.filial,
                    rec.idfornecedor,
                    rec.idcomprador,
                    rec.qtde_total_produto,
                    rec.qtde_produtos_excesso,
                    rec.valor_excesso,
                    rec.custo_emax * 0.18,
                    GREATEST(rec.custo_estoque -    (rec.custo_emax + rec.custo_emax * 0.18), 0),
                    GREATEST(COALESCE((rec.custo_emax - rec.custo_estoque) / NULLIF(rec.custo_estoque, 0)) * 100, 0),
                    rec.qtde_produtos_adequado,
                    rec.qtde_produtos_a_comprar,
                    rec.qtde_produtos_zerados,
                    rec.qtde_produtos_transito,
                    rec.compra_prevista,
                    rec.total_estoque_periodo
                );
            END LOOP;
        ELSE
            FOR rec IN (
                WITH produtos_ressuprimento AS (
                    SELECT
                        '2022-07-20'::date - 1 AS data_referencia,
                        w.filial,
                        w.idfornecedor,
                        w.idcomprador,
                        count(DISTINCT w.idproduto) AS qtde_itens_ressuprir,
                        COALESCE(round(sum(w.sugestao * pf.preco_compra)::NUMERIC, 2), 0) AS tot_ressuprir
                    FROM
                        vw_lista_compras_dinamica_grupo_filial w
                    JOIN produtos_filial AS pf ON pf.filial = w.filial AND pf.idproduto = w.idproduto
                    WHERE
                        (w.idfornecedor, w.idproduto) NOT IN (
                            SELECT
                                npb.idfornecedor ,
                                npb.idproduto
                            FROM
                                notificacao_produtos_blacklist npb
                            WHERE
                                data_limite >= '2022-07-20'::date - 1
                                AND deleted_at IS NULL
                        )
                    GROUP BY
                        data_referencia,
                        w.filial,
                        w.idfornecedor,
                        w.idcomprador
                ),
                dados AS (
                    SELECT
                        '2022-07-20'::date - 1 AS data_referencia,
                        sf.ano,
                        sf.mes,
                        gf.id_grupo,
                        sf.filial,
                        f.id AS idfornecedor,
                        c.id AS idcomprador,
                        COALESCE(sum(sf.emax * pf.custo_unitario), 0) AS  custo_emax,
                        COALESCE(sum(sf.estoque * pf.custo_unitario), 0) AS  custo_estoque,
                        COALESCE(count(DISTINCT sf.idproduto), 0) AS  qtde_total_produto,
                        COALESCE(count(1) FILTER (WHERE sf.estoque > sf.emax), 0) AS qtde_produtos_excesso,
                        COALESCE(sum(sf.estoque * pf.custo_unitario) FILTER (WHERE sf.estoque > sf.emax AND pf.consumo_medio_mensal > 0), 0) AS valor_excesso,
                        COALESCE(count(1) FILTER (WHERE sf.estoque > sf.ppd AND sf.estoque < sf.emax), 0) AS qtde_produtos_adequado,
                        COALESCE(count(1) FILTER (WHERE pf.consumo_medio_mensal > 0 AND sf.estoque < sf.ppd), 0) AS qtde_produtos_a_comprar,
                        COALESCE(count(1) FILTER (WHERE sf.estoque = 0), 0) AS qtde_produtos_zerados,
                        COALESCE(sum(sf.estoque * pf.custo_unitario), 0) AS total_estoque_periodo
                    FROM
                        saldo_filiais AS sf
                    JOIN produtos_filial AS pf ON pf.filial = sf.filial
                        AND pf.idproduto = sf.idproduto
                    JOIN grupo_filial AS gf ON gf.filial = pf.filial
                    JOIN comprador AS c ON c.id = pf.idcomprador
                    JOIN fornecedor AS f ON f.id = pf.idfornecedor
                    WHERE
                        sf."data" = '2022-07-20'::date - 1
                    GROUP BY
                        sf.ano,
                        sf.mes,
                        gf.id_grupo,
                        sf.filial,
                        f.id,
                        c.id
                )
                SELECT
                    d.*,
                    COALESCE((pr.qtde_itens_ressuprir), 0) AS qtde_produtos_transito,
                    COALESCE((pr.tot_ressuprir), 0) AS compra_prevista
                FROM
                    dados AS d
                LEFT JOIN produtos_ressuprimento pr ON pr.filial = d.filial
                    AND pr.idfornecedor = d.idfornecedor
                    AND pr.idcomprador = d.idcomprador
            )
            LOOP
                IF max_data_saldo = last_day('2022-07-20'::date) THEN
                    INSERT INTO analise_produtos_comprador (
                        data_referencia,
                        ano,
                        mes,
                        id_grupo,
                        filial,
                        idfornecedor,
                        idcomprador,
                        qtde_total_produto,
                        qtde_produtos_excesso,
                        valor_excesso,
                        excesso_toleravel,
                        diferenca_dinheiro,
                        excesso_realizado,
                        qtde_produtos_adequado,
                        qtde_produtos_a_comprar,
                        qtde_produtos_zerados,
                        total_estoque_periodo,
                        compra_prevista,
                        qtde_produtos_transito
                    ) VALUES (
                        rec.data_referencia,
                        rec.ano,
                        rec.mes,
                        rec.id_grupo,
                        rec.filial,
                        rec.idfornecedor,
                        rec.idcomprador,
                        rec.qtde_total_produto,
                        rec.qtde_produtos_excesso,
                        rec.valor_excesso,
                        rec.custo_emax * 0.18,
                        GREATEST(rec.custo_estoque -    (rec.custo_emax + rec.custo_emax * 0.18), 0),
                        GREATEST(COALESCE((rec.custo_emax - rec.custo_estoque) / NULLIF(rec.custo_estoque, 0)) * 100, 0),
                        rec.qtde_produtos_adequado,
                        rec.qtde_produtos_a_comprar,
                        rec.qtde_produtos_zerados,
                        rec.total_estoque_periodo,
                        rec.compra_prevista,
                        rec.qtde_produtos_transito
                    );
                ELSE
                    UPDATE analise_produtos_comprador
                    SET
                        data_referencia = rec.data_referencia,
                        ano = rec.ano,
                        mes = rec.mes,
                        id_grupo = rec.id_grupo,
                        filial = rec.filial,
                        idfornecedor = rec.idfornecedor,
                        idcomprador = rec.idcomprador,
                        qtde_total_produto = rec.qtde_total_produto,
                        qtde_produtos_excesso = rec.qtde_produtos_excesso,
                        valor_excesso = rec.valor_excesso,
                        excesso_toleravel = rec.custo_emax * 0.18,
                        qtde_produtos_adequado = rec.qtde_produtos_adequado,
                        qtde_produtos_a_comprar = rec.qtde_produtos_a_comprar,
                        qtde_produtos_zerados = rec.qtde_produtos_zerados,
                        total_estoque_periodo = rec.total_estoque_periodo,
                        qtde_produtos_transito = rec.qtde_produtos_transito,
                        compra_prevista = rec.compra_prevista
                    WHERE data_referencia = max_data_saldo - 1;

                    IF NOT FOUND THEN
                        INSERT INTO analise_produtos_comprador (
                            data_referencia,
                            ano,
                            mes,
                            id_grupo,
                            filial,
                            idfornecedor,
                            idcomprador,
                            qtde_total_produto,
                            qtde_produtos_excesso,
                            valor_excesso,
                            excesso_toleravel,
                            diferenca_dinheiro,
                            excesso_realizado,
                            qtde_produtos_adequado,
                            qtde_produtos_a_comprar,
                            qtde_produtos_zerados,
                            total_estoque_periodo,
                            compra_prevista,
                            qtde_produtos_transito
                        ) VALUES (
                            rec.data_referencia,
                            rec.ano,
                            rec.mes,
                            rec.id_grupo,
                            rec.filial,
                            rec.idfornecedor,
                            rec.idcomprador,
                            rec.qtde_total_produto,
                            rec.qtde_produtos_excesso,
                            rec.valor_excesso,
                            rec.custo_emax * 0.18,
                            GREATEST(rec.custo_estoque -    (rec.custo_emax + rec.custo_emax * 0.18), 0),
                            GREATEST(COALESCE((rec.custo_emax - rec.custo_estoque) / NULLIF(rec.custo_estoque, 0)) * 100, 0),
                            rec.qtde_produtos_adequado,
                            rec.qtde_produtos_a_comprar,
                            rec.qtde_produtos_zerados,
                            rec.total_estoque_periodo,
                            rec.compra_prevista,
                            rec.qtde_produtos_transito
                        );
                    END IF;
                END IF;
            END LOOP;
        END IF;
    END;
$function$

