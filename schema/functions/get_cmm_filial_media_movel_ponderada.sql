CREATE OR REPLACE FUNCTION public.get_cmm_filial_media_movel_ponderada(p_idfilial integer, p_idproduto character varying, p_data_referencia date DEFAULT ('now'::text)::date)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$
    DECLARE
        qtde_vendida_mensal float[];
        qtde_vendida_acumulada numeric;
    BEGIN

        qtde_vendida_mensal := ARRAY(
            WITH referencias AS (
                SELECT DISTINCT to_char(v.referencia, 'YYYY-MM-01')::date AS referencia
                FROM generate_series((p_data_referencia - INTERVAL '3 months')::date, p_data_referencia - INTERVAL '1 months', '1 month') AS v(referencia)
            ),
            vendas AS (
                SELECT
                    to_char(c.emissao, 'YYYY-MM-01')::date AS referencia,
                    trunc(sum(COALESCE(c.qtde, 0))::NUMERIC, 4) AS qtde
                FROM consumos c
                WHERE
                    c.filial = p_idfilial
                    AND c.idproduto = p_idproduto
                    AND c.emissao BETWEEN first_day((p_data_referencia - INTERVAL '3 months')::date) AND last_day((p_data_referencia - INTERVAL '1 months')::date)
                GROUP BY to_char(c.emissao, 'YYYY-MM-01')
            )
            SELECT COALESCE(v.qtde, 0) AS qtde
            FROM referencias r
                LEFT JOIN vendas v ON v.referencia = r.referencia
        );

        FOR chave IN 1 .. array_length(qtde_vendida_mensal, 1) LOOP
            qtde_vendida_acumulada = coalesce(qtde_vendida_acumulada, 0) + (chave * qtde_vendida_mensal[chave]);
        END LOOP;

        RETURN (qtde_vendida_acumulada / 6)::NUMERIC(12, 4);

    END; $function$

