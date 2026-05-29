CREATE OR REPLACE FUNCTION public.get_estoque_medio_grupo(p_grupo numeric, p_ano numeric, p_mes numeric, produto character varying)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$
declare 
    saldo_ini numeric;
    saldo_fim numeric;
    total numeric;
   
begin 

   total=0;
   	
       select sum(estoque) into saldo_ini from saldo_filiais sf where filial in(select filial from grupo_filial gf where gf.id_grupo=p_grupo) and idproduto=produto and ano=p_ano and mes=p_mes and "data" = first_day(data);
      
      
      if  date_part('month',current_date) = p_mes and date_part('year',current_date) = p_ano then
      
      	select sum(estoque) into saldo_fim from saldo_filiais sf where filial in(select filial from grupo_filial gf where gf.id_grupo=p_grupo) and idproduto=produto and ano=p_ano and mes=p_mes and "data" = (select max(data)  from saldo_filiais where idproduto=produto and ano=p_ano and mes=p_mes);
      
        else
        
        select sum(estoque) into saldo_fim from saldo_filiais sf where filial in(select filial from grupo_filial gf where gf.id_grupo=p_grupo) and idproduto=produto and ano=p_ano and mes=p_mes and "data" = last_day(data);
       
      end if;  
      
       
      
      total = round((saldo_ini+Saldo_fim)/2,4);
  
   
    return coalesce(total,0);

end;

$function$

