CREATE OR REPLACE FUNCTION public.valida_oportunidade_venda(idprod character varying, p_ano numeric, p_mes numeric, p_cod_trimestre numeric)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$
declare 
    primeira_saida date;
    venda_trimestre_anterior numeric;
    venda_mes numeric;
begin 
	
	 primeira_saida = (select min(data) from saldos where idproduto = idprod and saidas > 0);

     select count(*) 
         into venda_trimestre_anterior
	    from saldos
	  where idproduto = idprod 
 		and cod_trimestre in(select max(cod_trimestre) from saldos
                                    where idproduto= idprod 
                                     and  cod_trimestre <  p_cod_trimestre )
       and data >= (select min(data) from saldos where idproduto =idprod and saidas > 0);
      
      
      select sum(saidas)  
       into venda_mes
      from saldos where idproduto =idprod and ano= p_ano and mes= p_mes;
     
     
     if venda_trimestre_anterior > 0 then
     
         return 1;
        
       elseif  venda_mes > 0 then
       
         return 1;
        
       else 
     
        return 0;
     
     end if;
    
end;

$function$

