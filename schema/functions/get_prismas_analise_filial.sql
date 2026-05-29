CREATE OR REPLACE FUNCTION public.get_prismas_analise_filial(codfilial numeric, produto character varying, dataref date DEFAULT ('now'::text)::date)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
declare retorno varchar;
table_temp1 varchar;
table_temp2 varchar;
table_temp3 varchar;
begin
	table_temp1 = 'f' || codfilial || '_tmp_classificacao_financeira_' || to_char(dataref, 'mmyyyy');
	table_temp2 = 'f' || codfilial || '_tmp_classificacao_criticidade_' || to_char(dataref, 'mmyyyy');
	table_temp3 = 'f' || codfilial || '_tmp_classificacao_popularidade_' || to_char(dataref, 'mmyyyy');
	-- 1- Prisma Financeiro;	
	execute format('create temporary table if not exists %I  as  select
	idproduto,
    coalesce(getclassfinanceira(sum(acomulado.perc_csm) OVER (ORDER BY acomulado.csm DESC)),''C'') as class_abc

		from

	(  select idproduto,csm,total_saidas,(csm / nullif(total_saidas,0)) as perc_csm from(

		      select idproduto,(get_cmm_filial(%L,idproduto,last_day(%L))*custo_unitario) as csm,

			   (select sum(get_cmm_filial(%L,idproduto,last_day(%L))*custo_unitario) from produtos_filial where filial=%L) as total_saidas

		          from produtos_filial where filial=%L

		             order by csm desc,	idproduto) prod

	 ) acomulado', table_temp1, codfilial, dataref, codfilial, dataref, codfilial, codfilial);
	 
	--2- Prisma Criticidade
	execute format('create temporary table if not exists %I as  

      SELECT acomulado.idproduto,

        CASE

            WHEN  getclassfinanceira(sum(acomulado.perc_csm) OVER (ORDER BY acomulado.csm DESC))::text = ''A''::text THEN ''Z''::text

            WHEN  getclassfinanceira(sum(acomulado.perc_csm) OVER (ORDER BY acomulado.csm DESC))::text = ''B''::text THEN ''Y''::text

            ELSE ''X''::text

        END AS class_xyz

from

	(  select idproduto,csm::numeric,total_saidas::numeric,(csm / nullif(total_saidas,0))::numeric as perc_csm from(

		      select idproduto,(get_cmm_filial(%L,idproduto,last_day(%L))*valor_unitario) as csm,

			   (select sum(get_cmm_filial(%L,idproduto,last_day(%L))*valor_unitario) from produtos_filial where filial=%L) as total_saidas

		          from produtos_filial where filial=%L

		             order by csm desc,	idproduto) prod

	 ) acomulado', table_temp2, codfilial, dataref, codfilial, dataref, codfilial, codfilial);
	-- 3- Prisma Popularidade 
	execute format('create temporary table if not exists %I as

         select idproduto,tma,perc_tma,

			sum(tma_acomulado.perc_tma) OVER (ORDER BY tma_acomulado.tma DESC) AS perc_acomulado,

			(case when sum(tma_acomulado.perc_tma) OVER (ORDER BY tma_acomulado.tma DESC) > 0 and sum(tma_acomulado.perc_tma) OVER (ORDER BY tma_acomulado.tma DESC) <= 0.8 then ''P''

      	when sum(tma_acomulado.perc_tma) OVER (ORDER BY tma_acomulado.tma DESC) > 0.8 and sum(tma_acomulado.perc_tma) OVER (ORDER BY tma_acomulado.tma DESC) <= 0.95 then ''Q''

     	else ''R''  end ) class_pqr from(

			select idproduto,tma,(tma/nullif(total_tma,0)) as perc_tma from (

			select idproduto,get_tma_filial(%L,idproduto,last_day(%L)) as tma,

			(select sum(get_tma_filial(%L,idproduto,last_day(%L))) from  produtos_filial where filial=%L) as total_tma

		from  produtos_filial where filial=%L order by tma desc ,idproduto) prod) tma_acomulado', table_temp3, codfilial, dataref, codfilial, dataref, 
			codfilial, codfilial);
	execute format('select coalesce(f.class_abc::varchar,''C'')||coalesce(c.class_xyz::varchar,''X'')||coalesce(get123(f.idproduto::varchar),''3'')||coalesce(p.class_pqr::varchar,''R'')  

           from %I f 

             inner join %I c    

              on f.idproduto = c.idproduto

              inner join %I p    

              on f.idproduto = p.idproduto

         where f.idproduto =%L', table_temp1, table_temp2, table_temp3, produto)
	into retorno;
	return retorno;
end;$function$

