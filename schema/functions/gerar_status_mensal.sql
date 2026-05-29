CREATE OR REPLACE FUNCTION public.gerar_status_mensal(p_ano numeric, p_mes numeric)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
declare 

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
   
    table_temp varchar;
    dataref  date;
    existe numeric;
   
begin
	
	table_temp =  '_tmp_status_mensal';
    
    select last_day(('01/'||lpad(CAST(p_mes AS VARCHAR),2,'0')||'/'||p_ano)::date) into dataref;
    
   -- dataref = current_date-2;
    
    drop table if exists _tmp_status_mensal;
	
	 EXECUTE format('create temporary table if not exists %I  as
                select s.ano,s.mes, 
    			p.descricao_produto,
   				(p.custo_unitario*p.fator_conversao) custo_unitario,
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
                case  when h.ponto_pedido >(s.estoque+ getcompra_transito(h.idproduto)) then (h.estoque_maximo*ns.peso) - (s.estoque+ getcompra_transito(h.idproduto)) else 0 end necessidade
			   FROM saldos s
			     JOIN hist_analise_compras h ON h.idproduto::text = s.idproduto::text AND h.data_solicitacao = s.data
			     JOIN produtos p ON p.idproduto::text = s.idproduto::text
                  inner join familia_produtos
			     on p.idfamilia_produto = familia_produtos.idfamilia_produto
                 inner join nivel_servico ns  on ns.descricao_nivel_servico = p.nivel_servico 
			  WHERE s.data = ''%I'' and (data_solicitacao-p.data_cadastro) > 180
			       and p.status <>''FL'' and p.revenda=''S''
                   AND familia_produtos.filtro=''N''',table_temp,dataref); 
			 
			 --Real
	 
			select sum(custo_unitario*estoque) ,count(*) into tot_est_real,qtd_itens_real from _tmp_status_mensal;
		
		
		    -- Ideal
		    
			select sum(custo_unitario*estoque_maximo) ,count(*) into tot_est_ideal,qtd_itens_ideal from _tmp_status_mensal;
		
		    -- Excesso

			select sum(custo_unitario*(estoque-estoque_maximo_elast)),count(*) into tot_est_exc,qtd_itens_exc from _tmp_status_mensal 
			where estoque > estoque_maximo_elast;
		
		   -- Resisual
		
		   tot_est_residual = tot_est_real - tot_est_exc ;
		   qtd_itens_residual = qtd_itens_real - qtd_itens_exc ;
		  
		  --Necessidade
		  
		   select sum(custo_unitario*(necessidade)),count(*) into tot_est_nece,qtd_itens_nece from _tmp_status_mensal 
			where necessidade > 0;
		  
	       --tot_est_nece = tot_est_ideal - tot_est_residual;
	       --qtd_itens_nece = qtd_itens_ideal - qtd_itens_residual;
		  
		   perc_est_residual = round(((tot_est_residual / tot_est_real)*100),2);
		   perc_est_exc = round(((tot_est_exc / tot_est_real)*100),2);
		   perc_est_nece = round(((tot_est_nece / tot_est_real)*100),2);
		   perc_est_ideal = round(((tot_est_ideal / tot_est_real)*100),2);
		  
		   select count(*) into existe from analise_status_mensal where ano = p_ano and mes = p_mes;
		  		  
		  if existe > 0 then 
		 	
				update
						public.analise_status_mensal
					set
						total_estoque_real = tot_est_real,
						qtde_itens_real = qtd_itens_real,
						total_estoque_residual = tot_est_residual,
						qtde_itens_residual = qtd_itens_residual,
						perc_estoque_residual = perc_est_residual,
						total_estoque_excesso = tot_est_exc,
						qtde_itens_excesso = qtd_itens_exc,
						perc_estoque_excesso = perc_est_exc,
						total_estoque_necessidade = tot_est_nece,
						qtde_itens_necessidade = qtd_itens_nece,
						perc_estoque_necessidade = perc_est_nece,
						total_estoque_ideal = tot_est_ideal,
						qtde_itens_ideal = qtd_itens_ideal,
						perc_estoque_ideal = perc_est_ideal,
						processamento = now()
					where
						ano = p_ano
						and mes = p_mes;

		    else
		    
				    insert
					into public.analise_status_mensal (ano,mes,
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
						processamento)
					values( p_ano,p_mes,
					        tot_est_real,
							qtd_itens_real,
							tot_est_residual,
							qtd_itens_residual,
							perc_est_residual,
							tot_est_exc,
							qtd_itens_exc,
							perc_est_exc,
							tot_est_nece,
							qtd_itens_nece,
							perc_est_nece,
							tot_est_ideal,
							qtd_itens_ideal,
							perc_est_ideal,
							now());

		  end if;
		     
    return '1';

end;

$function$

