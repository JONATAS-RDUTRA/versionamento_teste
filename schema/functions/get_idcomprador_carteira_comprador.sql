CREATE OR REPLACE FUNCTION public.get_idcomprador_carteira_comprador(p_filial integer, p_produto character varying)
 RETURNS bigint
 LANGUAGE plpgsql
AS $function$
    declare
        produto_rec record;
    begin

        select
           pf.idfornecedor, pf.iddepartamento, pf.idsecao, pf.idcomprador
           into
           produto_rec
        from produtos_filial pf
        where pf.filial = p_filial and pf.idproduto = p_produto;

        RETURN COALESCE(
            (SELECT nullif(pf.idcomprador_systock, 0) FROM produtos_filial pf WHERE pf.filial = p_filial AND pf.idproduto = p_produto LIMIT 1),
            (SELECT nullif(f.idcomprador, 0) FROM fornecedor f WHERE f.id = produto_rec.idfornecedor),
            (SELECT nullif(d.idcomprador, 0) FROM departamentos d WHERE d.iddepartamento::TEXT = produto_rec.iddepartamento),
            (SELECT nullif(s.idcomprador, 0) FROM secao s WHERE s.idsecao::TEXT = produto_rec.idsecao),
            0
        );

    end; $function$

