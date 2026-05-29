CREATE OR REPLACE FUNCTION public.atualizar_prismas(flag_geral numeric DEFAULT 1)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
declare 
  rec_data record;
  arv_decisao varchar;
begin

  
      if flag_geral = 1 then 
      
       for rec_data in (select idproduto,current_date as dataref from produtos order by idproduto::numeric)
  		loop
      
           arv_decisao = (select  get_prismas_analise(rec_data.idproduto,current_date));
      
	       update produtos set arvore_decisao = arv_decisao,classificacao_financeira=substring(arv_decisao from 1 for 1),
	                     classificacao_criticidade=substring(arv_decisao from 2 for 1),
	                     classificacao_comprabilidade=substring(arv_decisao from 3 for 1)::numeric,
	                     classificacao_popularidade =substring(arv_decisao from 4 for 1),processamento=current_timestamp
	                     
	             where idproduto=rec_data.idproduto;
	            
	                
  		end loop;
      
        else
        
          for rec_data in (select idproduto,current_date as dataref from produtos where arvore_decisao is null order by idproduto::numeric)
		  		loop
		      
		           arv_decisao = (select  get_prismas_analise(rec_data.idproduto,current_date));
		      
			       update produtos set arvore_decisao = arv_decisao,classificacao_financeira=substring(arv_decisao from 1 for 1),
			                     classificacao_criticidade=substring(arv_decisao from 2 for 1),
			                     classificacao_comprabilidade=substring(arv_decisao from 3 for 1)::numeric,
			                     classificacao_popularidade =substring(arv_decisao from 4 for 1),processamento=current_timestamp
			                     
			             where idproduto=rec_data.idproduto;
			            
			                
		   end loop;
        
      end if;
     
end;

$function$

