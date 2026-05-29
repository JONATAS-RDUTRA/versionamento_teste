CREATE OR REPLACE FUNCTION public.gatilho_similares_filial()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
declare
 
rec_dados record;
estoque_agrupado numeric;
est_temp numeric;
und_venda varchar;
estoque_pai numeric;
estoque_final numeric;
fator_conversao_pai numeric;
existe numeric;
    
begin
	   
	   
   if  (TG_OP = 'UPDATE' or TG_OP = 'INSERT'  ) then
   
   
   for rec_dados in (select id_grupo ,filial from grupo_filial gf order by filial)
     loop 
     
   
		    select coalesce(estoque_temp,0),unidade_compra,fator_conversao into est_temp,und_venda,fator_conversao_pai from produtos_filial pf 
		    	where filial = rec_dados.filial and idproduto = new.id_item_pai;
		
		   
		    estoque_pai = (select get_estoque_diario_filial(rec_dados.filial,new.id_item_pai,current_date));
		    
		    est_temp = estoque_pai;
			   
			   if new.agregar_estoque ='S' then
			   
				       select sum(get_estoque_diario_filial(p.filial,p.idproduto ,current_date)*fator_conversao) 
				         into estoque_agrupado
				       from produtos_filial p 
				       where p.filial=rec_dados.filial and  p.idproduto in (select id_item_filho from similares 
				                           where id_item_pai= new.id_item_pai 
				                          and agregar_estoque='S')
				           and p.unidade_compra = und_venda;

    -- Ajuste feito via migration para agregar o estoque do produto combinado
    estoque_agrupado = coalesce(estoque_agrupado, 0) + coalesce((
        SELECT
            CASE
                WHEN coalesce(p.estoque, 0) < coalesce(get_estoque_similar_produto_combinado(p.id_grupo::int, p.filial::int, p.id_produto_combinado), 0) THEN coalesce(p.estoque, 0) -- devolve apenas estoque, porque o estoque do similar ainda não está sendo considerado
                ELSE GREATEST(coalesce(p.estoque, 0) - coalesce(get_estoque_similar_produto_combinado(p.id_grupo::int, p.filial::int, p.id_produto_combinado), 0), 0) -- estoque do similar está dentro de estoque, por isso ele é subtraido
            END
        FROM produtos_combinados_compras_filial p
        WHERE
            p.filial = rec_dados.filial
            AND p.id_produto_combinado IN (
                SELECT s.id_item_filho
                FROM similares s
                WHERE
                    s.id_item_pai = new.id_item_pai
                    AND substring(s.id_item_filho, 0, 8) = 'SYSCOMB'
                    AND s.agregar_estoque = 'S'
            )
        LIMIT 1
    ), 0); 
				      
				      
				      estoque_final = coalesce(estoque_agrupado/fator_conversao_pai,0)+ coalesce(estoque_pai,0);
			   
			     else
			     
			     	  estoque_final=  coalesce(estoque_pai,0);
			     	  est_temp = 0;
			     	  estoque_agrupado=0;
			   
			   end if;
		 
		       update produtos_filial set estoque = estoque_final ,processamento = current_timestamp,estoque_temp=est_temp  where filial=rec_dados.filial and idproduto = new.id_item_pai;
		      
--		       select count(*) into existe from analise_mercadorias_transito_grupo  where id_grupo = rec_dados.id_grupo  and  idproduto=new.id_item_pai;
		      
--		       if existe > 0 then 
--		      
--		       	REFRESH MATERIALIZED view CONCURRENTLY public.analise_mercadorias_transito_grupo WITH data;
--		       	REFRESH MATERIALIZED view CONCURRENTLY public.analise_mercadorias_transito_grupo_filial WITH data;
--		       	
--		       end if;
		      
	   end loop;	      
      
       return  NEW;
      
      elsif  (TG_OP = 'DELETE') then 
      
       for rec_dados in (select id_grupo ,filial from grupo_filial gf order by filial)
        loop 
      
		      select coalesce(estoque_temp,0),unidade_compra into est_temp,und_venda from produtos_filial 
		    	where filial = rec_dados.filial and idproduto = old.id_item_pai;
		
		   
		       estoque_pai = (select get_estoque_diario_filial(rec_dados.filial,old.id_item_pai,current_date));
		    
			   est_temp = estoque_pai; 
		      
			   if old.agregar_estoque ='S' then
			   
				       select sum(get_estoque_diario_filial(p.filial,p.idproduto,current_date)*fator_conversao) 
				         into estoque_agrupado
				       from produtos_filial p 
				       where p.filial = rec_dados.filial and  p.idproduto in (select id_item_filho from similares 
				                           where id_item_pai= old.id_item_pai 
				                          and agregar_estoque='S')
				           and p.unidade_compra = und_venda;

    -- Ajuste feito via migration para agregar o estoque do produto combinado
    estoque_agrupado = coalesce(estoque_agrupado, 0) + coalesce((
        SELECT
            CASE
                WHEN coalesce(p.estoque, 0) < coalesce(get_estoque_similar_produto_combinado(p.id_grupo::int, p.filial::int, p.id_produto_combinado), 0) THEN coalesce(p.estoque, 0) -- devolve apenas estoque, porque o estoque do similar ainda não está sendo considerado
                ELSE GREATEST(coalesce(p.estoque, 0) - coalesce(get_estoque_similar_produto_combinado(p.id_grupo::int, p.filial::int, p.id_produto_combinado), 0), 0) -- estoque do similar está dentro de estoque, por isso ele é subtraido
            END
        FROM produtos_combinados_compras_filial p
        WHERE
            p.filial = rec_dados.filial
            AND p.id_produto_combinado IN (
                SELECT s.id_item_filho
                FROM similares s
                WHERE
                    s.id_item_pai = new.id_item_pai
                    AND substring(s.id_item_filho, 0, 8) = 'SYSCOMB'
                    AND s.agregar_estoque = 'S'
            )
        LIMIT 1
    ), 0); 
				      
				      
				      estoque_final = coalesce(estoque_agrupado/fator_conversao_pai,0)+ coalesce(estoque_pai,0);
			   
			     else
			     
			     	  estoque_final=  coalesce(estoque_pai,0);
			     	  est_temp = 0;
			   
			   end if;
		 
		       update produtos_filial set estoque = estoque_final ,processamento = current_timestamp,estoque_temp=est_temp where filial = rec_dados.filial and idproduto = old.id_item_pai;
		      
		       /* select count(*) into existe from analise_mercadorias_transito_grupo where  id_grupo=rec_dados.id_grupo  and idproduto=old.id_item_pai;
		      
		       if existe > 0 then 
		      
		       		REFRESH MATERIALIZED view CONCURRENTLY public.analise_mercadorias_transito_grupo WITH data;
		       	    REFRESH MATERIALIZED view CONCURRENTLY public.analise_mercadorias_transito_grupo_filial WITH data;
		       	
		       end if; */
		      
		 end loop;      
		      
		 return  OLD;
      
   end if;
      
   return null;

end
$function$

