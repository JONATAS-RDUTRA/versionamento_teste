CREATE OR REPLACE FUNCTION public.get_quantidade_meses_movimentacoes_ultimo_semestre(p_grupo bigint, p_filial bigint, p_produto character varying)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
    BEGIN
        IF substring(p_produto, 0, 8) = 'SYSCOMB' THEN
            return (
                SELECT count(DISTINCT to_char(c.DATA, 'yyyy-mm-01')::date)
                FROM (
                    SELECT to_char(c.emissao, 'yyyy-mm-01')::date AS DATA, sum(c.qtde) AS qtde
                    FROM consumos c
                    WHERE
                        c.emissao BETWEEN current_date - 180 AND current_date
                        AND c.filial IN (SELECT gf.filial FROM grupo_filial gf WHERE gf.id_grupo = p_grupo)
                        AND (c.filial = p_filial OR p_filial = 0)
                        AND exists(
                            SELECT 1
                            FROM sys_produtos_combinados_itens i
                            WHERE i.id_produto_combinado = p_produto AND i.idproduto = c.idproduto
                        )
                    GROUP BY to_char(c.emissao, 'yyyy-mm-01')
                ) c
                WHERE qtde > 0
            );
        END IF;

        return (
            SELECT count(DISTINCT to_char(c.DATA, 'yyyy-mm-01')::date)
            FROM (
                SELECT to_char(c.emissao, 'yyyy-mm-01')::date AS DATA, sum(c.qtde) AS qtde
                FROM consumos c
                WHERE
                    c.emissao BETWEEN current_date - 180 AND current_date
                    AND c.filial IN (SELECT gf.filial FROM grupo_filial gf WHERE gf.id_grupo = p_grupo)
                    AND (c.filial = p_filial OR p_filial = 0)
                    AND c.idproduto = p_produto
                GROUP BY to_char(c.emissao, 'yyyy-mm-01')
            ) c
            WHERE qtde > 0
        );
    END; $function$

