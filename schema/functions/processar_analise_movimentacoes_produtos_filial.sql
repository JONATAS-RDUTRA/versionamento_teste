CREATE OR REPLACE FUNCTION public.processar_analise_movimentacoes_produtos_filial(data_inicial date DEFAULT CURRENT_DATE, filtro_sql text DEFAULT ''::text)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
    DECLARE
        rec_cruzamento_produtos_tempos record;
        query TEXT;
    BEGIN
        data_inicial = to_char(data_inicial, '01/MM/YYYY')::date;

        query = FORMAT($$
            WITH tempos AS (
                SELECT DISTINCT
                    to_char(day::date, 'YYYY')::int as ano,
                    to_char(day::date, 'MM')::int as mes
                FROM
                    generate_series($1, current_date, '1 day') day
            ),
            cruzamento_produtos_tempos AS (
                SELECT
                    t.mes,
                    t.ano,
                    pf.filial,
                    pf.idproduto
                FROM produtos_filial pf
                    INNER JOIN tempos t ON TRUE
                    INNER JOIN grupo_filial gf ON gf.filial = pf.filial
                    INNER JOIN grupo_compras gc ON gc.id = gf.id_grupo AND gc.grupo_agrega <> 'S'
            ),
            saidas AS (
                SELECT
                    to_char(c.emissao, 'MM')::int AS mes,
                    to_char(c.emissao, 'YYYY')::int AS ano,
                    c.filial,
                    c.idproduto,
                    sum(c.qtde) AS quantidade,
                    sum(c.qtde * c.valor_unit) AS valor
                FROM consumos c
                WHERE
                    c.emissao >= $1
                    AND c.status NOT IN (SELECT scpo.descricao FROM status_consumos_para_ocultar scpo)
                GROUP BY
                    to_char(c.emissao, 'MM')::int,
                    to_char(c.emissao, 'YYYY')::int,
                    c.filial,
                    c.idproduto
            ),
            compras AS (
                SELECT
                    to_char(r.data_solicitacao, 'MM')::int AS mes,
                    to_char(r.data_solicitacao, 'YYYY')::int AS ano,
                    r.idfilial AS filial,
                    r.idproduto,
                    sum(r.qtde) AS quantidade,
                    sum(r.qtde * r.pcompra) AS valor
                FROM requisicoes r
                WHERE r.data_solicitacao >= $1
                GROUP BY
                    to_char(r.data_solicitacao, 'MM')::int,
                    to_char(r.data_solicitacao, 'YYYY')::int,
                    r.idfilial,
                    r.idproduto
            ),
            entradas AS (
                SELECT
                    to_char(e.data_entrada, 'MM')::int AS mes,
                    to_char(e.data_entrada, 'YYYY')::int AS ano,
                    e.idfilial AS filial,
                    e.idproduto,
                    sum(e.qtde) AS quantidade,
                    sum(e.qtde * e.custo_unit) AS valor
                FROM entrada_mercadorias e
                WHERE e.data_entrada >= $1
                GROUP BY
                    to_char(e.data_entrada, 'MM')::int,
                    to_char(e.data_entrada, 'YYYY')::int,
                    e.idfilial,
                    e.idproduto
            ),
            saldos_filial_inicio_mes AS (
                SELECT
                    sf.filial,
                    sf.ano,
                    sf.mes,
                    sf.idproduto,
                    SUM(estoque) AS soma_estoque_inicio
                FROM saldo_filiais sf
                WHERE "data" = to_char("data", '01/mm/yyyy')::date AND sf."data" >= $1
                GROUP BY
                    date_trunc('month', "data"),
                    sf.filial,
                    sf.ano,
                    sf.mes,
                    sf.idproduto
            ),
            saldos_filial_final_mes AS (
                WITH datas AS (
                    SELECT sf.filial, sf.idproduto, max(sf.data) AS data
                    FROM saldo_filiais sf
                    GROUP BY sf.filial, sf.idproduto, sf.ano, sf.mes
                )
                SELECT
                    sf.filial,
                    sf.ano,
                    sf.mes,
                    sf.idproduto,
                    SUM(sf.estoque) AS soma_estoque_final
                FROM saldo_filiais sf
                    INNER JOIN datas d ON (d.filial, d.idproduto, d.data) = (sf.filial, sf.idproduto, sf.data)
                GROUP BY
                    sf.filial,
                    sf.ano,
                    sf.mes,
                    sf.idproduto
            )
            SELECT
                cpt.mes::int,
                cpt.ano::int,
                cpt.filial::int,
                cpt.idproduto::varchar,
                COALESCE(s.quantidade, 0)::NUMERIC AS qtde_saidas,
                COALESCE(s.valor, 0)::NUMERIC AS valor_saidas,
                COALESCE(c.quantidade, 0)::NUMERIC AS qtde_compras,
                COALESCE(c.valor, 0)::NUMERIC AS valor_compras,
                COALESCE(e.quantidade, 0)::NUMERIC AS qtde_entradas,
                COALESCE(e.valor, 0)::NUMERIC AS valor_entradas,
                COALESCE(round((coalesce(im.soma_estoque_inicio,0) + coalesce(fm.soma_estoque_final,0)) / 2, 4), 0)::NUMERIC AS estoque_medio_filial
            FROM cruzamento_produtos_tempos cpt
                LEFT JOIN saidas s ON s.filial = cpt.filial AND s.idproduto = cpt.idproduto AND s.mes = cpt.mes AND s.ano = cpt.ano
                LEFT JOIN compras c ON c.filial = cpt.filial AND c.idproduto = cpt.idproduto AND c.mes = cpt.mes AND c.ano = cpt.ano
                LEFT JOIN entradas e ON e.filial = cpt.filial AND e.idproduto = cpt.idproduto AND e.mes = cpt.mes AND e.ano = cpt.ano
                LEFT JOIN saldos_filial_inicio_mes AS im ON im.ano = cpt.ano AND im.mes = cpt.mes AND im.idproduto = cpt.idproduto AND im.filial = cpt.filial
                LEFT JOIN saldos_filial_final_mes AS fm ON fm.ano = cpt.ano AND fm.mes = cpt.mes AND fm.idproduto = cpt.idproduto AND fm.filial = cpt.filial
            WHERE
                (GREATEST(s.quantidade, c.quantidade, e.quantidade, im.soma_estoque_inicio, fm.soma_estoque_final, 0) > 0 or exists(
                    SELECT ampf.*
                    FROM analise_movimentacoes_produtos_filial ampf
                    WHERE ampf.ano = cpt.ano::int AND ampf.mes = cpt.mes::int AND ampf.filial = cpt.filial::int AND ampf.idproduto = cpt.idproduto::varchar
                ))
                %s
        $$, filtro_sql);

        FOR rec_cruzamento_produtos_tempos IN EXECUTE query USING data_inicial
        LOOP
            UPDATE analise_movimentacoes_produtos_filial
            SET
                mes = rec_cruzamento_produtos_tempos.mes,
                ano = rec_cruzamento_produtos_tempos.ano,
                filial = rec_cruzamento_produtos_tempos.filial,
                idproduto = rec_cruzamento_produtos_tempos.idproduto,
                qtde_saidas = rec_cruzamento_produtos_tempos.qtde_saidas,
                valor_saidas = rec_cruzamento_produtos_tempos.valor_saidas,
                qtde_compras = rec_cruzamento_produtos_tempos.qtde_compras,
                valor_compras = rec_cruzamento_produtos_tempos.valor_compras,
                qtde_entradas = rec_cruzamento_produtos_tempos.qtde_entradas,
                valor_entradas = rec_cruzamento_produtos_tempos.valor_entradas,
                estoque_medio_filial = rec_cruzamento_produtos_tempos.estoque_medio_filial
            WHERE
                mes = rec_cruzamento_produtos_tempos.mes
                AND ano = rec_cruzamento_produtos_tempos.ano
                AND filial = rec_cruzamento_produtos_tempos.filial
                AND idproduto = rec_cruzamento_produtos_tempos.idproduto;

            IF NOT FOUND THEN
                INSERT INTO analise_movimentacoes_produtos_filial (
                    mes,
                    ano,
                    filial,
                    idproduto,
                    qtde_saidas,
                    valor_saidas,
                    qtde_compras,
                    valor_compras,
                    qtde_entradas,
                    valor_entradas,
                    estoque_medio_filial
                )
                VALUES (
                    rec_cruzamento_produtos_tempos.mes,
                    rec_cruzamento_produtos_tempos.ano,
                    rec_cruzamento_produtos_tempos.filial,
                    rec_cruzamento_produtos_tempos.idproduto,
                    rec_cruzamento_produtos_tempos.qtde_saidas,
                    rec_cruzamento_produtos_tempos.valor_saidas,
                    rec_cruzamento_produtos_tempos.qtde_compras,
                    rec_cruzamento_produtos_tempos.valor_compras,
                    rec_cruzamento_produtos_tempos.qtde_entradas,
                    rec_cruzamento_produtos_tempos.valor_entradas,
                    rec_cruzamento_produtos_tempos.estoque_medio_filial
                );
            END IF;
        END LOOP;
    END;
    $function$

