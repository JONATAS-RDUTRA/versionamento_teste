CREATE OR REPLACE FUNCTION public.gatilho_similares()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
declare
  
estoque_agrupado numeric;
est_temp numeric;
und_venda varchar;
estoque_pai numeric;
estoque_final numeric;
fator_conversao_pai numeric;
existe numeric;
    
begin
	   
	   
   if  (TG_OP = 'UPDATE') then
   
    select coalesce(estoque_temp,0),idunidade_medida,fator_conversao into est_temp,und_venda,fator_conversao_pai from produtos
    	where idproduto = new.id_item_pai;

   
    estoque_pai = (select get_estoque_diario(new.id_item_pai,current_date));
    
    est_temp = estoque_pai;
	   
	   if new.agregar_estoque ='S' then
	   
		       select sum(estoque*fator_conversao) 
		         into estoque_agrupado
		       from produtos p 
		       where p.idproduto in (select id_item_filho from similares 
		                           where id_item_pai= new.id_item_pai 
		                          and agregar_estoque='S')
		       and p.idunidade_medida = und_venda; 
		      
		      
		      estoque_final = coalesce(estoque_agrupado/fator_conversao_pai,0)+ coalesce(estoque_pai,0);
	   
	     else
	     
	     	  estoque_final=  coalesce(estoque_pai,0);
	   
	   end if;
 
       update produtos set estoque = estoque_final ,processamento = current_timestamp,estoque_temp=est_temp  where idproduto = new.id_item_pai;
      
       select count(*) into existe from analise_mercadorias_transito where idproduto=new.id_item_pai;
      
       if existe > 0 then 
      
       		REFRESH MATERIALIZED view CONCURRENTLY public.analise_mercadorias_transito WITH data;
       	
       end if;
      
       return  NEW;
      
      elsif  (TG_OP = 'DELETE') then 
      
      
      select coalesce(estoque_temp,0),idunidade_medida into est_temp,und_venda from produtos
    	where idproduto = old.id_item_pai;

   
    estoque_pai = (select get_estoque_diario(old.id_item_pai,current_date));
    
	   
	   if old.agregar_estoque ='S' then
	   
		       select sum(estoque) 
		         into estoque_agrupado
		       from produtos p 
		       where p.idproduto in (select id_item_filho from similares 
		                           where id_item_pai= old.id_item_pai 
		                          and agregar_estoque='S')
		       and p.idunidade_medida = und_venda; 
		      
		      
		      estoque_final = coalesce(estoque_agrupado,0)+ coalesce(estoque_pai,0);
	   
	     else
	     
	     	  estoque_final=  coalesce(estoque_pai,0);
	   
	   end if;
 
       update produtos set estoque = estoque_final ,processamento = current_timestamp,estoque_temp=est_temp where idproduto = old.id_item_pai;
      
        select count(*) into existe from analise_mercadorias_transito where idproduto=old.id_item_pai;
      
       if existe > 0 then 
      
       		REFRESH MATERIALIZED view CONCURRENTLY public.analise_mercadorias_transito WITH data;
       	
       end if;
      
      return  OLD;
      
   end if;
      
   return null;

end
$function$

