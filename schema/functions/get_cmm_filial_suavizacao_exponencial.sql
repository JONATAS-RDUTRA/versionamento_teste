CREATE OR REPLACE FUNCTION public.get_cmm_filial_suavizacao_exponencial(p_idfilial integer, p_idproduto character varying, p_data_referencia date DEFAULT ('now'::text)::date)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$
    declare
        suavizacao_exponencial suavizacao_exponencial_type;
    BEGIN

        suavizacao_exponencial := get_suavizacao_exponencial_filial(p_idfilial, p_idproduto, p_data_referencia);
        RETURN suavizacao_exponencial.projecoes[array_length(suavizacao_exponencial.projecoes, 1)];

    END; $function$

