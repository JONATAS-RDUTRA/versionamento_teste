CREATE OR REPLACE FUNCTION public.processar_produtos_compras_categorias(filtro_id_grupo integer DEFAULT 0, filtro_id_departamento character varying DEFAULT '0'::character varying, filtro_id_categoria character varying DEFAULT '0'::character varying)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
	rec_produto_grupo record;
    p_estoque_seguranca numeric(12,4);
	p_ponto_pedido numeric(12,4);
	p_estoque_maximo numeric(12,4);
	p_tempo_medio_ressuprimento numeric(12,4);
	p_tempo_ressuprimento numeric(12,4);
	p_desvio_padrao_ressuprimento numeric(12,4);
	p_compra_transito numeric(12,4);
	p_lote_compras_bruto numeric(12,4);
	p_lote_compras numeric(12,4);
    p_lote_minimo numeric(12,4);

BEGIN

	FOR rec_produto_grupo IN (
		select
			a.*,
			CASE
				WHEN a.coeficiente_variacao::numeric > 0::numeric AND a.coeficiente_variacao::numeric <= 200::numeric THEN 'REPETITIVO'::text
				WHEN a.coeficiente_variacao::numeric > 200::numeric AND a.coeficiente_variacao::numeric <= 600::numeric THEN 'ESTATISTICO'::text
				ELSE 'OCASIONAL'::text
			END AS perfil_demanda,
			0  as idcomprador,
		    35 as tempo_medio_ressuprimento,
			1.17 as tempo_ressuprimento,
			(
				SELECT r.pcompra
				FROM requisicoes r
					INNER JOIN grupo_filial gf ON gf.filial = r.idfilial
					INNER JOIN produtos_filial pf ON pf.filial = r.idfilial AND pf.idproduto = r.idproduto
				WHERE pf.idcategoria = a.idcategoria AND gf.id_grupo = a.id_grupo
				ORDER BY r.id_solicitacao DESC, r.data_solicitacao DESC
				LIMIT 1
			) AS ultimo_preco_compra
		from (
			WITH prismas AS (
				SELECT
					gf.id_grupo,
			   		pf.idcategoria,
			    	((min(pf.classificacao_financeira::text) || max(pf.classificacao_criticidade::text)) || min(pf.classificacao_comprabilidade)) || min(pf.classificacao_popularidade::text) AS arvore_decisao,
			    	 min(pf.classificacao_comprabilidade) as classificacao_comprabilidade
			   	FROM produtos_filial pf
			    	JOIN grupo_filial gf ON gf.filial = pf.filial
			  	GROUP BY gf.id_grupo, pf.idcategoria
			)
			select
				gf.id_grupo,
				pf.iddepartamento,
				pf.idsecao,
				pf.idcategoria,
				c.descricao_categoria,
				max(pf.idunidade_medida) AS idunidade_medida,
				sum(pf.estoque) as estoque,
				sum(pf.estoque_bloqueado) as estoque_bloqueado,
				sum(pf.estoque_avaria) as estoque_avaria,
				sum(pf.estoque_reservado) as estoque_reservado,
				sum(pf.estoque_similar) as estoque_similar,
				sum(pf.consumo_medio_mensal) as consumo_medio_mensal,
				sum(pf.desvio_padrao_consumo) as desvio_padrao_consumo,
				round(coalesce((sum(pf.estoque)/nullif(sum(pf.consumo_medio_mensal),0)),0),2) cobertura_estoque,
				round(coalesce((sum(pf.desvio_padrao_consumo * pf.fator_conversao)/nullif(sum(pf.consumo_medio_mensal * pf.fator_conversao),0)*100),0),2)::text AS coeficiente_variacao,
				round(avg(pf.tempo_medio_apanhe),2) as tempo_medio_apanhe,
				p.arvore_decisao,
				getNivelServico(p.arvore_decisao) as nivel_servico,
				getFes(p.arvore_decisao) as fes,
				getPesoCompras(p.arvore_decisao,coalesce(p.classificacao_comprabilidade,0)) as peso_compras,
				max(pf.unidade_compra) AS unidade_compra,
				max(pf.idunidade_medida) AS idunidade_medida,
				COALESCE(max(pcc.cobertura_manual_categoria), 0) AS cobertura_manual_categoria,
				avg(pf.custo_unitario) AS custo_unitario,
				avg(NULLIF(preco_compra, 0)) AS preco_medio_compra
			from categorias c
				inner join produtos_filial pf on pf.idcategoria = c.idcategoria::text
				inner join grupo_filial gf on gf.filial = pf.filial
				inner join prismas p on p.id_grupo = gf.id_grupo and p.idcategoria = pf.idcategoria
				LEFT JOIN produtos_compras_categorias pcc ON pcc.id_grupo = gf.id_grupo AND pcc.idcategoria = pf.idcategoria
			where pf.revenda='S' and pf.status<>'FL'
				and (gf.id_grupo  = filtro_id_grupo  or  filtro_id_grupo = 0)
				and (pf.iddepartamento = filtro_id_departamento or filtro_id_departamento = '0')
				and (pf.idcategoria = filtro_id_categoria or filtro_id_categoria = '0')
			group by gf.id_grupo,pf.iddepartamento,pf.idsecao,pf.idcategoria ,c.descricao_categoria,p.arvore_decisao,p.classificacao_comprabilidade
		) a
	)

	LOOP


		p_estoque_seguranca  = 0;
	    p_ponto_pedido  = 0;
		p_estoque_maximo  = 0;
		p_compra_transito  = 0;
		p_lote_compras_bruto  = 0;
		p_lote_compras  = 0;
		p_lote_minimo = 1;
		p_tempo_medio_ressuprimento  = 35;
		p_tempo_ressuprimento  = 1.17;
		p_desvio_padrao_ressuprimento  = 0;



	    select lote_minimo,tempo_medio_ressuprimento,tempo_ressuprimento,desvio_padrao_ressuprimento into
	    	p_lote_minimo,
		    p_tempo_medio_ressuprimento,
		    p_tempo_ressuprimento,
		    p_desvio_padrao_ressuprimento
		    from produtos_compras_categorias pcc
		    where id_grupo = rec_produto_grupo.id_grupo
			and idcategoria::text = rec_produto_grupo.idcategoria;


			p_lote_minimo = coalesce(p_lote_minimo,1);
		    p_tempo_medio_ressuprimento  = coalesce(p_tempo_medio_ressuprimento,35);
		    p_tempo_ressuprimento  = coalesce(p_tempo_ressuprimento,1.17);
		    p_desvio_padrao_ressuprimento  = coalesce(p_desvio_padrao_ressuprimento,0);






	    -- Estoque Segurança;


	      p_estoque_seguranca = ( round(cast( rec_produto_grupo.desvio_padrao_consumo * rec_produto_grupo.fes as numeric),2));


    	  if rec_produto_grupo.desvio_padrao_consumo = 0 then

       		p_estoque_seguranca = ( round(cast( rec_produto_grupo.consumo_medio_mensal * rec_produto_grupo.fes as numeric),2));

    	 end if;



   		 if rec_produto_grupo.perfil_demanda ='OCASIONAL' then

         	p_estoque_seguranca = ( round(cast((rec_produto_grupo.consumo_medio_mensal/2) * rec_produto_grupo.fes as numeric),2));

         end if;

	    -- Cobertura Manual
	    if (rec_produto_grupo.cobertura_manual_categoria > 0) then
	     	p_estoque_seguranca = ((rec_produto_grupo.consumo_medio_mensal/30)*rec_produto_grupo.cobertura_manual_categoria) * 0.30;
	    end if;

        -- Ponto de Pedido
        p_ponto_pedido = round(cast(p_estoque_seguranca + (rec_produto_grupo.consumo_medio_mensal * (p_tempo_ressuprimento+p_desvio_padrao_ressuprimento))as numeric),2) ;



        --  Estoque Máximo

        p_estoque_maximo = (p_ponto_pedido+rec_produto_grupo.consumo_medio_mensal);


	  	--Cobertura Manual
	    if rec_produto_grupo.cobertura_manual_categoria > 0 THEN

    		if  ((rec_produto_grupo.consumo_medio_mensal/30) * rec_produto_grupo.cobertura_manual_categoria) > p_ponto_pedido then
    	    	p_estoque_maximo = ((rec_produto_grupo.consumo_medio_mensal / 30) * rec_produto_grupo.cobertura_manual_categoria);
    	   	else
	    	   -- Cobertura Máxima atribuida ao item e inferior ao tempo de reposição do mesmo;
	    	   p_estoque_maximo = (p_ponto_pedido + rec_produto_grupo.consumo_medio_mensal);
	    	end if;

      	else
	       p_estoque_maximo = (p_ponto_pedido + rec_produto_grupo.consumo_medio_mensal);
		end if;


       -- Validação Perfil OCASIONAL
       	 if rec_produto_grupo.perfil_demanda ='OCASIONAL' THEN

         	p_ponto_pedido = round(cast(p_estoque_seguranca + ((rec_produto_grupo.consumo_medio_mensal/2) * (p_tempo_ressuprimento+p_desvio_padrao_ressuprimento)) as numeric),2);

   			if (rec_produto_grupo.cobertura_manual_categoria > 0) AND (((rec_produto_grupo.consumo_medio_mensal/30) * rec_produto_grupo.cobertura_manual_categoria) > p_ponto_pedido) THEN
	    	    p_estoque_maximo = (((rec_produto_grupo.consumo_medio_mensal/2) / 30) * rec_produto_grupo.cobertura_manual_categoria);
   			ELSE
	         	p_estoque_maximo = (p_ponto_pedido+(rec_produto_grupo.consumo_medio_mensal/2));
	         END IF;
         end if;



         -- Compra em Trânsito;


          select coalesce(sum(r.qtde_pendente),0) into p_compra_transito from requisicoes r
			inner join produtos_filial pf
			 on r.idfilial = pf.filial
			 and r.idproduto = pf.idproduto
			 where pf.idcategoria= rec_produto_grupo.idcategoria  and qtde_pendente > 0;


			p_compra_transito = coalesce(p_compra_transito,0);


        --Lote de Compras



		 if  p_compra_transito = 0 and  rec_produto_grupo.perfil_demanda ='OCASIONAL' and  rec_produto_grupo.estoque <  p_ponto_pedido then

		        p_lote_compras_bruto =  ((rec_produto_grupo.consumo_medio_mensal/2));
		        p_lote_compras= gerar_lote_embalagem(p_lote_compras_bruto,p_lote_minimo);


		 elseif  p_compra_transito = 0 and  rec_produto_grupo.perfil_demanda <> 'OCASIONAL' and  rec_produto_grupo.estoque <  p_ponto_pedido then


		       p_lote_compras_bruto = (round(cast((p_estoque_maximo+(rec_produto_grupo.consumo_medio_mensal*(p_tempo_ressuprimento+p_desvio_padrao_ressuprimento))-rec_produto_grupo.estoque) as numeric),2));
		       p_lote_compras= gerar_lote_embalagem(p_lote_compras_bruto,p_lote_minimo);
		 else

		       p_lote_compras_bruto = 0;
		       p_lote_compras  = 0;

		 end if;

		-- cobertura estoque menor que o tempo de ressuprimento: comprar emax
		if (p_lote_compras_bruto > 0 and rec_produto_grupo.cobertura_estoque < p_tempo_ressuprimento) then
		       p_lote_compras_bruto = p_estoque_maximo;
		       p_lote_compras  = gerar_lote_embalagem(p_lote_compras_bruto, p_lote_minimo);
		end if;



		update
			produtos_compras_categorias
		SET
			iddepartamento = rec_produto_grupo.iddepartamento,
			idsecao = rec_produto_grupo.idsecao,
			descricao_categoria = rec_produto_grupo.descricao_categoria,
			estoque = rec_produto_grupo.estoque,
			estoque_bloqueado = rec_produto_grupo.estoque_bloqueado,
			estoque_avaria = rec_produto_grupo.estoque_avaria,
			estoque_reservado = rec_produto_grupo.estoque_reservado,
			cobertura_estoque = rec_produto_grupo.cobertura_estoque,
			estoque_seguranca = p_estoque_seguranca,
			ponto_pedido = p_ponto_pedido,
			estoque_maximo = p_estoque_maximo,
			consumo_medio_mensal = rec_produto_grupo.consumo_medio_mensal,
			desvio_padrao_consumo = rec_produto_grupo.desvio_padrao_consumo,
			tempo_medio_ressuprimento = p_tempo_medio_ressuprimento,
			tempo_ressuprimento = p_tempo_ressuprimento,
			desvio_padrao_ressuprimento = 0,
			coeficiente_variacao = rec_produto_grupo.coeficiente_variacao,
			compra_transito = p_compra_transito,
			arvore_decisao = rec_produto_grupo.arvore_decisao,
			nivel_servico = rec_produto_grupo.nivel_servico,
			peso_compras = rec_produto_grupo.peso_compras,
			lote_compras_bruto = p_lote_compras_bruto ,
			lote_compras = p_lote_compras,
			perfil_demanda = rec_produto_grupo.perfil_demanda,
			tempo_medio_apanhe = rec_produto_grupo.tempo_medio_apanhe,
			unidade_compra = rec_produto_grupo.unidade_compra,
			idunidade_medida = rec_produto_grupo.idunidade_medida,
			custo_unitario = rec_produto_grupo.custo_unitario,
			preco_medio_compra = rec_produto_grupo.preco_medio_compra,
			ultimo_preco_compra = rec_produto_grupo.ultimo_preco_compra,
			processamento = current_timestamp
		where
			id_grupo = rec_produto_grupo.id_grupo
			and idcategoria::text = rec_produto_grupo.idcategoria;

		IF NOT FOUND then

		      insert
					into
					produtos_compras_categorias (
					id_grupo,
					iddepartamento,
					idsecao,
					idcategoria,
					descricao_categoria,
					idcomprador,
					estoque,
					estoque_bloqueado,
					estoque_avaria,
					estoque_reservado,
					cobertura_estoque,
					estoque_seguranca,
					ponto_pedido,
					estoque_maximo,
					consumo_medio_mensal,
					desvio_padrao_consumo,
					tempo_medio_ressuprimento,
					tempo_ressuprimento,
					desvio_padrao_ressuprimento,
					coeficiente_variacao,
					compra_transito,
					arvore_decisao,
					nivel_servico,
					peso_compras,
					lote_minimo,
					lote_compras_bruto,
					lote_compras,
					perfil_demanda,
					tempo_medio_apanhe,
					unidade_compra,
					idunidade_medida,
					custo_unitario,
					preco_medio_compra,
					ultimo_preco_compra,
					processamento)
				values( rec_produto_grupo.id_grupo,
						rec_produto_grupo.iddepartamento,
						rec_produto_grupo.idsecao,
						rec_produto_grupo.idcategoria::int8,
						rec_produto_grupo.descricao_categoria,
						rec_produto_grupo.idcomprador,
						rec_produto_grupo.estoque,
						rec_produto_grupo.estoque_bloqueado,
						rec_produto_grupo.estoque_avaria,
						rec_produto_grupo.estoque_reservado,
						rec_produto_grupo.cobertura_estoque,
						p_estoque_seguranca,
						p_ponto_pedido,
						p_estoque_maximo,
						rec_produto_grupo.consumo_medio_mensal,
						rec_produto_grupo.desvio_padrao_consumo,
						p_tempo_medio_ressuprimento,
						p_tempo_ressuprimento,
						p_desvio_padrao_ressuprimento,
						rec_produto_grupo.coeficiente_variacao,
						p_compra_transito,
						rec_produto_grupo.arvore_decisao,
						rec_produto_grupo.nivel_servico,
						rec_produto_grupo.peso_compras,
						p_lote_minimo,
						p_lote_compras_bruto,
						p_lote_compras,
						rec_produto_grupo.perfil_demanda,
						rec_produto_grupo.tempo_medio_apanhe,
						rec_produto_grupo.unidade_compra,
						rec_produto_grupo.idunidade_medida,
						rec_produto_grupo.custo_unitario,
						rec_produto_grupo.preco_medio_compra,
						rec_produto_grupo.ultimo_preco_compra,
						current_timestamp);
		END IF;
	END LOOP;
END;
$function$

