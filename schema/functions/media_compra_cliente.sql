CREATE OR REPLACE FUNCTION public.media_compra_cliente(idproduto_param character varying, idgrupo_param bigint, filial_param integer DEFAULT NULL::integer)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$
    DECLARE
        media_compra NUMERIC;
    BEGIN
        SELECT
            coalesce((SUM(c.qtde) / COUNT(DISTINCT c.cod_cliente)), 0) INTO media_compra
        FROM consumos c
        INNER JOIN grupo_filial gf ON gf.filial = c.filial 
        WHERE 
            c.emissao BETWEEN current_date - 90 AND current_date
            AND c.idproduto = idproduto_param
            AND gf.id_grupo = idgrupo_param
            AND (filial_param IS NULL OR c.filial = filial_param);

        RETURN media_compra;
    END;
    $function$

