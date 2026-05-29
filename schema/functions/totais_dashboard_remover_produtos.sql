CREATE OR REPLACE FUNCTION public.totais_dashboard_remover_produtos(p_tipo character varying, p_id_grupo integer, p_id_parametro bigint, p_adicional_fornecedor bigint DEFAULT NULL::bigint)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
    DECLARE
    produtos_a_remover INT;
    BEGIN
        SELECT COUNT(distinct vw.idproduto)
        INTO produtos_a_remover
        FROM vw_lista_compras_dinamica_grupo vw
        WHERE
            vw.id_grupo = p_id_grupo
            and (case when p_adicional_fornecedor is not null then p_adicional_fornecedor = vw.idfornecedor else true end)
            AND (
            (p_tipo = 'fornecedor' AND vw.idfornecedor = p_id_parametro)
            OR (p_tipo = 'segmento'   AND vw.iddepartamento   = p_id_parametro)
            OR (p_tipo = 'comprador'  AND vw.idcomprador  = p_id_parametro)
        )
        AND vw.idproduto IN (
            SELECT idproduto
                FROM sys_produtos_combinados_itens spci
                WHERE spci.idproduto = vw.idproduto
            );
        RETURN produtos_a_remover;
    END;
    $function$

