CREATE OR REPLACE FUNCTION public.get_stddev_consumo(p_filial numeric, p_produto character varying, p_dataref date DEFAULT ('now'::text)::date)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$
declare 
desvio numeric;
linf numeric;
lisup numeric;
prod_heranca varchar;
modo_heranca int4;
tempo_heranca numeric; 
desvio_heranca numeric;
data_calc_cmm_heranca date;

begin
	
	  --select limite_inferior ,limite_superior into linf,lisup  from analise_statistica_produtos where filial=p_filial and idproduto=p_produto;
	 

	 
	  select
			heranca,
			tipo_heranca,
			current_date - cadastro_heranca,
			coalesce(limite_inferior,0),
			coalesce(limite_superior,0)
			
		into
			prod_heranca,
			modo_heranca,
			tempo_heranca,
			linf,
			lisup
			
		from
			produtos_filial pf
		inner join grupo_filial gf on
			gf.filial = pf.filial
		where
			pf.filial = p_filial
			and pf.idproduto = p_produto;
		
		-- Espaço amostral sai de 365 para 180;
		select coalesce(round(cast(stddev_pop(saidas) as numeric), 2), 0)
			into desvio
			from (
		     select * from (	
			  select to_char(emissao, 'YYYYMM') as mes
					,sum(qtde) as saidas
				from consumos c
				where c.filial = p_filial
					and c.idproduto = p_produto
					and c.emissao between (p_dataref - 180)
						and p_dataref
				group by mes) a where a.saidas between linf and lisup
				) com;
		
	    
		desvio_heranca=0;	
		
		if prod_heranca <>'' then 
		
		
		    if modo_heranca = 1 then
		    
		         
			       select
			         min(emissao)+ 90
			         into data_calc_cmm_heranca
					from
						consumos c
					where
						c.filial = p_filial
						and c.idproduto = prod_heranca ;
			
			   
				   if tempo_heranca <= 60 then	
				   
			           desvio_heranca = (select get_stddev_heranca_consumo(p_filial,prod_heranca,data_calc_cmm_heranca));
			           desvio = 0;
			          
			   
			       end if;
			      
			      
			      return round((desvio+desvio_heranca),2);
			
		    
		      else 
		      
		          if tempo_heranca <= 60 then	
		          
		              desvio_heranca = (select get_stddev_heranca_consumo(p_filial,prod_heranca));
		          
		          end if;
		         
		         return round(((desvio+desvio_heranca)/2),2);
		      
		            
		    end if;  
		
		
		 else
		 
	         
			 return desvio;
		 
		 
		end if;
	
	

end;$function$

