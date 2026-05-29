CREATE OR REPLACE FUNCTION public.totais_dashboard_adicionar_produtos_combinados(p_tipo character varying, p_id_grupo integer, p_id_parametro bigint, p_adicional_fornecedor bigint DEFAULT NULL::bigint)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
    DECLARE
    produtos_a_adicionar INT;
    BEGIN
        SELECT COUNT(pccg.id_produto_combinado)
        INTO produtos_a_adicionar
        FROM vw_lista_compras_dinamica_produtos_combinados_grupo vwc
        INNER JOIN produtos_combinados_compras_grupo pccg ON pccg.id_grupo = vwc.id_grupo AND pccg.id_produto_combinado = vwc.id_produto_combinado
        WHERE pccg.id_grupo = p_id_grupo
        and (case when p_adicional_fornecedor is not null then p_adicional_fornecedor = ANY(pccg.fornecedores) else true end)
        AND (
            (p_tipo = 'fornecedor' AND p_id_parametro = ANY(pccg.fornecedores))
            OR (p_tipo = 'segmento'   AND p_id_parametro = ANY(pccg.familias_produtos))
            OR (p_tipo = 'comprador'  AND p_id_parametro = ANY(pccg.compradores))
        );
        RETURN produtos_a_adicionar;
    END;
    $function$

