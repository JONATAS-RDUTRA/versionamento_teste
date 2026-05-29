CREATE OR REPLACE FUNCTION public.get_cmm_heranca_produto_combinado(p_idgrupo integer, p_idproduto_combinado character varying, p_filial integer DEFAULT 0)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$
    BEGIN
        return coalesce((
            WITH herancas AS (
                SELECT s.id_produto_combinado, p.idproduto, s.tipo_heranca
                FROM sys_herancas_produtos_combinados s
                    INNER JOIN produtos_filial p ON p.idproduto = s.idproduto_heranca
                WHERE (current_date - s.created_at::date) <= 60 AND s.id_produto_combinado = p_idproduto_combinado
                GROUP BY s.id_produto_combinado, p.idproduto

                UNION ALL

                SELECT s.id_produto_combinado, s2.idproduto, s.tipo_heranca
                FROM sys_herancas_produtos_combinados s
                    INNER JOIN sys_produtos_combinados_itens s2 ON s2.id_produto_combinado = s.idproduto_heranca
                WHERE (current_date - s.created_at::date) <= 60 AND s.id_produto_combinado = p_idproduto_combinado
                GROUP BY s.id_produto_combinado, s2.idproduto
            )
            SELECT
                sum((coalesce(CASE
                    WHEN h.tipo_heranca = 1 THEN get_cmm_heranca_filial(g.filial, h.idproduto, (SELECT min(emissao) + 90 from consumos c where c.filial = g.filial and c.idproduto = h.idproduto))
                    ELSE get_cmm_heranca_filial(g.filial, h.idproduto)
                END, 0))) AS cmm_heranca
            FROM herancas h
                CROSS JOIN grupo_filial g
            WHERE
                g.id_grupo = p_idgrupo
                AND (g.filial = p_filial OR p_filial = 0)
        ), 0);
    END; $function$

