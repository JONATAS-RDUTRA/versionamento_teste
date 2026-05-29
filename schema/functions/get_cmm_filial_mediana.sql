CREATE OR REPLACE FUNCTION public.get_cmm_filial_mediana(p_idfilial integer, p_idproduto character varying, p_data_referencia date DEFAULT ('now'::text)::date)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$
    BEGIN

        RETURN (
            SELECT trunc(sum(c.qtde)::NUMERIC, 4) AS qtde
            FROM consumos c
            WHERE
                c.filial = p_idfilial
                AND c.idproduto = p_idproduto
                AND c.emissao BETWEEN first_day((p_data_referencia - INTERVAL '3 months')::date) AND last_day((p_data_referencia - INTERVAL '1 months')::date)
            GROUP BY to_char(c.emissao, 'YYYY-MM-01')
            ORDER BY 1
            LIMIT 1 OFFSET 1
        );

    END; $function$

