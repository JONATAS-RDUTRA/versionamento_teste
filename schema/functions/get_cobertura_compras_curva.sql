CREATE OR REPLACE FUNCTION public.get_cobertura_compras_curva(p_filial integer, p_produto character varying)
 RETURNS bigint
 LANGUAGE plpgsql
AS $function$
declare 
    produto_rec record;
    curvas_produto_rec record;
begin 
    
    select 
       idfornecedor, 
       idfamilia_produto 
       into 
       produto_rec 
    from produtos_filial pf 
    where pf.filial = p_filial and pf.idproduto = p_produto;
    
    select 
        substring(arvore_decisao, 4, 1) AS pqr,
        substring(arvore_decisao, 2, 1) AS xyz
        into
        curvas_produto_rec
    from prismas_grupos pg 
    where 
       id_grupo in (select id_grupo from grupo_filial gf where filial = p_filial) 
       and idproduto = p_produto and data_ref = first_day(current_date); 


    RETURN COALESCE(
        (SELECT v.tempo_cobertura FROM tempo_cobertura_compras_produtos v WHERE v.idproduto = p_produto AND v.deleted_at IS NULL),
        (SELECT v.tempo_cobertura FROM tempo_cobertura_compras_fornecedor v WHERE v.idfornecedor = produto_rec.idfornecedor AND v.deleted_at IS NULL),
        (SELECT v.tempo_cobertura FROM tempo_cobertura_compras_segmentos v WHERE v.idfamilia_produto = produto_rec.idfamilia_produto AND v.deleted_at IS NULL),
        (SELECT v.tempo_cobertura FROM tempo_cobertura_compras v WHERE v.filial = p_filial AND v.pqr = curvas_produto_rec.pqr AND v.xyz = curvas_produto_rec.xyz AND v.deleted_at IS NULL),
        0
    );
   
end;

$function$

