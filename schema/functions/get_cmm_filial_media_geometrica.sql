CREATE OR REPLACE FUNCTION public.get_cmm_filial_media_geometrica(p_idfilial integer, p_idproduto character varying, p_data_referencia date DEFAULT ('now'::text)::date)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$
    DECLARE
        qtde_vendida_mensal float[];
        value numeric;
        qtde_vendida_mensal_multiplicado numeric := 1.0;
    BEGIN

        qtde_vendida_mensal := ARRAY(
            SELECT trunc(sum(c.qtde)::NUMERIC, 4) AS qtde
            FROM consumos c
            WHERE
                c.filial = p_idfilial
                AND c.idproduto = p_idproduto
                AND c.emissao BETWEEN first_day((p_data_referencia - INTERVAL '3 months')::date) AND last_day((p_data_referencia - INTERVAL '1 months')::date)
            GROUP BY to_char(c.emissao, 'YYYY-MM-01')
        );

        FOREACH value IN ARRAY qtde_vendida_mensal LOOP
            qtde_vendida_mensal_multiplicado := qtde_vendida_mensal_multiplicado * value;
        END LOOP;


        IF qtde_vendida_mensal_multiplicado < 0 THEN
            RETURN 0;
        END IF;

        RETURN POWER(qtde_vendida_mensal_multiplicado, 1.0 / NULLIF(array_length(qtde_vendida_mensal, 1), 0));

    END; $function$

