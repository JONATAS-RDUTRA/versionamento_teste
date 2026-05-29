CREATE OR REPLACE FUNCTION public.processar_sazonalidade()
 RETURNS void
 LANGUAGE plpgsql
AS $function$
declare
rec_prod record;
rec_total_tri record;
ano_ref numeric;
data_ini date;
data_fim date;
tot_ano_1 numeric;
tot_ano_2 numeric;
tot_ano_3 numeric;
tot_ano_4 numeric;
md_ano_1 numeric;
md_ano_2 numeric;
md_ano_3 numeric;
md_ano_4 numeric;
begin
	
	

	
   
for rec_prod in (select id_grupo ,idproduto from vw_grupo_compras_produtos_mt  where id_grupo=1 and idproduto='2373')
  loop 
    
  
     ano_ref = (select date_part('year',first_day_trimestre(current_date) - interval '4 year'));	
	 data_ini = (select ('01/01/'||ano_ref)::date);
 	 data_fim = (select ('31/12/'||ano_ref)::date);
  
    
    	 for rec_total_tri in (
         
            SELECT * FROM crosstab( 
			   'select date_part(''quarter'',emissao)::varchar trimestre,date_part(''year'',emissao)::varchar ano , sum(qtde)::numeric  total
			   from consumos where idproduto='''||rec_prod.idproduto||''' and emissao between '''||data_ini||''' and '''||data_fim||'''
			   group by idproduto, date_part(''year'',emissao) , date_part(''quarter'',emissao)
			   order by date_part(''quarter'',emissao)', 
			   'select distinct date_part(''year'',emissao) from consumos where  idproduto ='''||rec_prod.idproduto||'''  and emissao between '''||data_ini||''' and '''||data_fim||''' order by 1' 
			   ) as ct (trimestre varchar,total varchar)
			   
			   )
			   
         loop 
         
         
             UPDATE sazonalidade_produtos SET ano_referencia=date_part('year',current_date),sd_ano_1=rec_total_tri.total::numeric  WHERE id_grupo=rec_prod.id_grupo AND trimestre=rec_total_tri.trimestre::int4 AND idproduto=rec_prod.idproduto;

              if  NOT FOUND then
              
                 INSERT INTO sazonalidade_produtos (id_grupo, trimestre, idproduto, sd_ano_1,ano_referencia) VALUES(rec_prod.id_grupo,rec_total_tri.trimestre::int4,rec_prod.idproduto,rec_total_tri.total::numeric,date_part('year',current_date));
              
              end if;
         
             
         end loop;
        
        
        
     ano_ref = (select date_part('year',first_day_trimestre(current_date) - interval '3 year'));	
	 data_ini = (select ('01/01/'||ano_ref)::date);
 	 data_fim = (select ('31/12/'||ano_ref)::date);
  
    
    	 for rec_total_tri in (
         
            SELECT * FROM crosstab( 
			   'select date_part(''quarter'',emissao)::varchar trimestre,date_part(''year'',emissao)::varchar ano , sum(qtde)::numeric  total
			   from consumos where idproduto='''||rec_prod.idproduto||''' and emissao between '''||data_ini||''' and '''||data_fim||'''
			   group by idproduto, date_part(''year'',emissao) , date_part(''quarter'',emissao)
			   order by date_part(''quarter'',emissao)', 
			   'select distinct date_part(''year'',emissao) from consumos where  idproduto ='''||rec_prod.idproduto||'''  and emissao between '''||data_ini||''' and '''||data_fim||''' order by 1' 
			   ) as ct (trimestre varchar,total varchar)
			   
			   )
			   
         loop 
         
         
             UPDATE sazonalidade_produtos SET ano_referencia=date_part('year',current_date),sd_ano_2=rec_total_tri.total::numeric  WHERE id_grupo=rec_prod.id_grupo AND trimestre=rec_total_tri.trimestre::int4 AND idproduto=rec_prod.idproduto;

              if  NOT FOUND then
              
                 INSERT INTO sazonalidade_produtos (id_grupo, trimestre, idproduto, sd_ano_2,ano_referencia) VALUES(rec_prod.id_grupo,rec_total_tri.trimestre::int4,rec_prod.idproduto,rec_total_tri.total::numeric,date_part('year',current_date));
              
              end if;
         
             
         end loop;
        
        
        ano_ref = (select date_part('year',first_day_trimestre(current_date) - interval '2 year'));	
	 	data_ini = (select ('01/01/'||ano_ref)::date);
 	 	data_fim = (select ('31/12/'||ano_ref)::date);
  
    
    	 for rec_total_tri in (
         
            SELECT * FROM crosstab( 
			   'select date_part(''quarter'',emissao)::varchar trimestre,date_part(''year'',emissao)::varchar ano , sum(qtde)::numeric  total
			   from consumos where idproduto='''||rec_prod.idproduto||''' and emissao between '''||data_ini||''' and '''||data_fim||'''
			   group by idproduto, date_part(''year'',emissao) , date_part(''quarter'',emissao)
			   order by date_part(''quarter'',emissao)', 
			   'select distinct date_part(''year'',emissao) from consumos where  idproduto ='''||rec_prod.idproduto||'''  and emissao between '''||data_ini||''' and '''||data_fim||''' order by 1' 
			   ) as ct (trimestre varchar,total varchar)
			   
			   )
			   
         loop 
         
         
             UPDATE sazonalidade_produtos SET ano_referencia=date_part('year',current_date),sd_ano_3=rec_total_tri.total::numeric  WHERE id_grupo=rec_prod.id_grupo AND trimestre=rec_total_tri.trimestre::int4 AND idproduto=rec_prod.idproduto;

              if  NOT FOUND then
              
                 INSERT INTO sazonalidade_produtos (id_grupo, trimestre, idproduto, sd_ano_3,ano_referencia) VALUES(rec_prod.id_grupo,rec_total_tri.trimestre::int4,rec_prod.idproduto,rec_total_tri.total::numeric,date_part('year',current_date));
              
              end if;
         
             
         end loop;
        
        
        
        ano_ref = (select date_part('year',first_day_trimestre(current_date) - interval '1 year'));	
	 	data_ini = (select ('01/01/'||ano_ref)::date);
 	 	data_fim = (select ('31/12/'||ano_ref)::date);
  
    
    	 for rec_total_tri in (
         
            SELECT * FROM crosstab( 
			   'select date_part(''quarter'',emissao)::varchar trimestre,date_part(''year'',emissao)::varchar ano , sum(qtde)::numeric  total
			   from consumos where idproduto='''||rec_prod.idproduto||''' and emissao between '''||data_ini||''' and '''||data_fim||'''
			   group by idproduto, date_part(''year'',emissao) , date_part(''quarter'',emissao)
			   order by date_part(''quarter'',emissao)', 
			   'select distinct date_part(''year'',emissao) from consumos where  idproduto ='''||rec_prod.idproduto||'''  and emissao between '''||data_ini||''' and '''||data_fim||''' order by 1' 
			   ) as ct (trimestre varchar,total varchar)
			   
			   )
			   
         loop 
         
         
             UPDATE sazonalidade_produtos SET ano_referencia=date_part('year',current_date), sd_ano_4=rec_total_tri.total::numeric  WHERE id_grupo=rec_prod.id_grupo AND trimestre=rec_total_tri.trimestre::int4 AND idproduto=rec_prod.idproduto;

              if  NOT FOUND then
              
                 INSERT INTO sazonalidade_produtos (id_grupo, trimestre, idproduto, sd_ano_4,ano_referencia) VALUES(rec_prod.id_grupo,rec_total_tri.trimestre::int4,rec_prod.idproduto,rec_total_tri.total::numeric,date_part('year',current_date));
              
              end if;
         
             
         end loop;
        
        
         select
		 sum(nullif(sd_ano_1,0)),
		 sum(nullif(sd_ano_2,0)),
		 sum(nullif(sd_ano_3,0)),
		 sum(nullif(sd_ano_4,0)),
		 avg(nullif(sd_ano_1,0)),
		 avg(nullif(sd_ano_2,0)),
		 avg(nullif(sd_ano_3,0)),
		 avg(nullif(sd_ano_4,0))
		 into 
		 tot_ano_1,tot_ano_2,tot_ano_3,tot_ano_4,md_ano_1,md_ano_2,md_ano_3,md_ano_4
		 from sazonalidade_produtos sp  
		 where idproduto = rec_prod.idproduto;
		
		
		update
		sazonalidade_produtos
		set
		total_ano_1 = tot_ano_1,
		total_ano_2 = tot_ano_2,
		total_ano_3 = tot_ano_3,
		total_ano_4 = tot_ano_4,
		media_ano_1 = md_ano_1,
		media_ano_2 = md_ano_2,
		media_ano_3 = md_ano_3,
		media_ano_4 = md_ano_4,
		coef_ano_1 = round(sd_ano_1/md_ano_1,2),
	    coef_ano_2 = round(sd_ano_2/md_ano_2,2),
		coef_ano_3 = round(sd_ano_3/md_ano_3,2),
		coef_ano_4 = round(sd_ano_4/md_ano_4,2),
		coef_medio =round((round(sd_ano_1/md_ano_1,2)+round(sd_ano_2/md_ano_2,2)+round(sd_ano_3/md_ano_3,2)+round(sd_ano_4/md_ano_4,2))/4,2),
		mca =round((tot_ano_4-tot_ano_1)/4,2)
	  
	    
	where
		id_grupo =  rec_prod.id_grupo
		and idproduto =  rec_prod.idproduto;
	
	
    update
		sazonalidade_produtos
		set
		taxa_crescimento = round((total_ano_4+mca)/4,2),
	    prev_cresc_trim = round(coef_medio * round((total_ano_4+mca)/4,2),2)  
	where
		id_grupo =  rec_prod.id_grupo
		and idproduto =  rec_prod.idproduto;
	
  end loop;
	
 end;
$function$

