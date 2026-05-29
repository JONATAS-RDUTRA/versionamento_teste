CREATE OR REPLACE FUNCTION public.gerar_prismas_rentabilidade_filiais(p_filial integer)
 RETURNS TABLE(idproduto character varying, classificacao_rentabilidade character varying)
 LANGUAGE sql
AS $function$
    WITH _produtos AS (
        SELECT
            pf.filial ,
            pf.idproduto,
            pf.descricao_produto ,
            pf.valor_unitario,
            pf.custo_unitario,
            pf.preco_medio_venda,
            pf.consumo_medio_mensal,
            COALESCE((pf.preco_medio_venda-pf.custo_unitario * pf.consumo_medio_mensal), 0) prej_rentabilidade
        FROM produtos_filial pf
        WHERE pf.filial = p_filial
    ),
    _produtos_com_percentual_rentablidade AS (
        SELECT
            p.filial,
            p.idproduto,
            p.prej_rentabilidade,
            (p.prej_rentabilidade / NULLIF(sum(p.prej_rentabilidade) OVER(), 0)) AS perc_rentabilidade
        FROM
            _produtos p
    )
    SELECT
        p.idproduto,
        CASE
            WHEN sum(p.perc_rentabilidade) OVER (ORDER BY p.prej_rentabilidade DESC) <= 0.8 THEN 'A'
            WHEN sum(p.perc_rentabilidade) OVER (ORDER BY p.prej_rentabilidade DESC) > 0.8 AND sum(p.perc_rentabilidade) OVER (ORDER BY p.prej_rentabilidade DESC) <= 0.95 THEN 'B'
            ELSE 'C'
        END AS classificacao_rentabilidade
    FROM _produtos_com_percentual_rentablidade p
$function$

