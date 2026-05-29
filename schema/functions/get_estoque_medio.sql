CREATE OR REPLACE FUNCTION public.get_estoque_medio(p_ano numeric, p_mes numeric, produto character varying)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$
declare 
    saldo_ini numeric;
    saldo_fim numeric;
    total numeric;
   
begin 

   total=0;
   	
       select estoque into saldo_ini from saldos where idproduto=produto and ano=p_ano and mes=p_mes and "data" = first_day(data);
      
      
      if  date_part('month',current_date) = p_mes then
      
      	select estoque into saldo_fim from saldos where idproduto=produto and ano=p_ano and mes=p_mes and "data" = (select max(data)  from saldos where idproduto=produto and ano=p_ano and mes=p_mes);
      
        else
        
        select estoque into saldo_fim from saldos where idproduto=produto and ano=p_ano and mes=p_mes and "data" = last_day(data);
       
      end if;  
      
       
      
      total = round((saldo_ini+Saldo_fim)/2,4);
  
   
    return coalesce(total,0);

end;

$function$

