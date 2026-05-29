CREATE OR REPLACE FUNCTION public.processar_fechamento_eventos()
 RETURNS void
 LANGUAGE plpgsql
AS $function$
declare
 
rec_dados record;

    
begin
	
 for rec_dados in (select * from hist_fator_atuacao hfa where  status='A' and fator <> 1 and data_limite < current_date)
  loop 
  
  
   if rec_dados.idproduto='' then 
   
   
     INSERT INTO hist_fator_atuacao
		(id_grupo, id_fornecedor, idproduto, "data", fator, id_user,processamento)
		VALUES(rec_dados.id_grupo,rec_dados.id_fornecedor,rec_dados.idproduto,current_timestamp,1,0,current_timestamp);
 
   
   
      update produtos_filial 
       set fator_atuacao=1,tipo_fator_atuacao='F'
      where idfornecedor=rec_dados.id_fornecedor 
      and filial in(select filial from grupo_filial where id_grupo=rec_dados.id_grupo);
   
   
      update hist_fator_atuacao set status='F',processamento= current_timestamp where id = rec_dados.id;
     
   
    else 
    
    
    INSERT INTO hist_fator_atuacao
		(id_grupo, id_fornecedor, idproduto, "data", fator, id_user,processamento)
		VALUES(rec_dados.id_grupo,rec_dados.id_fornecedor,rec_dados.idproduto,current_timestamp,1,0,current_timestamp);
    
      
    update produtos_filial 
       set fator_atuacao=1,tipo_fator_atuacao='P'
      where  idfornecedor=rec_dados.id_fornecedor  and idproduto = rec_dados.idproduto
      and filial in(select filial from grupo_filial where id_grupo=rec_dados.id_grupo);
     
     
     update hist_fator_atuacao set status='F',processamento= current_timestamp where id = rec_dados.id;
   
   end if; 
      
  end loop;
 
 
  /*REFRESH MATERIALIZED view CONCURRENTLY public.analise_mercadorias_transito_grupo WITH data;
  REFRESH MATERIALIZED view CONCURRENTLY public.analise_mercadorias_forecast_grupo WITH data;
  REFRESH MATERIALIZED view CONCURRENTLY public.analise_mercadorias_transito_grupo_filial WITH data;
  REFRESH MATERIALIZED view CONCURRENTLY public.analise_mercadorias_forecast_grupo_filial WITH data;
	*/
end
$function$

