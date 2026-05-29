CREATE OR REPLACE FUNCTION public.processar_forecast(p_fornecedor bigint DEFAULT 0)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
declare
rec_forecast record;
    
begin
	
if p_fornecedor = 0 then 

update produtos_forecast set flag ='D' where id_grupo in (select id from grupo_compras);

for rec_forecast in(
  SELECT a.id_grupo,
    a.idfornecedor,
    a.fornecedor,
    a.idcomprador,
    a.comprador,
    a.idproduto,
    a.descricao_produto,
    a.iddepartamento,
    a.departamento,
    a.ponto_pedido::double precision * a.fator_conversao::double precision AS ponto_pedido,
    a.estoque_futuro::double precision * a.fator_conversao::double precision AS estoque_futuro,
    a.estoque_maximo::double precision * a.fator_conversao::double precision AS estoque_maximo,
    a.estoque::double precision * a.fator_conversao::double precision AS estoque,
    a.tempo_ressuprimento,
    a.desvio_padrao_ressuprimento,
    a.consumo_medio_mensal::double precision * a.fator_conversao::double precision AS consumo_medio_mensal,
    gerar_lote_embalagem(LEAST(a.lote_compras, a.estoque_maximo) * a.fator_conversao::numeric, a.lote_minimo * a.fator_conversao::numeric) AS lote_compras,
    a.lote_compras * a.fator_conversao::numeric AS lote_compras_bruto,
    a.fator_conversao,
    a.unidade_compra,
    a.lote_minimo,
    a.nivel_servico,
    a.peso_compras
   FROM ( SELECT previsao.idfornecedor,
            previsao.fornecedor,
            previsao.idcomprador,
            previsao.comprador,
            previsao.idproduto,
            previsao.descricao_produto,
            previsao.ponto_pedido,
            previsao.estoque_futuro,
            previsao.estoque_maximo,
            previsao.estoque,
            previsao.tempo_ressuprimento,
            previsao.desvio_padrao_ressuprimento,
            previsao.consumo_medio_mensal,
            round((previsao.estoque_maximo::double precision + (previsao.consumo_medio_mensal * (previsao.tempo_ressuprimento + previsao.desvio_padrao_ressuprimento))::double precision - previsao.estoque::double precision)::numeric, 2) AS lote_compras,
            previsao.fator_conversao,
            previsao.unidade_compra,
            previsao.lote_minimo,
            previsao.id_grupo,
            previsao.iddepartamento,
            previsao.descricao_departamento AS departamento,
            previsao.nivel_servico,
            previsao.peso_compras
           FROM ( SELECT p.id_grupo,
                    p.idfornecedor,
                    f.razao_social AS fornecedor,
                    p.idcomprador,
                    c.nome_completo AS comprador,
                    p.idproduto,
                    p.descricao_produto,
                    dep.iddepartamento,
                    dep.descricao_departamento,
                    p.ponto_pedido,
					get_forecast_grupo(
						p.id_grupo::numeric, 
						p.idproduto, 
						coalesce(
							nullif((SELECT pfi.tempo_forecast FROM produtos_forecast_itens pfi WHERE pfi.idproduto = p.idproduto), 0), 
							(SELECT f_1.tempo_forecast FROM fornecedor f_1 WHERE f_1.id = p.idfornecedor)
						)::NUMERIC
					) AS estoque_futuro,
                    p.estoque_maximo,
                    p.estoque,
                    p.tempo_ressuprimento,
                    p.desvio_padrao_ressuprimento,
                    p.consumo_medio_mensal,
                    p.unidade_compra,
                    p.lote_minimo,
                    1 AS fator_conversao,
                    get_arvore_decisao_grupo(p.id_grupo::numeric, p.idproduto)::text AS arvore_decisao,
                    getnivelservico(get_arvore_decisao_grupo(p.id_grupo::numeric, p.idproduto)) AS nivel_servico,
                    getpesocompras(get_arvore_decisao_grupo(p.id_grupo::numeric, p.idproduto), "substring"(get_arvore_decisao_grupo(p.id_grupo::numeric, p.idproduto)::text, 3, 1)::numeric) AS peso_compras
                   FROM produtos_compras_grupo p
                     JOIN fornecedor f ON f.id = p.idfornecedor
                     JOIN comprador c ON c.id = p.idcomprador
                     JOIN departamentos dep ON dep.iddepartamento = p.idfamilia_produto
                  WHERE p.lote_compras = 0::numeric AND p.consumo_medio_mensal > 0::numeric AND p.compra_transito = 0::numeric AND p.revenda::text = 'S'::text AND p.status::text <> 'FL'::text) previsao
          WHERE previsao.estoque_futuro::double precision <= previsao.ponto_pedido::double precision) a
  WHERE gerar_lote_embalagem(a.lote_compras * a.fator_conversao::numeric, a.lote_minimo) > 0::numeric)
  loop 
  
  
    --Update 
    
	  update
		produtos_forecast
	set
		idfornecedor = rec_forecast.idfornecedor,
		fornecedor = rec_forecast.fornecedor,
		idcomprador = rec_forecast.idcomprador,
		comprador = rec_forecast.comprador,
		descricao_produto = rec_forecast.descricao_produto,
		iddepartamento = rec_forecast.iddepartamento,
		departamento = rec_forecast.departamento,
		ponto_pedido = rec_forecast.ponto_pedido,
		estoque_futuro = rec_forecast.estoque_futuro,
		estoque_maximo = rec_forecast.estoque_maximo,
		estoque = rec_forecast.estoque,
		tempo_ressuprimento = rec_forecast.tempo_ressuprimento,
		desvio_padrao_ressuprimento = rec_forecast.desvio_padrao_ressuprimento,
		consumo_medio_mensal = rec_forecast.consumo_medio_mensal,
		lote_compras = rec_forecast.lote_compras,
		lote_compras_bruto = rec_forecast.lote_compras_bruto,
		fator_conversao = rec_forecast.fator_conversao,
		unidade_compra = rec_forecast.unidade_compra,
		lote_minimo = rec_forecast.lote_minimo,
		nivel_servico = rec_forecast.nivel_servico,
		peso_compras = rec_forecast.peso_compras,
		flag = null,
		processamento = current_timestamp 
	where
		id_grupo = rec_forecast.id_grupo
		and idproduto = rec_forecast.idproduto;
	
	if not found then 
	
	  --Insert 
    
		 insert
			into
			produtos_forecast (
			id_grupo,
			idfornecedor,
			fornecedor,
			idcomprador,
			comprador,
			idproduto,
			descricao_produto,
			iddepartamento,
			departamento,
			ponto_pedido,
			estoque_futuro,
			estoque_maximo,
			estoque,
			tempo_ressuprimento,
			desvio_padrao_ressuprimento,
			consumo_medio_mensal,
			lote_compras,
			lote_compras_bruto,
			fator_conversao,
			unidade_compra,
			lote_minimo,
			nivel_servico,
			peso_compras,
			flag,
			processamento)
		values(
			rec_forecast.id_grupo,
			rec_forecast.idfornecedor,
			rec_forecast.fornecedor,
			rec_forecast.idcomprador,
			rec_forecast.comprador,
			rec_forecast.idproduto,
			rec_forecast.descricao_produto,
			rec_forecast.iddepartamento,
			rec_forecast.departamento,
			rec_forecast.ponto_pedido,
			rec_forecast.estoque_futuro,
			rec_forecast.estoque_maximo,
			rec_forecast.estoque,
			rec_forecast.tempo_ressuprimento,
			rec_forecast.desvio_padrao_ressuprimento,
			rec_forecast.consumo_medio_mensal,
			rec_forecast.lote_compras,
			rec_forecast.lote_compras_bruto,
			rec_forecast.fator_conversao,
			rec_forecast.unidade_compra,
			rec_forecast.lote_minimo,
			rec_forecast.nivel_servico,
			rec_forecast.peso_compras,
			null,
			current_timestamp
			);
		
       end if;		
		
	 end loop;	
		
	else
	
	 update produtos_forecast set flag ='D' where id_grupo in (select id from grupo_compras) and produtos_forecast.idfornecedor = p_fornecedor;

		for rec_forecast in(
		  SELECT a.id_grupo,
		    a.idfornecedor,
		    a.fornecedor,
		    a.idcomprador,
		    a.comprador,
		    a.idproduto,
		    a.descricao_produto,
		    a.iddepartamento,
		    a.departamento,
		    a.ponto_pedido::double precision * a.fator_conversao::double precision AS ponto_pedido,
		    a.estoque_futuro::double precision * a.fator_conversao::double precision AS estoque_futuro,
		    a.estoque_maximo::double precision * a.fator_conversao::double precision AS estoque_maximo,
		    a.estoque::double precision * a.fator_conversao::double precision AS estoque,
		    a.tempo_ressuprimento,
		    a.desvio_padrao_ressuprimento,
		    a.consumo_medio_mensal::double precision * a.fator_conversao::double precision AS consumo_medio_mensal,
		    gerar_lote_embalagem(a.lote_compras * a.fator_conversao::numeric, a.lote_minimo * a.fator_conversao::numeric) AS lote_compras,
		    a.lote_compras * a.fator_conversao::numeric AS lote_compras_bruto,
		    a.fator_conversao,
		    a.unidade_compra,
		    a.lote_minimo,
		    a.nivel_servico,
		    a.peso_compras
		   FROM ( SELECT previsao.idfornecedor,
		            previsao.fornecedor,
		            previsao.idcomprador,
		            previsao.comprador,
		            previsao.idproduto,
		            previsao.descricao_produto,
		            previsao.ponto_pedido,
		            previsao.estoque_futuro,
		            previsao.estoque_maximo,
		            previsao.estoque,
		            previsao.tempo_ressuprimento,
		            previsao.desvio_padrao_ressuprimento,
		            previsao.consumo_medio_mensal,
            		round((previsao.estoque_maximo::double precision + (previsao.consumo_medio_mensal * (previsao.tempo_ressuprimento + previsao.desvio_padrao_ressuprimento))::double precision - previsao.estoque::double precision)::numeric, 2) AS lote_compras,
		            previsao.fator_conversao,
		            previsao.unidade_compra,
		            previsao.lote_minimo,
		            previsao.id_grupo,
		            previsao.iddepartamento,
		            previsao.descricao_departamento AS departamento,
		            previsao.nivel_servico,
		            previsao.peso_compras
		           FROM ( SELECT p.id_grupo,
		                    p.idfornecedor,
		                    f.razao_social AS fornecedor,
		                    p.idcomprador,
		                    c.nome_completo AS comprador,
		                    p.idproduto,
		                    p.descricao_produto,
		                    dep.iddepartamento,
		                    dep.descricao_departamento,
		                    p.ponto_pedido,
		                    get_forecast_grupo(p.id_grupo::numeric, p.idproduto, (( SELECT f_1.tempo_forecast
		                           FROM fornecedor f_1
		                          WHERE f_1.id = p.idfornecedor))::numeric) AS estoque_futuro,
		                    p.estoque_maximo,
		                    p.estoque,
		                    p.tempo_ressuprimento,
		                    p.desvio_padrao_ressuprimento,
		                    p.consumo_medio_mensal,
		                    p.unidade_compra,
		                    p.lote_minimo,
		                    1 AS fator_conversao,
		                    get_arvore_decisao_grupo(p.id_grupo::numeric, p.idproduto)::text AS arvore_decisao,
		                    getnivelservico(get_arvore_decisao_grupo(p.id_grupo::numeric, p.idproduto)) AS nivel_servico,
		                    getpesocompras(get_arvore_decisao_grupo(p.id_grupo::numeric, p.idproduto), "substring"(get_arvore_decisao_grupo(p.id_grupo::numeric, p.idproduto)::text, 3, 1)::numeric) AS peso_compras
		                   FROM produtos_compras_grupo p
		                     JOIN fornecedor f ON f.id = p.idfornecedor
		                     JOIN comprador c ON c.id = p.idcomprador
		                     JOIN departamentos dep ON dep.iddepartamento = p.idfamilia_produto
		                  where p.idfornecedor = p_fornecedor and p.lote_compras = 0::numeric AND p.consumo_medio_mensal > 0::numeric AND p.compra_transito = 0::numeric AND p.revenda::text = 'S'::text AND p.status::text <> 'FL'::text) previsao
		          WHERE previsao.estoque_futuro::double precision <= previsao.ponto_pedido::double precision) a
		  WHERE gerar_lote_embalagem(a.lote_compras * a.fator_conversao::numeric, a.lote_minimo) > 0::numeric)
		  loop 
		  
		  
		    --Update 
		    
			  update
				produtos_forecast
			   set
				idfornecedor = rec_forecast.idfornecedor,
				fornecedor = rec_forecast.fornecedor,
				idcomprador = rec_forecast.idcomprador,
				comprador = rec_forecast.comprador,
				descricao_produto = rec_forecast.descricao_produto,
				iddepartamento = rec_forecast.iddepartamento,
				departamento = rec_forecast.departamento,
				ponto_pedido = rec_forecast.ponto_pedido,
				estoque_futuro = rec_forecast.estoque_futuro,
				estoque_maximo = rec_forecast.estoque_maximo,
				estoque = rec_forecast.estoque,
				tempo_ressuprimento = rec_forecast.tempo_ressuprimento,
				desvio_padrao_ressuprimento = rec_forecast.desvio_padrao_ressuprimento,
				consumo_medio_mensal = rec_forecast.consumo_medio_mensal,
				lote_compras = rec_forecast.lote_compras,
				lote_compras_bruto = rec_forecast.lote_compras_bruto,
				fator_conversao = rec_forecast.fator_conversao,
				unidade_compra = rec_forecast.unidade_compra,
				lote_minimo = rec_forecast.lote_minimo,
				nivel_servico = rec_forecast.nivel_servico,
				peso_compras = rec_forecast.peso_compras,
				flag = null,
				processamento = current_timestamp 
			where
				id_grupo = rec_forecast.id_grupo
				and idproduto = rec_forecast.idproduto;
			
			if not found then 
			
			  --Insert 
		    
				 insert
					into
					produtos_forecast (
					id_grupo,
					idfornecedor,
					fornecedor,
					idcomprador,
					comprador,
					idproduto,
					descricao_produto,
					iddepartamento,
					departamento,
					ponto_pedido,
					estoque_futuro,
					estoque_maximo,
					estoque,
					tempo_ressuprimento,
					desvio_padrao_ressuprimento,
					consumo_medio_mensal,
					lote_compras,
					lote_compras_bruto,
					fator_conversao,
					unidade_compra,
					lote_minimo,
					nivel_servico,
					peso_compras,
					flag,
					processamento)
				values(
					rec_forecast.id_grupo,
					rec_forecast.idfornecedor,
					rec_forecast.fornecedor,
					rec_forecast.idcomprador,
					rec_forecast.comprador,
					rec_forecast.idproduto,
					rec_forecast.descricao_produto,
					rec_forecast.iddepartamento,
					rec_forecast.departamento,
					rec_forecast.ponto_pedido,
					rec_forecast.estoque_futuro,
					rec_forecast.estoque_maximo,
					rec_forecast.estoque,
					rec_forecast.tempo_ressuprimento,
					rec_forecast.desvio_padrao_ressuprimento,
					rec_forecast.consumo_medio_mensal,
					rec_forecast.lote_compras,
					rec_forecast.lote_compras_bruto,
					rec_forecast.fator_conversao,
					rec_forecast.unidade_compra,
					rec_forecast.lote_minimo,
					rec_forecast.nivel_servico,
					rec_forecast.peso_compras,
					null,
					current_timestamp
					);
			 
			end if;
		
	 end loop;
   
end if;
	     
delete from  produtos_forecast  where  flag ='D';

end
$function$

