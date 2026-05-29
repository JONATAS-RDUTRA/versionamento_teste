CREATE OR REPLACE FUNCTION public.getpesocompras(classes character varying, class_comprabilidade numeric)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$
declare 
    fator character varying;
begin 

    select peso into fator from matriz_priorizacao where nivel_servico =(select nivel_servico.idnivel_servico from arvore_decisao
                                inner join nivel_servico ON nivel_servico.idnivel_servico = arvore_decisao.idnivel_servico
                                where combinacao=classes)
                                      and nivel_ressuprimento=coalesce(class_comprabilidade,0);

  
    return fator;

end;

$function$

