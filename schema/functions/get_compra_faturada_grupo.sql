CREATE OR REPLACE FUNCTION public.get_compra_faturada_grupo(grupo_id numeric, produto_id character varying)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$
    DECLARE 
        compra_faturada numeric;
    BEGIN 
        select sum(r.qtde_faturada * pf.fator_conversao)
        into compra_faturada
        from requisicoes r
        inner join produtos_filial pf on r.idfilial = pf.filial and r.idproduto = pf.idproduto
        where
            r.idproduto = produto_id
            and r.qtde_pendente > 0
            and r.qtde_faturada > 0
            and r.data_faturamento is not null
            and r.idfilial in (
                select gf.filial
                from grupo_filial gf
                where gf.id_grupo = grupo_id
            );

        if compra_faturada is null then compra_faturada = 0;
        end if;

        return compra_faturada;
    END;
    $function$

