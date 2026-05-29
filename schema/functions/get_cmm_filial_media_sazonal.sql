CREATE OR REPLACE FUNCTION public.get_cmm_filial_media_sazonal(p_idfilial integer, p_idproduto character varying, p_data_referencia date DEFAULT ('now'::text)::date)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$
    DECLARE
        parametros record;
        projecao_vendas numeric(12, 4);
        fator_influencia NUMERIC(12, 4);
    BEGIN

        SELECT
            v.data_inicial_vendas,
            v.data_final_vendas,
            v.data_inicial_aplicacao,
            v.data_final_aplicacao,
            v.tipo_influencia,
            v.percentual_influencia
            INTO
            parametros
        FROM sys_tipo_projecao_media_sazonal_produtos_filial v
        WHERE
            v.filial = p_idfilial
            AND v.idproduto = p_idproduto
            AND v.data_final_aplicacao >= current_date
        ORDER BY data_inicial_aplicacao, data_final_aplicacao;

        IF NOT p_data_referencia BETWEEN parametros.data_inicial_aplicacao AND parametros.data_final_aplicacao THEN
            RETURN 0;
        END IF;

        IF parametros.tipo_influencia = 'REDUCAO' THEN
            fator_influencia := (parametros.percentual_influencia / 100::NUMERIC) * -1;
        ELSE
            fator_influencia := (parametros.percentual_influencia / 100::NUMERIC);
        END IF;

        SELECT COALESCE(sum(c.qtde) / NULLIF(EXTRACT(MONTH FROM AGE(parametros.data_final_vendas, parametros.data_inicial_vendas)) + 1, 0), 0) INTO projecao_vendas
        FROM consumos c
        WHERE
            c.filial = p_idfilial
            AND c.idproduto = p_idproduto
            AND c.emissao BETWEEN parametros.data_inicial_vendas AND parametros.data_final_vendas;

        RETURN projecao_vendas + (projecao_vendas * fator_influencia)::NUMERIC;

    END; $function$

