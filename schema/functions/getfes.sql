CREATE OR REPLACE FUNCTION public.getfes(classes character varying)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$
declare 
    fator numeric;
begin 

   select fes  into fator from arvore_decisao
 inner join nivel_servico ON nivel_servico.idnivel_servico = arvore_decisao.idnivel_servico
    where arvore_decisao.combinacao = classes;

  
    return fator;

end;

$function$

