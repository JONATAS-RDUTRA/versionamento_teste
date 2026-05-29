CREATE OR REPLACE FUNCTION public.processar_analise_abc_grupo(p_grupo numeric, p_fornecedor numeric DEFAULT 0, p_departamento numeric DEFAULT 0)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
declare
 
rec_dados record;
rec_vendas record;
rec_estoque record;
table_temp1 varchar;
sql_txt varchar;
num_count numeric;
    
begin
	
 table_temp1 = '_tmp_classificacao_abc';	

 DROP TABLE IF EXISTS _tmp_classificacao_abc;

 if p_fornecedor > 0 and p_departamento = 0 then
 
   execute format('create temporary table if not exists %I  as 
      select row_number() over() as id,a.* from (
		select id_grupo,idfornecedor,razao_social,acomulado.idproduto,descricao_produto, codigo_barras,idunidade_medida as und_venda,
            CASE
                WHEN  getclassfinanceira(sum(acomulado.perc_csm) OVER (ORDER BY acomulado.csm DESC))::text = ''A''::text THEN ''A''::text
                WHEN  getclassfinanceira(sum(acomulado.perc_csm) OVER (ORDER BY acomulado.csm DESC))::text = ''B''::text THEN ''B''::text
                ELSE ''C''::text
            END AS class_abc,media_venda as media_saidas,valor_unitario,round(csm,2) total_acomulado, estoque as estoque_atual
        from
            (  
            select id_grupo,idfornecedor,idproduto,descricao_produto,csm::numeric,total_saidas::numeric,(csm / nullif(total_saidas,0))::numeric as perc_csm,estoque, codigo_barras,media_venda,valor_unitario,idunidade_medida from(
               select id_grupo,idfornecedor,idproduto,descricao_produto,consumo_medio_mensal as media_venda,(valor_unitario) valor_unitario,(consumo_medio_mensal*(valor_unitario)) as csm,
               sum(consumo_medio_mensal*(valor_unitario )) over() as total_saidas,estoque,codigo_barras,idunidade_medida
                from vw_grupo_compras_produtos_mt  p  
                where id_grupo =%L and idfornecedor=%L
                order by csm desc,	idproduto) prod
            ) acomulado inner join fornecedor f on f.id = acomulado.idfornecedor ) a
        ', table_temp1,p_grupo,p_fornecedor);
       
   elsif p_fornecedor=0 and p_departamento > 0 then      
   
      execute format('create temporary table if not exists %I  as 
      select row_number() over() as id,a.* from (
		select id_grupo,idfornecedor,razao_social,acomulado.idproduto,descricao_produto, codigo_barras,idunidade_medida as und_venda,
            CASE
                WHEN  getclassfinanceira(sum(acomulado.perc_csm) OVER (ORDER BY acomulado.csm DESC))::text = ''A''::text THEN ''A''::text
                WHEN  getclassfinanceira(sum(acomulado.perc_csm) OVER (ORDER BY acomulado.csm DESC))::text = ''B''::text THEN ''B''::text
                ELSE ''C''::text
            END AS class_abc,media_venda as media_saidas,valor_unitario,round(csm,2) total_acomulado, estoque as estoque_atual
        from
            (  
            select id_grupo,idfornecedor,idproduto,descricao_produto,csm::numeric,total_saidas::numeric,(csm / nullif(total_saidas,0))::numeric as perc_csm,estoque, codigo_barras,media_venda,valor_unitario,idunidade_medida from(
               select id_grupo,idfornecedor,idproduto,descricao_produto,consumo_medio_mensal as media_venda,(valor_unitario) valor_unitario,(consumo_medio_mensal*(valor_unitario)) as csm,
               sum(consumo_medio_mensal*(valor_unitario )) over() as total_saidas,estoque,codigo_barras,idunidade_medida
                from vw_grupo_compras_produtos_mt  p  
                where id_grupo =%L and idfamilia_produto=%L
                order by csm desc,	idproduto) prod
            ) acomulado inner join fornecedor f on f.id = acomulado.idfornecedor ) a
        ', table_temp1,p_grupo,p_departamento);
	
   else
	
	
 execute format('create temporary table if not exists %I  as 
      select row_number() over() as id,a.* from (
		select id_grupo,idfornecedor,razao_social,acomulado.idproduto,descricao_produto, codigo_barras,idunidade_medida as und_venda,
            CASE
                WHEN  getclassfinanceira(sum(acomulado.perc_csm) OVER (ORDER BY acomulado.csm DESC))::text = ''A''::text THEN ''A''::text
                WHEN  getclassfinanceira(sum(acomulado.perc_csm) OVER (ORDER BY acomulado.csm DESC))::text = ''B''::text THEN ''B''::text
                ELSE ''C''::text
            END AS class_abc,media_venda as media_saidas,valor_unitario,round(csm,2) total_acomulado, estoque as estoque_atual
        from
            (  
            select id_grupo,idfornecedor,idproduto,descricao_produto,csm::numeric,total_saidas::numeric,(csm / nullif(total_saidas,0))::numeric as perc_csm,estoque, codigo_barras,media_venda,valor_unitario,idunidade_medida from(
               select id_grupo,idfornecedor,idproduto,descricao_produto,consumo_medio_mensal as media_venda,(valor_unitario) valor_unitario,(consumo_medio_mensal*(valor_unitario)) as csm,
               sum(consumo_medio_mensal*(valor_unitario )) over() as total_saidas,estoque,codigo_barras,idunidade_medida
                from vw_grupo_compras_produtos_mt  p  
                where id_grupo =%L
                order by csm desc,	idproduto) prod
            ) acomulado inner join fornecedor f on f.id = acomulado.idfornecedor ) a
        ', table_temp1,p_grupo);
	end if;
	

	   
 truncate table analise_produtos_abc;

 for rec_dados in (select * from _tmp_classificacao_abc)	
 
 loop 
	   
      INSERT INTO analise_produtos_abc
           (id,id_grupo, idfornecedor, razao_social, idproduto, descricao_produto, codigo_barras, class_abc, media_saidas, valor_unitario, total_acomulado,und_venda, estoque_atual)
        VALUES(rec_dados.id,rec_dados.id_grupo, rec_dados.idfornecedor, rec_dados.razao_social, rec_dados.idproduto, rec_dados.descricao_produto, rec_dados.codigo_barras, rec_dados.class_abc, rec_dados.media_saidas, rec_dados.valor_unitario, rec_dados.total_acomulado,rec_dados.und_venda ,rec_dados.estoque_atual);

      
       -- Vendas 
	
	    sql_txt = 'update analise_produtos_abc set ';
	    num_count = 0;
   
        for rec_vendas in (
        
                  select a.*,'venda_' || row_number() over() as campo from (
						select
							ano,
							mes,
							idproduto,
							 sum(total) as total,
							 (select
								 count(distinct mes)
								from
									tmp_total_vendas_semestral
								where
									id_grupo = rec_dados.id_grupo
									and idproduto = rec_dados.idproduto) t_linhas
						from
							tmp_total_vendas_semestral
						where
							id_grupo = rec_dados.id_grupo
							and idproduto = rec_dados.idproduto
					    group by 
					     ano,
						 mes,
						 idproduto
						order by
							ano,
							mes)a
						                                
                          )
                                
             loop 
             
                  num_count = num_count + 1;
                 
                
                 if rec_vendas.campo='venda_'||rec_vendas.t_linhas then
                 
                    sql_txt = sql_txt || rec_vendas.campo||'='||rec_vendas.total;
                    sql_txt = sql_txt ||' where idproduto='''||rec_vendas.idproduto||'''';
                   
                   else
                   
                   sql_txt = sql_txt || rec_vendas.campo||'='||rec_vendas.total||',';
                  
                 end if;
             
             
             end loop;
            
            if num_count > 0 then execute sql_txt; end if;
            
            
           
           
            sql_txt = 'update analise_produtos_abc set ';
            num_count = 0;
       
           
            
        --Estoque     
           for rec_estoque in (
							   select a.*,'saldo_'||row_number() over() as campo from (
								select
									ano,
									mes,
									idproduto,
									sum(estoque) as estoque,
									(select
								      count(distinct mes)
								from
									tmp_total_saldo_estoque_semestral
								where
									id_grupo =rec_dados.id_grupo
									and idproduto = rec_dados.idproduto) t_linhas
								from
									tmp_total_saldo_estoque_semestral
								where
									id_grupo =rec_dados.id_grupo
									and idproduto = rec_dados.idproduto
							     group by 
							     ano,
								 mes,
								 idproduto		
								order by
									ano,mes)a
             				)
                                
             loop 
             
                 num_count = num_count + 1; 
                
                 if rec_estoque.campo='saldo_'||rec_estoque.t_linhas then
                 
                    sql_txt = sql_txt || rec_estoque.campo||'='||rec_estoque.estoque;
                    sql_txt = sql_txt ||' where idproduto='''||rec_estoque.idproduto||'''';
                   
                   else 
                   
                   sql_txt = sql_txt || rec_estoque.campo||'='||rec_estoque.estoque||',';
                  
                 end if;
                                    
             end loop;
            
            if num_count > 0 then execute sql_txt; end if;
           

  end loop;	   
 
 return '1';

       
end
$function$

