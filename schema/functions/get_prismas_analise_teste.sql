CREATE OR REPLACE FUNCTION public.get_prismas_analise_teste(produto character varying, dataref date DEFAULT ('now'::text)::date)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$ 
declare

retorno varchar;
table_temp1 varchar;
table_temp2 varchar;

begin
	
	table_temp1 =  '_tmp_classificacao_financeira_'||to_char(dataref,'mmyyyy') ;
    table_temp2 =  '_tmp_classificacao_criticidade_'||to_char(dataref,'mmyyyy') ;
    
	
  -- 1- Prisma Financeiro;	
  
   
  EXECUTE format('create temporary table if not exists %I  as 
  select
	idproduto,
    getclassfinanceira(sum(acomulado.perc_csm) OVER (ORDER BY acomulado.csm DESC)) as class_abc
from
	(  select idproduto,csm,total_saidas,(csm / total_saidas) as perc_csm from(
		      select idproduto,(getconsumomediomensal(idproduto,last_day(''%I''))*custo_unitario) as csm,
			   (select sum(getconsumomediomensal(idproduto,last_day(''%I''))*custo_unitario)	from produtos) as total_saidas
		          from produtos
		             order by csm desc,	idproduto) prod
	 ) acomulado',table_temp1,dataref,dataref); 
   
  
                         
       --2- Prisma Criticidade
       
    EXECUTE format('create temporary table if not exists %I as  
      SELECT acomulado.idproduto,
        CASE
            WHEN  getclassfinanceira(sum(acomulado.perc_csm) OVER (ORDER BY acomulado.csm DESC))::text = ''A''::text THEN ''Z''::text
            WHEN  getclassfinanceira(sum(acomulado.perc_csm) OVER (ORDER BY acomulado.csm DESC))::text = ''B''::text THEN ''Y''::text
            ELSE ''X''::text
        END AS class_xyz
from
	(  select idproduto,csm::numeric,total_saidas::numeric,(csm / total_saidas)::numeric as perc_csm from(
		      select idproduto,(getconsumomediomensal(idproduto,last_day(''%I''))*valor_unitario) as csm,
			   (select sum(getconsumomediomensal(idproduto,last_day(''%I''))*valor_unitario)	from produtos) as total_saidas
		          from produtos
		             order by csm desc,	idproduto) prod
	 ) acomulado',table_temp2,dataref,dataref);
       
 


    execute format('select coalesce(f.class_abc::varchar,''C'')||coalesce(c.class_xyz::varchar,''X'')||get123(f.idproduto::varchar)||getpqr_dinamico(f.idproduto::varchar,''%I'')  
           from %I f 
             inner join %I c    
              on f.idproduto = c.idproduto
         where f.idproduto =''%s''',dataref,table_temp1,table_temp2,produto)
    into retorno;
     
                         
      
       return retorno;                   
                       
   
end; 
 $function$

