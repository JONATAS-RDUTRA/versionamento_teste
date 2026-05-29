CREATE OR REPLACE FUNCTION public.get_estoque_produto_filial_em_analise_de_lote(p_filial integer, p_produto character varying)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$
    begin

        return COALESCE((
            SELECT sum(lp.qtde) FILTER (WHERE lp.qtde > (case
                    when spapl.tipo_ponto_pedido then spapl.ponto_pedido_fixo
                    else media_compra_cliente(spapl.idproduto, gf.id_grupo::bigint) * spapl.ponto_pedido_percentual_influencia
                end) * spapl.ponta_estoque_percentual)
            FROM sys_produtos_analise_por_lotes spapl
                INNER JOIN grupo_filial gf ON gf.filial = spapl.filial
                LEFT JOIN lote_produtos lp ON lp.filial = spapl.filial
                    AND lp.idproduto = spapl.idproduto
            where spapl.filial = p_filial and spapl.idproduto = p_produto
        ), 0);

    end; $function$

