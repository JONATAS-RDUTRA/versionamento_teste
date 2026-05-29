CREATE OR REPLACE FUNCTION public.processar_prismas_filiais(p_dataref date DEFAULT ('now'::text)::date)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
declare
rec_dados record;
rec_filiais record;	
begin 

    ALTER TABLE public.produtos_filial DISABLE TRIGGER produtos_filial_trg;

    for rec_filiais in (select distinct filial from produtos_filial pf )
    loop 
   
       
      	 for rec_dados in (select produto as idproduto, arvore as arv_decisao  from gerar_prismas_filiais_3(rec_filiais.filial,p_dataref))
         loop
          
            UPDATE prismas_filiais pf
			SET arvore_decisao=rec_dados.arv_decisao
			WHERE pf.filial=rec_filiais.filial AND pf.idproduto=rec_dados.idproduto and pf.data_ref = first_day(p_dataref);

	       
            if not found then
		   
   	            INSERT INTO prismas_filiais (filial, idproduto, arvore_decisao,data_ref )
				VALUES(rec_filiais.filial,rec_dados.idproduto,rec_dados.arv_decisao,first_day(p_dataref));
		   
            end if;
          
        end loop;
         
        
        -- classificação de rentabilidade     
        FOR rec_dados IN (SELECT * FROM gerar_prismas_rentabilidade_filiais(rec_filiais.filial))
        LOOP
            
            UPDATE prismas_filiais pf
            SET classificacao_rentabilidade = rec_dados.classificacao_rentabilidade
            WHERE pf.filial = rec_filiais.filial AND pf.idproduto = rec_dados.idproduto AND pf.data_ref = to_char(current_date, 'YYYY-MM-01')::date;
       
            UPDATE produtos_filial pf
            SET classificacao_rentabilidade = rec_dados.classificacao_rentabilidade
            WHERE pf.filial = rec_filiais.filial AND pf.idproduto = rec_dados.idproduto;
        
        END LOOP;
   
    end loop;
  
    ALTER TABLE public.produtos_filial ENABLE TRIGGER produtos_filial_trg;

    perform  processar_prismas_grupo(p_dataref);
end;$function$

