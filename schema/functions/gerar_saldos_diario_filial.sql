CREATE OR REPLACE FUNCTION public.gerar_saldos_diario_filial(dataini date, datafim date, mov numeric DEFAULT 0)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$

declare

  retorno  character varying;
  rec_data record;
  rec_prod record;
  saldo_ent numeric;
  saldo_com numeric;
  saldo_est numeric;
  existe numeric;
  saida varchar;
  arv varchar;
  v_esseg numeric;
  v_ppd numeric;
  v_emax numeric;
  v_saldo_estoque numeric;
  v_cmm numeric;
  v_cmm_std numeric;
  v_fes numeric;
  v_nivel_servico varchar;
  v_sugestao numeric;

begin

  -- MOV = 0 Todos os Produtos;
  -- MOV = 1 Somente Produtos que movimentario no dia;	
	
  if mov = 0 then 
  
      for rec_prod in (select filial,idproduto,tempo_ressuprimento,desvio_padrao_ressuprimento,data_cadastro,
                              estoque_seguranca as esseg,ponto_pedido as ppd,estoque_maximo as emax,estoque saldo_estoque,
                              consumo_medio_mensal as cmm,desvio_padrao_consumo cmm_std,fes,nivel_servico,lote_compras 
                        from produtos_filial pf order by idproduto,filial)

		  loop
		
		
		
		    for rec_data in (SELECT to_char(day :: date, 'DD/MM/YYYY') as data
		
		                     FROM generate_series(dataini, datafim, '1 day') day)
		
		    loop
		
		        select
					coalesce(arvore_decisao, 'CX2R')
				into
					arv
				from
					prismas_filiais pf
				where
					filial = rec_prod.filial
					and idproduto = rec_prod.idproduto
					and data_ref = date_trunc('month', rec_data.data::date);
		    
		        if rec_data.data::date <> current_date then
		        
		             select
						estoque_seguranca,
						ponto_pedido,
						estoque_maximo,
						estoque,
						consumo_medio,
						std_consumo_medio,
						fes,
						nivel_servico,
						sugestao
						into 
					    v_esseg, 
					    v_ppd,
					    v_emax,
					    v_saldo_estoque,
					    v_cmm,
					    v_cmm_std,
					    v_fes,
					    v_nivel_servico,
					    v_sugestao
					from
						get_calculo_parametros_estoque(rec_prod.filial,rec_prod.idproduto,arv,rec_data.data::date);
				 
				 else 
				 
				  v_esseg = rec_prod.esseg;
				  v_ppd = rec_prod.ppd;
				  v_emax = rec_prod.emax;
				  v_saldo_estoque = rec_prod.saldo_estoque;
				  v_cmm = rec_prod.cmm;
				  v_cmm_std = rec_prod.cmm_std;
				  v_fes = rec_prod.fes;
				  v_nivel_servico = rec_prod.nivel_servico;
				  v_sugestao = rec_prod.lote_compras;
		
		        end if;
		
		    
		        --Saldos Diarios 
		    
		        saldo_com =(select get_consumo_diario_filial(rec_prod.filial,rec_prod.idproduto,rec_data.data::date));
		
		        saldo_ent =(select get_entradas_filial(rec_prod.filial,rec_prod.idproduto,rec_data.data::date));
		
		        saldo_est =(select get_estoque_diario_filial(rec_prod.filial,rec_prod.idproduto,rec_data.data::date));
		       
		       
		
		
		        if saldo_est < 0 then saldo_est = 0; end if;
		       
				update
					saldo_filiais
				set
					entradas = saldo_ent,
					saidas = saldo_com,
					estoque = saldo_est,
					processamento = current_timestamp,
					arvore_decisao = arv,
					esseg = v_esseg,
					ppd = v_ppd,
					emax = v_emax,
					saldo_estoque = v_saldo_estoque,
					cmm = v_cmm,
					cmm_std = v_cmm_std,
					fes = v_fes,
					nivel_servico = v_nivel_servico,
					sugestao_compras = v_sugestao
				where
					filial = rec_prod.filial
					and idproduto = rec_prod.idproduto
					and data = rec_data.data::date;
       
		        IF NOT FOUND THEN
		           
		        
		          insert into saldo_filiais(
		                filial,
						idproduto,
						data,
						ano,
						mes,
						trimestre,
						cod_trimestre,
						entradas,
						saidas,
						estoque,
						processamento,
						tempo_ressuprimento,
						desvio_padrao_ressuprimento,
						arvore_decisao,
						esseg,
					    ppd,
					    emax,
					    saldo_estoque,
					    cmm,
					    cmm_std,
					    fes,
					    nivel_servico,
					    sugestao_compras
						)
				values (rec_prod.filial,
						rec_prod.idproduto,
						rec_data.data::date,
						date_part('year', rec_data.data::date),
						date_part('month', rec_data.data::date),
						date_part('quarter', rec_data.data::date),
						to_char(rec_data.data::date, 'YYYYQ')::numeric,
						saldo_ent,
						saldo_com,
						saldo_est,
						current_timestamp,
						rec_prod.tempo_ressuprimento,
						rec_prod.desvio_padrao_ressuprimento,
						arv,
					    v_esseg,
						v_ppd,
						v_emax,
						v_saldo_estoque,
						v_cmm,
						v_cmm_std,
						v_fes,
						v_nivel_servico,
						v_sugestao
						);
		        END IF;
	
		
		    end loop;
		
		
		
		  end loop;
  
  
   else
   
        for rec_prod in (select filial,idproduto,tempo_ressuprimento,desvio_padrao_ressuprimento,data_cadastro,
                              estoque_seguranca as esseg,ponto_pedido as ppd,estoque_maximo as emax,estoque saldo_estoque,
                              consumo_medio_mensal as cmm,desvio_padrao_consumo cmm_std,fes,nivel_servico,lote_compras   from produtos_filial pf 
							where (pf.filial ,pf.idproduto) in (
							select distinct filial ,idproduto from consumos c where emissao between dataini and datafim
							union 
							select distinct idfilial ,idproduto from entrada_mercadorias em  where data_entrada  between dataini and datafim
							)
							order by idproduto,filial)

		  loop
		
		
		
		    for rec_data in (SELECT to_char(day :: date, 'DD/MM/YYYY') as data
		
		                     FROM generate_series(dataini, datafim, '1 day') day)
		
		    loop
		    		
		    
		        select
				coalesce(arvore_decisao, 'CX2R')
				into
					arv
				from
					prismas_filiais pf
				where
					filial = rec_prod.filial
					and idproduto = rec_prod.idproduto
					and data_ref = date_trunc('month', rec_data.data::date);
		       
		         if rec_data.data::date <> current_date then
		        
		            select
						estoque_seguranca,
						ponto_pedido,
						estoque_maximo,
						estoque,
						consumo_medio,
						std_consumo_medio,
						fes,
						nivel_servico,
						sugestao
						into 
					    v_esseg, 
					    v_ppd,
					    v_emax,
					    v_saldo_estoque,
					    v_cmm,
					    v_cmm_std,
					    v_fes,
					    v_nivel_servico,
					    v_sugestao
					from
						get_calculo_parametros_estoque(rec_prod.filial,rec_prod.idproduto,arv,rec_data.data::date);
				 
				 else 
				 
				  v_esseg = rec_prod.esseg;
				  v_ppd = rec_prod.ppd;
				  v_emax = rec_prod.emax;
				  v_saldo_estoque = rec_prod.saldo_estoque;
				  v_cmm = rec_prod.cmm;
				  v_cmm_std = rec_prod.cmm_std;
				  v_fes = rec_prod.fes;
				  v_nivel_servico = rec_prod.nivel_servico;
				  v_sugestao = rec_prod.lote_compras; 
		
		        end if;
		
		    
		       --Saldos Diarios
		    
		        saldo_com =(select get_consumo_diario_filial(rec_prod.filial,rec_prod.idproduto,rec_data.data::date));
		
		        saldo_ent =(select get_entradas_filial(rec_prod.filial,rec_prod.idproduto,rec_data.data::date));
		
		        saldo_est =(select get_estoque_diario_filial(rec_prod.filial,rec_prod.idproduto,rec_data.data::date));
		       
		        select coalesce(arvore_decisao,'CX2R') into arv from prismas_filiais pf  where filial=rec_prod.filial and idproduto =rec_prod.idproduto and data_ref = date_trunc('month',rec_data.data::date);
		
		
		        if saldo_est < 0 then saldo_est = 0; end if;
		       
		        update
					saldo_filiais
				set
					entradas = saldo_ent,
					saidas = saldo_com,
					estoque = saldo_est,
					processamento = current_timestamp,
					arvore_decisao = arv,
					esseg = v_esseg,
					ppd = v_ppd,
					emax = v_emax,
					saldo_estoque = v_saldo_estoque,
					cmm = v_cmm,
					cmm_std = v_cmm_std,
					fes = v_fes,
					nivel_servico = v_nivel_servico,
					sugestao_compras = v_sugestao
				where
					filial = rec_prod.filial
					and idproduto = rec_prod.idproduto
					and data = rec_data.data::date;
				
				
		        IF NOT FOUND THEN
		           
		          		        
		          insert into saldo_filiais(
		                filial,
						idproduto,
						data,
						ano,
						mes,
						trimestre,
						cod_trimestre,
						entradas,
						saidas,
						estoque,
						processamento,
						tempo_ressuprimento,
						desvio_padrao_ressuprimento,
						arvore_decisao,
						esseg,
					    ppd,
					    emax,
					    saldo_estoque,
					    cmm,
					    cmm_std,
					    fes,
					    nivel_servico,
					    sugestao_compras
						)
				values (rec_prod.filial,
						rec_prod.idproduto,
						rec_data.data::date,
						date_part('year', rec_data.data::date),
						date_part('month', rec_data.data::date),
						date_part('quarter', rec_data.data::date),
						to_char(rec_data.data::date, 'YYYYQ')::numeric,
						saldo_ent,
						saldo_com,
						saldo_est,
						current_timestamp,
						rec_prod.tempo_ressuprimento,
						rec_prod.desvio_padrao_ressuprimento,
						arv,
					    v_esseg,
						v_ppd,
						v_emax,
						v_saldo_estoque,
						v_cmm,
						v_cmm_std,
						v_fes,
						v_nivel_servico,
						v_sugestao
						);
		           
		        END IF;
		
		     
		
		    end loop;
		
		
		
		 end loop;
   
   
  end if; 
	
 
 return '1';



end;



$function$

