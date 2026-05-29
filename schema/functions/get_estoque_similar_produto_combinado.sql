CREATE OR REPLACE FUNCTION public.get_estoque_similar_produto_combinado(p_idgrupo integer, p_filial integer, p_idproduto character varying)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$
    DECLARE
    BEGIN
        return coalesce((
            SELECT sum(greatest(p.estoque - COALESCE(p.estoque_similar, 0), 0))
            FROM produtos_filial p
                inner join grupo_filial g ON g.filial = p.filial
            WHERE
                g.id_grupo = p_idgrupo
                AND (p.filial = p_filial OR p_filial = 0)
                AND p.idproduto IN (
                    SELECT i.idproduto
                    FROM similares s
                        INNER JOIN sys_produtos_combinados_itens i ON i.id_produto_combinado = s.id_item_filho
                    WHERE s.agregar_estoque = 'S' AND s.id_item_pai = p_idproduto

                    UNION ALL

                    SELECT s.id_item_filho
                    FROM similares s
                    WHERE s.agregar_estoque = 'S' AND s.id_item_pai = p_idproduto AND substring(s.id_item_filho, 0, 8) <> 'SYSCOMB'
                )
        ), 0);
    END;
    $function$

