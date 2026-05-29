CREATE OR REPLACE FUNCTION public.processar_totais()
 RETURNS void
 LANGUAGE plpgsql
 PARALLEL SAFE
AS $function$
declare
 
rec_grupo record;
rec_totais_forn record; 
rec_totais_comp record;
rec_totais_seg record;
    
begin
	
update totais_produtos_fonecedores set status ='D' where idgrupo in (select id from grupo_compras);
update totais_produtos_compradores set status ='D' where idgrupo in (select id from grupo_compras);
update totais_produtos_segmentos set status ='D' where idgrupo in (select id from grupo_compras);	
	
for rec_grupo in (select id from grupo_compras gc)
  loop 
  
   -- totais_produtos_fonecedores
   
   for rec_totais_forn in(
   
   
   		with total_venda_tri as (
  
	     select pf.idfornecedor ,coalesce(round(round(sum(c.qtde * c.valor_unit::double precision)::numeric, 2)/3,2),0) AS total
	      from consumos c 
	       inner join produtos_filial pf  
	       on pf.filial = c.filial  
	       and pf.idproduto = c.idproduto 
	      inner join grupo_filial gf 
	       on gf.filial = c.filial 
	       where gf.id_grupo=rec_grupo.id and  emissao between (date_trunc('month', now()) - INTERVAL '3' month)::date  and (date_trunc('month', now())::date-1)::date and pf.idfornecedor is not null
	       group by pf.idfornecedor
	       
        ), produtos_saldos as (
        
            select 	idfornecedor,total_estoque,total_estoque_venda,
				(coalesce(round((total_estoque_venda/nullif(total_estoque,0)),4),0)) as fator_markup_medio,
				(coalesce(round((total_estoque_venda/nullif(total_estoque,0))-1,4),0))*100 as markup_medio,
				potencial_venda,
				coalesce(round(((potencial_venda/nullif(round(total_estoque_venda/nullif(total_estoque,0),4),0))),4),0) potencial_rentabilidade
				from (        
				select 
				idfornecedor, 
				round(sum(estoque*custo_unitario),2)  as total_estoque,
				round(sum(estoque*valor_unitario),2)  as total_estoque_venda,
				round(sum(consumo_medio_mensal * preco_medio_venda),2) as potencial_venda
				from produtos_filial 
				where  filial in (select filial from grupo_filial where id_grupo=rec_grupo.id) and status='A' and revenda = 'S' and processar_analise='S' group by idfornecedor) a	        
	       
        ), produtos_stats as (
        
        
           select idfornecedor,
			count(*) as qtde_geral_itens,
			count(*) filter (where lote_compras = 0 and estoque > estoque_maximo) qtde_itens_excesso,
			count(*) filter (where lote_compras = 0 and estoque <= estoque_maximo and estoque >= ponto_pedido) qtde_itens_ok,
			count(*) filter (where compra_transito > 0 ) qtde_itens_transito,
			round(avg(coalesce(round(((estoque/nullif(estoque_maximo,0))*100)::numeric,2),0)),2) as nivel_estoque_medio
			from produtos_compras_grupo vgcpm  where vgcpm.id_grupo=rec_grupo.id
			group by idfornecedor
        
        ),produtos_ressuprimento as (
        
        
            select w.idfornecedor ,count(*) as qtde_itens_ressuprir,coalesce(round(sum(w.sugestao * c.preco_compra)::numeric,2),0) as tot_ressuprir  from vw_lista_compras_dinamica_grupo w 
				  inner join produtos_compras_grupo c
					              on c.id_grupo = w.id_grupo 
					              and c.idproduto = w.idproduto 
				 where w.id_grupo=rec_grupo.id and (w.idfornecedor, w.idproduto) not in 
				             ( select npb.idfornecedor ,npb.idproduto from notificacao_produtos_blacklist npb 
						        where grupo= rec_grupo.id
						        and data_limite >= current_date 
						        and deleted_at is null
						        )
					 group by w.idfornecedor     
        
        
        )
        
           select 
	     	id,
			razao_social,
			coalesce(qtde_geral_itens,0) qtde_geral_itens,
			coalesce(qtde_itens_excesso,0) qtde_itens_excesso,
			coalesce(qtde_itens_ok,0) qtde_itens_ok,
			coalesce(qtde_itens_transito,0) qtde_itens_transito,
			coalesce(qtde_itens_ressuprir,0) qtde_itens_ressuprir,
	    	coalesce(tot_ressuprir,0) tot_ressuprir,
			coalesce(total_estoque,0) total_estoque,
			coalesce(total_estoque_venda,0) total_estoque_venda,
			coalesce(nivel_estoque_medio,0) nivel_estoque_medio,
			coalesce(fator_markup_medio,0) fator_markup_medio,
			coalesce(markup_medio,0) markup_medio,
			coalesce(potencial_venda,0) potencial_venda,
			coalesce(potencial_rentabilidade,0) potencial_rentabilidade,
			coalesce((select total from total_venda_tri tvt where tvt.idfornecedor = a.id),0) as venda_trimestral
	
	    from (
	        select f.id,
	        f.razao_social,
	        pst.qtde_geral_itens,
			pst.qtde_itens_excesso,
			pst.qtde_itens_ok,
			pst.qtde_itens_transito,
			prs.qtde_itens_ressuprir,
	    	prs.tot_ressuprir,
	    	psd.total_estoque,
			psd.total_estoque_venda,
			pst.nivel_estoque_medio,
			psd.fator_markup_medio,
			psd.markup_medio,
			psd.potencial_venda,
			psd.potencial_rentabilidade
	        from fornecedor f 
	        left join produtos_stats pst
	         on pst.idfornecedor = f.id
	        left join  produtos_ressuprimento prs
	         on prs.idfornecedor = f.id
	        left join produtos_saldos psd 
	         on psd.idfornecedor = f.id
	        where exists (select 'X' from produtos_compras_grupo where idfornecedor=f.id  and id_grupo=rec_grupo.id limit 1))a
   
        
   ) 
   
   	loop 
   	
   	
   	   UPDATE totais_produtos_fonecedores
		SET qtde_geral_itens=rec_totais_forn.qtde_geral_itens, qtde_itens_excesso=rec_totais_forn.qtde_itens_excesso, qtde_itens_ok=rec_totais_forn.qtde_itens_ok, 
		    qtde_itens_transito=rec_totais_forn.qtde_itens_transito, qtde_itens_ressuprir=rec_totais_forn.qtde_itens_ressuprir, total_estoque=rec_totais_forn.total_estoque,status=null,
		    total_ressuprir = rec_totais_forn.tot_ressuprir,
		    total_estoque_venda=rec_totais_forn.total_estoque_venda, markup_medio=rec_totais_forn.markup_medio, nivel_estoque=rec_totais_forn.nivel_estoque_medio, 
		    projecao_venda_mensal=rec_totais_forn.potencial_venda, projecao_rentabilidade_mensal=rec_totais_forn.potencial_rentabilidade,media_venda_trimestre_anterior=rec_totais_forn.venda_trimestral
		WHERE idgrupo=rec_grupo.id AND idfornecedor=rec_totais_forn.id;
   	
   		if not found then 
   		
   			INSERT INTO totais_produtos_fonecedores
				(idgrupo, idfornecedor, qtde_geral_itens, qtde_itens_excesso, qtde_itens_ok, qtde_itens_transito, qtde_itens_ressuprir, total_estoque,total_ressuprir,total_estoque_venda,markup_medio,nivel_estoque,projecao_venda_mensal,projecao_rentabilidade_mensal,media_venda_trimestre_anterior)
				VALUES(rec_grupo.id, rec_totais_forn.id, rec_totais_forn.qtde_geral_itens, rec_totais_forn.qtde_itens_excesso, rec_totais_forn.qtde_itens_ok, rec_totais_forn.qtde_itens_transito,
			rec_totais_forn.qtde_itens_ressuprir, rec_totais_forn.total_estoque,rec_totais_forn.tot_ressuprir,rec_totais_forn.total_estoque_venda,rec_totais_forn.fator_markup_medio,rec_totais_forn.nivel_estoque_medio,rec_totais_forn.potencial_venda,rec_totais_forn.potencial_rentabilidade,rec_totais_forn.venda_trimestral);

   		end if;
   	
   	end loop;
   
   
   --totais_produtos_compradores
  
   for rec_totais_comp in(
   
        with total_venda_tri as (
  
	     select pf.idcomprador ,coalesce(round(round(sum(c.qtde * c.valor_unit::double precision)::numeric, 2)/3,2),0) AS total
	      from consumos c 
	       inner join produtos_filial pf  
	       on pf.filial = c.filial  
	       and pf.idproduto = c.idproduto 
	      inner join grupo_filial gf 
	       on gf.filial = c.filial 
	       where gf.id_grupo=rec_grupo.id and  emissao between (date_trunc('month', now()) - INTERVAL '3' month)::date  and (date_trunc('month', now())::date-1)::date
	       group by pf.idcomprador
	       
        ), produtos_saldos as (
        
              select 	idcomprador,qtde_fornecedores,total_estoque,total_estoque_venda,
				(coalesce(round((total_estoque_venda/nullif(total_estoque,0)),4),0)) as fator_markup_medio,
				(coalesce(round((total_estoque_venda/nullif(total_estoque,0))-1,4),0))*100 as markup_medio,
				potencial_venda,
				coalesce(round(((potencial_venda/nullif(round(total_estoque_venda/nullif(total_estoque,0),4),0))),4),0) potencial_rentabilidade
				from (        
				select 
				idcomprador, 
				count( distinct idfornecedor) as qtde_fornecedores,
				round(sum(estoque*custo_unitario),2)  as total_estoque,
				round(sum(estoque*valor_unitario),2)  as total_estoque_venda,
				round(sum(consumo_medio_mensal * valor_unitario),2) as potencial_venda
				from produtos_filial 
				where  filial in (select filial from grupo_filial where id_grupo=rec_grupo.id) and status='A' and revenda = 'S' and processar_analise='S' group by idcomprador) a
        
        ), produtos_stats as  (
        
            select idcomprador ,
			count(*) as qtde_geral_itens,
			count(*) filter (where lote_compras = 0 and estoque > estoque_maximo) qtde_itens_excesso,
			count(*) filter (where lote_compras = 0 and estoque <= estoque_maximo and estoque >= ponto_pedido) qtde_itens_ok,
			count(*) filter (where compra_transito > 0 ) qtde_itens_transito,
			round(avg(coalesce(round(((estoque/nullif(estoque_maximo,0))*100)::numeric,2),0)),2) as nivel_estoque_medio
			from produtos_compras_grupo vgcpm  where vgcpm.id_grupo=rec_grupo.id
			group by idcomprador
             
        ), produtos_ressuprimento as (
        
        
	   	     select w.idcomprador ,count(*) as qtde_itens_ressuprir,coalesce(round(sum(w.sugestao * c.preco_compra)::numeric,2),0) as tot_ressuprir  from vw_lista_compras_dinamica_grupo w 
			  inner join produtos_compras_grupo c
				              on c.id_grupo = w.id_grupo 
				              and c.idproduto = w.idproduto 
			 where w.id_grupo=rec_grupo.id and (w.idfornecedor, w.idproduto) not in 
			             ( select npb.idfornecedor ,npb.idproduto from notificacao_produtos_blacklist npb 
					        where grupo=rec_grupo.id
					        and data_limite >= current_date 
					        and deleted_at is null
					        )
				 group by w.idcomprador     

        
        )
        
	      select 
	        id,
			nome_completo,
			coalesce(qtde_fornecedores,0) qtde_fornecedores,
			coalesce(qtde_geral_itens,0) qtde_geral_itens,
			coalesce(qtde_itens_excesso,0) qtde_itens_excesso,
			coalesce(qtde_itens_ok,0) qtde_itens_ok,
			coalesce(qtde_itens_transito,0) qtde_itens_transito,
			coalesce(qtde_itens_ressuprir,0) qtde_itens_ressuprir,
	    	coalesce(tot_ressuprir,0) tot_ressuprir,
			coalesce(total_estoque,0) total_estoque,
			coalesce(total_estoque_venda,0) total_estoque_venda,
			coalesce(nivel_estoque_medio,0) nivel_estoque_medio,
			coalesce(fator_markup_medio,0) fator_markup_medio,
			coalesce(markup_medio,0) markup_medio,
			coalesce(potencial_venda,0) potencial_venda,
			coalesce(potencial_rentabilidade,0) potencial_rentabilidade,
			coalesce(eficiencia,0) eficiencia,
			coalesce((select total from total_venda_tri tvt where tvt.idcomprador = a.id),0) as venda_trimestral
            from (
                select id,nome_completo,
                 
	                psd.qtde_fornecedores, 
	                pst.qtde_geral_itens,
					pst.qtde_itens_excesso,
					pst.qtde_itens_ok,
					pst.qtde_itens_transito,
					prs.qtde_itens_ressuprir,
			    	prs.tot_ressuprir,
			    	psd.total_estoque,
					psd.total_estoque_venda,
					pst.nivel_estoque_medio,
					psd.fator_markup_medio,
					psd.markup_medio,
					psd.potencial_venda,
					psd.potencial_rentabilidade,
	                get_eficiencia_comprador(c.id,rec_grupo.id) as eficiencia
                from comprador c
                  left join produtos_stats pst
	         		on pst.idcomprador = c.id
	        	 left join  produtos_ressuprimento prs
	         		on prs.idcomprador = c.id
	        	 left join produtos_saldos psd 
	         			on psd.idcomprador = c.id
                where   exists (select 'X' from produtos_compras_grupo where id_grupo=rec_grupo.id and idcomprador=c.id limit 1)
            ) a
        
   ) 
   
   	loop 
   	
   	
   	   UPDATE totais_produtos_compradores
		SET qtde_geral_itens=rec_totais_comp.qtde_geral_itens, qtde_itens_excesso=rec_totais_comp.qtde_itens_excesso, qtde_itens_ok=rec_totais_comp.qtde_itens_ok, 
		    qtde_itens_transito=rec_totais_comp.qtde_itens_transito, qtde_itens_ressuprir=rec_totais_comp.qtde_itens_ressuprir, total_estoque=rec_totais_comp.total_estoque,
		    qtde_fornecedores = rec_totais_comp.qtde_fornecedores,eficiencia =rec_totais_comp.eficiencia,status=null,total_ressuprir = rec_totais_comp.tot_ressuprir,
		    total_estoque_venda=rec_totais_comp.total_estoque_venda, markup_medio=rec_totais_comp.markup_medio, nivel_estoque=rec_totais_comp.nivel_estoque_medio, 
		    projecao_venda_mensal=rec_totais_comp.potencial_venda, projecao_rentabilidade_mensal=rec_totais_comp.potencial_rentabilidade,media_venda_trimestre_anterior=rec_totais_comp.venda_trimestral
		WHERE idgrupo=rec_grupo.id AND idcomprador=rec_totais_comp.id;
   	
   		if not found then 
   		
   			INSERT INTO totais_produtos_compradores
				(idgrupo, idcomprador, qtde_geral_itens, qtde_itens_excesso, qtde_itens_ok, qtde_itens_transito, qtde_itens_ressuprir, total_estoque,qtde_fornecedores,eficiencia,total_ressuprir,total_estoque_venda,markup_medio,nivel_estoque,projecao_venda_mensal,projecao_rentabilidade_mensal,media_venda_trimestre_anterior )
				VALUES(rec_grupo.id, rec_totais_comp.id, rec_totais_comp.qtde_geral_itens, rec_totais_comp.qtde_itens_excesso, rec_totais_comp.qtde_itens_ok, rec_totais_comp.qtde_itens_transito,
			rec_totais_comp.qtde_itens_ressuprir, rec_totais_comp.total_estoque,rec_totais_comp.qtde_fornecedores,rec_totais_comp.eficiencia,rec_totais_comp.tot_ressuprir,
		   rec_totais_comp.total_estoque_venda,rec_totais_comp.fator_markup_medio,rec_totais_comp.nivel_estoque_medio,rec_totais_comp.potencial_venda,rec_totais_comp.potencial_rentabilidade,rec_totais_comp.venda_trimestral);

   		end if;
   	
   	end loop;
   
   
   --totais_produtos_segmentos
  
   for rec_totais_seg in(
   
        with total_venda_tri as (
  
	     select pf.idfamilia_produto ,coalesce(round(round(sum(c.qtde * c.valor_unit::double precision)::numeric, 2)/3,2),0) AS total
	      from consumos c 
	       inner join produtos_filial pf  
	       on pf.filial = c.filial  
	       and pf.idproduto = c.idproduto 
	      inner join grupo_filial gf 
	       on gf.filial = c.filial 
	       where gf.id_grupo=rec_grupo.id and  emissao between (date_trunc('month', now()) - INTERVAL '3' month)::date  and (date_trunc('month', now())::date-1)::date
	       group by pf.idfamilia_produto
        ) , produtos_saldos as (
           
        
           		select 	idfamilia_produto,qtde_fornecedores,total_estoque,total_estoque_venda,
				(coalesce(round((total_estoque_venda/nullif(total_estoque,0)),4),0)) as fator_markup_medio,
				(coalesce(round((total_estoque_venda/nullif(total_estoque,0))-1,4),0))*100 as markup_medio,
				potencial_venda,
				coalesce(round(((potencial_venda/nullif(round(total_estoque_venda/nullif(total_estoque,0),4),0))),4),0) potencial_rentabilidade
				from (        
				select 
				idfamilia_produto, 
				count( distinct idfornecedor) as qtde_fornecedores,
				round(sum(estoque*custo_unitario),2)  as total_estoque,
				round(sum(estoque*valor_unitario),2)  as total_estoque_venda,
				round(sum(consumo_medio_mensal * valor_unitario),2) as potencial_venda
				from produtos_filial 
				where  filial in (select filial from grupo_filial where id_grupo=rec_grupo.id) and status='A' and revenda = 'S' and processar_analise='S' group by idfamilia_produto) a  
        
        ), produtos_stats as  (
        
        
	         select idfamilia_produto,
				count(*) as qtde_geral_itens,
				count(*) filter (where lote_compras = 0 and estoque > estoque_maximo) qtde_itens_excesso,
				count(*) filter (where lote_compras = 0 and estoque <= estoque_maximo and estoque >= ponto_pedido) qtde_itens_ok,
				count(*) filter (where compra_transito > 0 ) qtde_itens_transito,
				round(avg(coalesce(round(((estoque/nullif(estoque_maximo,0))*100)::numeric,2),0)),2) as nivel_estoque_medio
				from produtos_compras_grupo vgcpm  where vgcpm.id_grupo=rec_grupo.id
				group by idfamilia_produto
        
        
        ) , produtos_ressuprimento as (
        
        
	         select w.iddepartamento ,count(*) as qtde_itens_ressuprir,coalesce(round(sum(w.sugestao * c.preco_compra)::numeric,2),0) as tot_ressuprir  from vw_lista_compras_dinamica_grupo w 
					  inner join produtos_compras_grupo c
						              on c.id_grupo = w.id_grupo 
						              and c.idproduto = w.idproduto 
					 where w.id_grupo=rec_grupo.id and (w.idfornecedor, w.idproduto) not in 
					             ( select npb.idfornecedor ,npb.idproduto from notificacao_produtos_blacklist npb 
							        where grupo= rec_grupo.id
							        and data_limite >= current_date 
							        and deleted_at is null
							        )
						 group by w.iddepartamento 
        )
   
	      select 
            idfamilia_produto,
			descricao_familia_produto,
			coalesce(qtde_fornecedores,0) qtde_fornecedores,
			coalesce(qtde_geral_itens,0) qtde_geral_itens,
			coalesce(qtde_itens_excesso,0) qtde_itens_excesso,
			coalesce(qtde_itens_ok,0) qtde_itens_ok,
			coalesce(qtde_itens_ressuprir,0) qtde_itens_ressuprir,
			coalesce(tot_ressuprir,0) tot_ressuprir,
			coalesce(qtde_itens_transito,0) qtde_itens_transito,
			coalesce(total_estoque,0) total_estoque,
			coalesce(total_estoque_venda,0) total_estoque_venda,
			coalesce(fator_markup_medio,0) fator_markup_medio,
			coalesce(markup_medio,0) markup_medio,
			coalesce(nivel_estoque_medio,0) nivel_estoque_medio,
			coalesce(potencial_venda,0) potencial_venda,
			coalesce(potencial_rentabilidade,0) potencial_rentabilidade,
			coalesce((select total from total_venda_tri tvt where tvt.idfamilia_produto = a.idfamilia_produto),0) as venda_trimestral
          from ( 
          select 
               f.idfamilia_produto,
               f.descricao_familia_produto,
               psd.qtde_fornecedores, 
               pst.qtde_geral_itens,
			   pst.qtde_itens_excesso,
			   pst.qtde_itens_ok,
			   pst.qtde_itens_transito,
			   prs.qtde_itens_ressuprir,
	    	   prs.tot_ressuprir,
	    	   psd.total_estoque,
			   psd.total_estoque_venda,
			   pst.nivel_estoque_medio,
			   psd.fator_markup_medio,
			   psd.markup_medio,
			   psd.potencial_venda,
			 psd.potencial_rentabilidade
        from familia_produtos f
          left join produtos_stats pst
	         on pst.idfamilia_produto = f.idfamilia_produto
	      left join  produtos_ressuprimento prs
	         on prs.iddepartamento = f.idfamilia_produto
	      left join produtos_saldos psd 
	         on psd.idfamilia_produto = f.idfamilia_produto
        where exists (select 'X' from produtos_compras_grupo where id_grupo=rec_grupo.id and idfamilia_produto=f.idfamilia_produto limit 1)) a
            
   ) 
   
   	loop 
   	
   	
   	   UPDATE totais_produtos_segmentos
		SET qtde_geral_itens=rec_totais_seg.qtde_geral_itens, qtde_itens_excesso=rec_totais_seg.qtde_itens_excesso, qtde_itens_ok=rec_totais_seg.qtde_itens_ok, 
		    qtde_itens_transito=rec_totais_seg.qtde_itens_transito, qtde_itens_ressuprir=rec_totais_seg.qtde_itens_ressuprir, total_estoque=rec_totais_seg.total_estoque,
		    qtde_fornecedores = rec_totais_seg.qtde_fornecedores,status=null,total_ressuprir = rec_totais_seg.tot_ressuprir,
		    total_estoque_venda=rec_totais_seg.total_estoque_venda, markup_medio=rec_totais_seg.markup_medio, nivel_estoque=rec_totais_seg.nivel_estoque_medio, 
		    projecao_venda_mensal=rec_totais_seg.potencial_venda, projecao_rentabilidade_mensal=rec_totais_seg.potencial_rentabilidade,media_venda_trimestre_anterior=rec_totais_seg.venda_trimestral
		WHERE idgrupo=rec_grupo.id AND idfamilia_produto =rec_totais_seg.idfamilia_produto;
   	
   		if not found then 
   		
		   			insert
						into
						totais_produtos_segmentos (
						idgrupo,
						idfamilia_produto,
						qtde_geral_itens,
						qtde_itens_excesso,
						qtde_itens_ok,
						qtde_itens_transito,
						qtde_itens_ressuprir,
						total_estoque,
						qtde_fornecedores,
						total_ressuprir,
						total_estoque_venda,
						markup_medio,
						nivel_estoque,
						projecao_venda_mensal,
						projecao_rentabilidade_mensal,
						media_venda_trimestre_anterior)
					values(
					rec_grupo.id,
					rec_totais_seg.idfamilia_produto,
					rec_totais_seg.qtde_geral_itens,
					rec_totais_seg.qtde_itens_excesso,
					rec_totais_seg.qtde_itens_ok,
					rec_totais_seg.qtde_itens_transito,
					rec_totais_seg.qtde_itens_ressuprir,
					rec_totais_seg.total_estoque,
					rec_totais_seg.qtde_fornecedores,
					rec_totais_seg.tot_ressuprir,
					rec_totais_seg.total_estoque_venda,
				    rec_totais_seg.fator_markup_medio,
				    rec_totais_seg.nivel_estoque_medio,
				    rec_totais_seg.potencial_venda,
				    rec_totais_seg.potencial_rentabilidade,
				    rec_totais_seg.venda_trimestral);

   		end if;
   	
   	end loop;
   
   
  end loop;
 
 delete from  totais_produtos_fonecedores where status ='D';
 delete from  totais_produtos_compradores where status ='D';
 delete from  totais_produtos_segmentos  where  status ='D';
 refresh materialized view concurrently vw_lista_compras_dinamica_grupo_mt;
	
end
$function$

