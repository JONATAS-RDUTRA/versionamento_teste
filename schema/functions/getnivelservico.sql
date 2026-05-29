CREATE OR REPLACE FUNCTION public.getnivelservico(classes character varying)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
declare 
    nivel character varying;
begin 

   select descricao_nivel_servico  into nivel from arvore_decisao
 inner join nivel_servico ON nivel_servico.idnivel_servico = arvore_decisao.idnivel_servico
    where arvore_decisao.combinacao = classes;

  
    return nivel;

end;

$function$

