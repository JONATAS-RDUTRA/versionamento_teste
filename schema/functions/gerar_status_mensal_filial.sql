CREATE OR REPLACE FUNCTION public.gerar_status_mensal_filial(p_ano numeric, p_mes numeric)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
declare 
    

    rec_data record;
    rec_dados record;

    tot_est_real numeric;
    qtd_itens_real numeric;
   
    tot_est_residual numeric;
    qtd_itens_residual numeric;
    perc_est_residual numeric;
   
    tot_est_exc numeric;
    qtd_itens_exc numeric;
    perc_est_exc numeric;
   
    tot_est_ideal numeric;
    qtd_itens_ideal numeric;
    perc_est_ideal numeric;
   
    tot_est_nece numeric;
    qtd_itens_nece numeric;
    perc_est_nece numeric;
   
   
    tot_est_matu numeric;
    qtd_itens_matu numeric;
    perc_est_matu numeric;
   
    table_temp varchar;
    dataref  date;
    existe numeric;
   
begin
	
	table_temp =  '_tmp_status_mensal_filial';
    
    select last_day(('01/'||lpad(CAST(p_mes AS VARCHAR),2,'0')||'/'||p_ano)::date) into dataref;
   
   
    if dataref > current_date then
    
       dataref = current_date -1;
     
    end if; 
    
    
    drop table if exists _tmp_status_mensal_filial;
	
	 EXECUTE format('create temporary table if not exists %I  as
				select g.id_grupo,
                s.ano,s.mes, 
    			p.descricao_produto,
   				(coalesce(nullif(s.preco_custo,0),p.custo_unitario)*p.fator_conversao) custo_unitario,
			    (p.valor_unitario*p.fator_conversao) valor_unitario,
			    s.estoque,
			    h.filial,
			    h.idproduto,
			    h.data_solicitacao,
			    h.arvore_decisao,
			    h.estoque_seguranca,
			    h.ponto_pedido,
			    h.estoque_maximo,
                (h.estoque_maximo*ns.peso) estoque_maximo_elast,
			    h.consumo_medio,
			    h.sugestao,
			    h.processamento,
			    getcompra_transito_grupo(g.id_grupo,h.idproduto)/p.fator_conversao as compra_transito_grupo,
                case  when h.ponto_pedido >(s.estoque+ (getcompra_transito_grupo(g.id_grupo,h.idproduto)/p.fator_conversao)) then (h.estoque_maximo*ns.peso) - (s.estoque+ (getcompra_transito_grupo(g.id_grupo,h.idproduto)/p.fator_conversao)) else 0 end necessidade,
                p.tempo_medio_apanhe,
                (data_solicitacao-p.data_cadastro) as tempo_vida_produto,
                p.status,
                p.revenda
			   FROM saldo_filiais s
			     JOIN hist_analise_compras_filial h ON h.filial  = s.filial  and h.idproduto::text = s.idproduto::text AND h.data_solicitacao = s.data
			     JOIN produtos_filial p on p.filial= s.filial  and p.idproduto::text = s.idproduto::text
                  inner join familia_produtos
			     on p.idfamilia_produto = familia_produtos.idfamilia_produto
                 inner join nivel_servico ns  on ns.descricao_nivel_servico = p.nivel_servico
                 inner join grupo_filial  g on g.filial = s.filial  
			  WHERE s.data = ''%I'' AND familia_produtos.filtro=''N''',table_temp,dataref); 
                  
                  
                  
          for rec_dados in (select * from _tmp_status_mensal_filial where revenda ='S')
           loop
           
              select count(*) into existe from analise_status_mensal_filial_analitica asmfa 
                  where asmfa.id_grupo = rec_dados.id_grupo 
                  and  asmfa.filial = rec_dados.filial
                  and asmfa.ano = rec_dados.ano
                  and asmfa.mes = rec_dados.mes 
                  and asmfa.idproduto = rec_dados.idproduto;
                 
                 if existe=0 then
                 
                    INSERT INTO analise_status_mensal_filial_analitica
						(id_grupo, ano, mes, descricao_produto, custo_unitario, valor_unitario, estoque, filial, idproduto, data_solicitacao, arvore_decisao, estoque_seguranca, ponto_pedido, estoque_maximo, estoque_maximo_elast, consumo_medio, sugestao, processamento, compra_transito_grupo, necessidade, tempo_medio_apanhe, tempo_vida_produto, status, revenda)
					VALUES(rec_dados.id_grupo, rec_dados.ano, rec_dados.mes, rec_dados.descricao_produto, rec_dados.custo_unitario, rec_dados.valor_unitario, rec_dados.estoque, rec_dados.filial, rec_dados.idproduto, rec_dados.data_solicitacao, rec_dados.arvore_decisao, rec_dados.estoque_seguranca, rec_dados.ponto_pedido,
				           rec_dados.estoque_maximo, rec_dados.estoque_maximo_elast, rec_dados.consumo_medio, rec_dados.sugestao, rec_dados.processamento, rec_dados.compra_transito_grupo, rec_dados.necessidade, rec_dados.tempo_medio_apanhe, rec_dados.tempo_vida_produto, rec_dados.status, rec_dados.revenda);

                 
                  else
                  
                   UPDATE analise_status_mensal_filial_analitica
					SET descricao_produto=rec_dados.descricao_produto,
					   custo_unitario=rec_dados.custo_unitario,
					   valor_unitario=rec_dados.valor_unitario,
					   estoque=rec_dados.estoque,
					   data_solicitacao=rec_dados.data_solicitacao,
					   arvore_decisao=rec_dados.arvore_decisao,
					   estoque_seguranca=rec_dados.estoque_seguranca,
					   ponto_pedido=rec_dados.ponto_pedido,
					   estoque_maximo=rec_dados.estoque_maximo,
					   estoque_maximo_elast=rec_dados.estoque_maximo_elast,
					   consumo_medio=rec_dados.consumo_medio,
					   sugestao=rec_dados.sugestao,
					   processamento=rec_dados.processamento,
					   compra_transito_grupo=rec_dados.compra_transito_grupo,
					   necessidade=rec_dados.necessidade,
					   tempo_medio_apanhe=rec_dados.tempo_medio_apanhe,
					   tempo_vida_produto=rec_dados.tempo_vida_produto,
					   status=rec_dados.status,
					   revenda=rec_dados.revenda
				   WHERE id_grupo=rec_dados.id_grupo AND filial=rec_dados.filial AND ano=rec_dados.ano AND mes=rec_dados.mes AND idproduto=rec_dados.idproduto;

                  
                 end if; 
           
           end loop;
          
          
          
          
                       
          for rec_data in ( select distinct id_grupo,filial,ano,mes from _tmp_status_mensal_filial) 
            loop 
			 
			 --Real                  
	 
			select sum(custo_unitario*estoque) ,count(*) into tot_est_real,qtd_itens_real from _tmp_status_mensal_filial 
		        where filial= rec_data.filial  and revenda='S' ; -- and tempo_vida_produto > 180 and status <>'FL'
		
		
		    -- Ideal
		    
			select sum(custo_unitario*estoque_maximo) ,count(*) into tot_est_ideal,qtd_itens_ideal from _tmp_status_mensal_filial 
		         where filial= rec_data.filial   and status <>'FL' and revenda='S';-- and tempo_vida_produto > 180
		
		    -- Excesso

			select sum(custo_unitario*(estoque-estoque_maximo_elast)),count(*) into tot_est_exc,qtd_itens_exc from _tmp_status_mensal_filial 
			where  filial= rec_data.filial and  estoque > estoque_maximo_elast   and revenda='S'; -- and tempo_vida_produto > 180 and status <>'FL'
		
		   -- Resisual
		
		   tot_est_residual = tot_est_real - tot_est_exc ;
		   qtd_itens_residual = qtd_itens_real - qtd_itens_exc ;
		  
		  --Necessidade
		  
		   select sum(custo_unitario*(necessidade)),count(*) into tot_est_nece,qtd_itens_nece from _tmp_status_mensal_filial 
			 where filial= rec_data.filial and necessidade > 0   and status <>'FL' and revenda='S'; --and tempo_vida_produto > 180
			
			
	      --Itens Maturação
	      
		   select sum(custo_unitario*estoque) ,count(*) into tot_est_matu,qtd_itens_matu from _tmp_status_mensal_filial 
		     where filial= rec_data.filial and tempo_vida_produto <= 180   and revenda='S' ; --and status <>'FL'
		  
	       --tot_est_nece = tot_est_ideal - tot_est_residual;
	       --qtd_itens_nece = qtd_itens_ideal - qtd_itens_residual;
		  
		   perc_est_residual = round(((tot_est_residual / nullif(tot_est_real,0))*100),2);
		   perc_est_exc = round(((tot_est_exc / nullif(tot_est_real,0))*100),2);
		   perc_est_nece = round(((tot_est_nece / nullif(tot_est_real,0))*100),2);
		   perc_est_ideal = round(((tot_est_ideal / nullif(tot_est_real,0))*100),2);
		   perc_est_matu = 0; 
		  
		   select count(*) into existe from analise_status_mensal_filial where filial= rec_data.filial and  ano = rec_data.ano and mes = rec_data.mes;
		  		  
		  if existe > 0 then 
		 	
				update
						public.analise_status_mensal_filial
					set
						total_estoque_real = coalesce(tot_est_real,0),
						qtde_itens_real = coalesce(qtd_itens_real,0),
						total_estoque_residual = coalesce(tot_est_residual,0),
						qtde_itens_residual = coalesce(qtd_itens_residual,0),
						perc_estoque_residual = coalesce(perc_est_residual,0),
						total_estoque_excesso = coalesce(tot_est_exc,0),
						qtde_itens_excesso = coalesce(qtd_itens_exc,0),
						perc_estoque_excesso = coalesce(perc_est_exc,0),
						total_estoque_necessidade = coalesce(tot_est_nece,0),
						qtde_itens_necessidade = coalesce(qtd_itens_nece,0),
						perc_estoque_necessidade = coalesce(perc_est_nece,0),
						total_estoque_ideal = coalesce(tot_est_ideal,0),
						qtde_itens_ideal = coalesce(qtd_itens_ideal,0),
						perc_estoque_ideal = coalesce(perc_est_ideal,0),
					    total_estoque_novo = coalesce(tot_est_matu,0),
						qtde_itens_novo = coalesce(qtd_itens_matu,0),
						perc_estoque_novo = coalesce(perc_est_matu,0),
						processamento = now()
					where
					    filial =rec_data.filial 
						and ano = rec_data.ano
						and mes = rec_data.mes;

		    else
		    
				    insert
					into public.analise_status_mensal_filial (grupo,filial,ano,mes,
					    total_estoque_real,
						qtde_itens_real,
						total_estoque_residual,
						qtde_itens_residual,
						perc_estoque_residual,
						total_estoque_excesso,
						qtde_itens_excesso,
						perc_estoque_excesso,
						total_estoque_necessidade,
						qtde_itens_necessidade,
						perc_estoque_necessidade,
						total_estoque_ideal,
						qtde_itens_ideal,
						perc_estoque_ideal,
						total_estoque_novo ,
						qtde_itens_novo ,
						perc_estoque_novo ,
						processamento)
					values( rec_data.id_grupo,
					        rec_data.filial,
					        rec_data.ano,rec_data.mes,
					        coalesce(tot_est_real,0),
							coalesce(qtd_itens_real,0),
							coalesce(tot_est_residual,0),
							coalesce(qtd_itens_residual,0),
							coalesce(perc_est_residual,0),
							coalesce(tot_est_exc,0),
							coalesce(qtd_itens_exc,0),
							coalesce(perc_est_exc,0),
							coalesce(tot_est_nece,0),
							coalesce(qtd_itens_nece,0),
							coalesce(perc_est_nece,0),
							coalesce(tot_est_ideal,0),
							coalesce(qtd_itens_ideal,0),
							coalesce(perc_est_ideal,0),
						    coalesce(tot_est_matu,0),
							coalesce(qtd_itens_matu,0),
							coalesce(perc_est_matu,0),
							now());

		  end if;
		 
		end loop; 
		     
    return '1';

end;

$function$

