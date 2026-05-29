CREATE OR REPLACE FUNCTION public.get_suavizacao_exponencial_coeficiente(p_idfilial integer, p_idproduto character varying, p_coeficiente numeric, p_data_referencia date DEFAULT CURRENT_DATE)
 RETURNS double precision[]
 LANGUAGE plpgsql
AS $function$
    declare
        data_referencia_loop date;
        qtde_vendido_mes_anterior float;
        projecoes_mensal float[];
    BEGIN
        FOR data_referencia_loop IN (
            SELECT date_trunc('month', v1.referencia)::date
            FROM generate_series(p_data_referencia - INTERVAL '11 months', p_data_referencia, INTERVAL '1 month') AS v1(referencia)
        )
        LOOP
            SELECT COALESCE(sum(c.qtde), 0) INTO qtde_vendido_mes_anterior
            FROM consumos c
            WHERE
                c.filial = p_idfilial
                AND c.idproduto = p_idproduto
                AND date_part('year', c.emissao) = date_part('year', data_referencia_loop - INTERVAL '1 month')
                AND date_part('month', c.emissao) = date_part('month', data_referencia_loop - INTERVAL '1 month');

            IF array_length(projecoes_mensal, 1) IS NULL THEN
                projecoes_mensal := array_append(projecoes_mensal, qtde_vendido_mes_anterior);
                CONTINUE;
            END IF;

            projecoes_mensal := array_append(
                projecoes_mensal,
                (p_coeficiente * qtde_vendido_mes_anterior) + (1 - p_coeficiente) * projecoes_mensal[array_length(projecoes_mensal, 1)]
            );
        END LOOP;

        RETURN projecoes_mensal;
    END; $function$

