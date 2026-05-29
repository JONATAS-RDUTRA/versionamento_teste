CREATE OR REPLACE FUNCTION public.get_suavizacao_exponencial_filial(p_idfilial integer, p_idproduto character varying, p_data_referencia date DEFAULT ('now'::text)::date)
 RETURNS suavizacao_exponencial_type
 LANGUAGE plpgsql
AS $function$
    declare
        qtde_vendido_ultimos_12_meses float;
        coeficiente numeric(3, 2);
        projecoes_coeficiente float[];
        suavizacao_exponencial suavizacao_exponencial_type;
        qtde_diferenca_entre_real_e_projetado float;
    BEGIN

        SELECT COALESCE(sum(c.qtde), 0) INTO qtde_vendido_ultimos_12_meses
        FROM consumos c
        WHERE
            c.filial = p_idfilial
            AND c.idproduto = p_idproduto
            AND c.emissao BETWEEN first_day((p_data_referencia - INTERVAL '11 months')::date) AND last_day(p_data_referencia);

        FOR coeficiente IN (SELECT * FROM generate_series(0.01, 1, .01) AS v1(coeficiente))
        LOOP
            projecoes_coeficiente = get_suavizacao_exponencial_coeficiente(p_idfilial, p_idproduto, coeficiente);

            qtde_diferenca_entre_real_e_projetado = abs(qtde_vendido_ultimos_12_meses - (SELECT COALESCE(SUM(valor), 0) FROM unnest(projecoes_coeficiente) AS v(valor)));

            IF suavizacao_exponencial.qtde_diferenca IS NULL OR qtde_diferenca_entre_real_e_projetado < suavizacao_exponencial.qtde_diferenca THEN
                suavizacao_exponencial.coeficiente := coeficiente;
                suavizacao_exponencial.qtde_diferenca := qtde_diferenca_entre_real_e_projetado;
                suavizacao_exponencial.projecoes := projecoes_coeficiente;
            END IF;

        END LOOP;

        RETURN suavizacao_exponencial;
    END; $function$

