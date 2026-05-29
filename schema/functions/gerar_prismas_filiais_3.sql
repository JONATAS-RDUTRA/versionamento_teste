CREATE OR REPLACE FUNCTION public.gerar_prismas_filiais_3(p_filial numeric, dataref date DEFAULT ('now'::text)::date)
 RETURNS TABLE(produto character varying, arvore text)
 LANGUAGE plpgsql
AS $function$
declare 
retorno varchar;
begin
	
		
	
			
   return query  execute format('
           with projecao as ( select a.*,(nullif(a.valor_unitario,0)*nullif(cmm_venda,0)) csm_venda, (nullif(a.custo_unitario,0)*nullif(cmm_venda,0)) csm_custo from (
		                       select filial ,idproduto,valor_unitario ,custo_unitario , 
		                          get_cmm_filial(filial,idproduto,last_day(%L)) as cmm_venda,
		                          get_tma_filial(filial,idproduto,last_day(%L)) as total_tma 
		                          from produtos_filial where filial=%L) a),
    analise_financeira  as ( select
		idproduto,
	    coalesce(getclassfinanceira(sum(acomulado.perc_csm) OVER (ORDER BY acomulado.csm DESC)),''C'') as class_abc from (                       
		                          
			  select
			   idproduto,
			    csm_custo as csm,
			    csm_custo / nullif(sum(csm_custo) over(),0) perc_csm,
			   sum(csm_custo) over() as total
			  from projecao ) acomulado),
			  
	analise_criticidade as (
	     
	    SELECT acomulado.idproduto,
	
	        CASE
	
	            WHEN  getclassfinanceira(sum(acomulado.perc_csm) OVER (ORDER BY acomulado.csm DESC))::text = ''A''::text THEN ''Z''::text
	
	            WHEN  getclassfinanceira(sum(acomulado.perc_csm) OVER (ORDER BY acomulado.csm DESC))::text = ''B''::text THEN ''Y''::text
	
	            ELSE ''X''::text
	
	        END AS class_xyz from (                       
		                          
			  select
			   idproduto,
			    csm_venda as csm,
			    csm_venda / nullif(sum(csm_venda) over(),0) perc_csm,
			   sum(csm_venda) over() as total
			  from projecao ) acomulado ),
	analise_popularidade as (
	
	     select idproduto,tma,perc_tma,
	
				sum(tma_acomulado.perc_tma) OVER (ORDER BY tma_acomulado.tma DESC rows between unbounded preceding and current row) AS perc_acomulado,
	
				(case when sum(tma_acomulado.perc_tma) OVER (ORDER BY tma_acomulado.tma DESC rows between unbounded preceding and current row) > 0 and sum(tma_acomulado.perc_tma) OVER (ORDER BY tma_acomulado.tma DESC rows between unbounded preceding and current row) <= 0.8 then ''P''
	
	      	when sum(tma_acomulado.perc_tma) OVER (ORDER BY tma_acomulado.tma DESC rows between unbounded preceding and current row) > 0.8 and sum(tma_acomulado.perc_tma) OVER (ORDER BY tma_acomulado.tma DESC rows between unbounded preceding and current row) <= 0.95 then ''Q''
	
	     	else ''R''  end ) class_pqr from(                     
			  select
			   idproduto,
			    total_tma as tma,
			    total_tma / nullif(sum(total_tma) over(),0) perc_tma,
			   sum(total_tma) over() as total
			  from projecao) tma_acomulado )		  
	     
			  select c.idproduto::varchar,coalesce(f.class_abc::varchar,''C'')||coalesce(c.class_xyz::varchar,''X'')||coalesce(get123_filial(%L,f.idproduto::varchar),''3'')||coalesce(p.class_pqr::varchar,''R'')::varchar as arvore  

           from analise_financeira f 

             inner join analise_criticidade c    

              on f.idproduto = c.idproduto

              inner join analise_popularidade p    

              on f.idproduto = p.idproduto
          ', dataref,dataref, p_filial,p_filial);
        
        
end;$function$

