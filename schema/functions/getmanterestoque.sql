CREATE OR REPLACE FUNCTION public.getmanterestoque(classes character varying)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
declare 
    manter character varying;
begin 

   select manter_estoque  into manter from arvore_decisao
 inner join nivel_servico ON nivel_servico.idnivel_servico = arvore_decisao.idnivel_servico
    where arvore_decisao.combinacao = classes;

  
    return manter;

end;

$function$

