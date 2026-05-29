CREATE OR REPLACE FUNCTION public.get_cmm_filial(p_idfilial numeric, p_idproduto character varying, p_data_referencia date DEFAULT ('now'::text)::date)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$
    DECLARE
        tipo_projecao_vendas varchar(35);
    BEGIN
        SELECT t.tipo INTO tipo_projecao_vendas
        FROM sys_tipos_projecao_vendas_produtos_filial t
        WHERE t.filial = p_idfilial AND t.idproduto = p_idproduto;

        IF tipo_projecao_vendas IS NULL THEN
          RETURN get_cmm_filial_padrao_systock(p_idfilial::int, p_idproduto, p_data_referencia);
        END IF;

        IF tipo_projecao_vendas = 'media_sazonal' THEN
            IF NOT EXISTS (
                SELECT v.*
                FROM sys_tipo_projecao_media_sazonal_produtos_filial v
                WHERE v.filial = p_idfilial AND v.idproduto = p_idproduto AND p_data_referencia BETWEEN v.data_inicial_aplicacao AND v.data_final_aplicacao
            ) THEN
                RETURN get_cmm_filial_padrao_systock(p_idfilial::int, p_idproduto, p_data_referencia);
            END IF;

            RETURN get_cmm_filial_media_sazonal(p_idfilial::int, p_idproduto, p_data_referencia);
        END IF;

        IF tipo_projecao_vendas = 'suavizacao_exponencial' THEN
          RETURN get_cmm_filial_suavizacao_exponencial(p_idfilial::int, p_idproduto, p_data_referencia);
        END IF;

        IF tipo_projecao_vendas = 'media_aritmetica_simples_trimestre' THEN
          RETURN get_cmm_filial_media_aritmetica_simples(p_idfilial::int, p_idproduto, 3, p_data_referencia);
        END IF;

        IF tipo_projecao_vendas = 'media_aritmetica_simples_semestre' THEN
          RETURN get_cmm_filial_media_aritmetica_simples(p_idfilial::int, p_idproduto, 6, p_data_referencia);
        END IF;

        IF tipo_projecao_vendas = 'media_aritmetica_simples_ano' THEN
          RETURN get_cmm_filial_media_aritmetica_simples(p_idfilial::int, p_idproduto, 12, p_data_referencia);
        END IF;

        IF tipo_projecao_vendas = 'media_geometrica' THEN
          RETURN get_cmm_filial_media_geometrica(p_idfilial::int, p_idproduto, p_data_referencia);
        END IF;

        IF tipo_projecao_vendas = 'media_movel_ponderada' THEN
          RETURN get_cmm_filial_media_movel_ponderada(p_idfilial::int, p_idproduto, p_data_referencia);
        END IF;

        IF tipo_projecao_vendas = 'mediana' THEN
          RETURN get_cmm_filial_mediana(p_idfilial::int, p_idproduto, p_data_referencia);
        END IF;

        RETURN get_cmm_filial_padrao_systock(p_idfilial::int, p_idproduto, p_data_referencia);
    END; $function$

