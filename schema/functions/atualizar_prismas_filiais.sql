CREATE OR REPLACE FUNCTION public.atualizar_prismas_filiais(flag_geral numeric DEFAULT 1)
 RETURNS void
 LANGUAGE plpgsql
AS $function$

declare 

  rec_data record;
  arv_decisao varchar;

begin

 delete from hist_gatilho_compras where status='F' and idrequisicao=0;

 if flag_geral = 1 then 
 
  	for rec_data in (select filial,idproduto,current_date as dataref from produtos_filial order by filial,idproduto::numeric)

  		loop


       arv_decisao = (select  get_prismas_analise_filial(rec_data.filial,rec_data.idproduto,current_date));

       update produtos_filial set arvore_decisao = arv_decisao,classificacao_financeira=substring(arv_decisao from 1 for 1),
                     classificacao_criticidade=substring(arv_decisao from 2 for 1),
                     classificacao_comprabilidade=substring(arv_decisao from 3 for 1)::numeric,
                     classificacao_popularidade =substring(arv_decisao from 4 for 1),processamento=current_timestamp
             where filial = rec_data.filial and idproduto=rec_data.idproduto;


  		end loop;
 
   else
   
   		for rec_data in (select filial,idproduto,current_date as dataref from produtos_filial where arvore_decisao is null  order by filial,idproduto::numeric)

		  loop
		
		
		       arv_decisao = (select  get_prismas_analise_filial(rec_data.filial,rec_data.idproduto,current_date));
		
		       update produtos_filial set arvore_decisao = arv_decisao,classificacao_financeira=substring(arv_decisao from 1 for 1),
		                     classificacao_criticidade=substring(arv_decisao from 2 for 1),
		                     classificacao_comprabilidade=substring(arv_decisao from 3 for 1)::numeric,
		                     classificacao_popularidade =substring(arv_decisao from 4 for 1),processamento=current_timestamp
		             where filial = rec_data.filial and idproduto=rec_data.idproduto;
		
		
		  end loop;
 
   end if;

 

end;

$function$

