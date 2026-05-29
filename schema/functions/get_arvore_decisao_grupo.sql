CREATE OR REPLACE FUNCTION public.get_arvore_decisao_grupo(p_grupo numeric, idprod character varying)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$

declare 

    arv_decisao character varying;

begin 

  select min(classificacao_financeira)||max(classificacao_criticidade)||min(classificacao_comprabilidade)||min(classificacao_popularidade) 
  into arv_decisao from produtos_filial pf inner join grupo_filial gf on gf.filial = pf.filial 
  where gf.id_grupo = p_grupo and  pf.idproduto=idprod; 

 return arv_decisao;
   
end;

$function$

