CREATE OR REPLACE FUNCTION public.get_cmm_filial_media_aritmetica_simples(p_idfilial integer, p_idproduto character varying, qtde_meses integer, p_data_referencia date DEFAULT ('now'::text)::date)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$
    DECLARE
        v_data_referencia date;
    BEGIN
        v_data_referencia := to_char(p_data_referencia, 'yyyy-mm-01')::date - 1;
        RETURN (
            SELECT trunc((sum(c.qtde) / qtde_meses)::NUMERIC, 4) AS media
            FROM consumos c
            WHERE
                c.filial = p_idfilial
                AND c.idproduto = p_idproduto
                AND c.emissao BETWEEN (v_data_referencia - make_interval(months := qtde_meses)) AND v_data_referencia
        );

    END; $function$

