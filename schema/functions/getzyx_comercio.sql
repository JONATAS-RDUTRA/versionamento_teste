CREATE OR REPLACE FUNCTION public.getzyx_comercio(idprod character varying)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
declare 
    pqr character varying;
    class character varying;
begin 

    class = (select classificacao from public.classificacao_criticidade_comercio where idproduto=idprod limit 1);

     if class is null then
     
        class = 'X';
     
     end if;
    
    return class;

end;

$function$

