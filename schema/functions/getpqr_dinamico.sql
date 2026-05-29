CREATE OR REPLACE FUNCTION public.getpqr_dinamico(idprod character varying, dataref date DEFAULT ('now'::text)::date)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
declare 
    pqr character varying;
    table_temp varchar;
begin 
	
	  table_temp =  'tmp_classificacao_popularidade';
	
	     -- 3- Prisma Popularidade 
      
      EXECUTE format('create temporary table if not exists %I as
         select idproduto,tma,perc_tma,
			sum(tma_acomulado.perc_tma) OVER (ORDER BY tma_acomulado.tma DESC) AS perc_acomulado,
			(case when sum(tma_acomulado.perc_tma) OVER (ORDER BY tma_acomulado.tma DESC) > 0 and sum(tma_acomulado.perc_tma) OVER (ORDER BY tma_acomulado.tma DESC) <= 0.8 then ''P''
      	when sum(tma_acomulado.perc_tma) OVER (ORDER BY tma_acomulado.tma DESC) > 0.8 and sum(tma_acomulado.perc_tma) OVER (ORDER BY tma_acomulado.tma DESC) <= 0.95 then ''Q''
     	else ''R''  end ) class_pqr from(
			select idproduto,tma,(tma/total_tma) as perc_tma from (
			select idproduto,gettma(idproduto,last_day(''%I'')) as tma,
			(select sum(gettma(idproduto,last_day(''%I''))) from  produtos) as total_tma
		from  produtos order by tma desc ,idproduto) prod) tma_acomulado',table_temp,dataref,dataref);
	
	 
	select class_pqr 
	   into pqr from tmp_classificacao_popularidade c where c.idproduto=idprod;
    
    return pqr;

end;

$function$

