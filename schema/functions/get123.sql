CREATE OR REPLACE FUNCTION public.get123(idprod character varying)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
declare 
    complex_compra character varying;
begin 

    select complexibilidade_compra into complex_compra from parametros_compra where  ceil(getTMR(idprod))  between range_inicial and range_final;
    
    return complex_compra;

end;

$function$

