CREATE OR REPLACE FUNCTION public.processar_produtos_compras_filial(filtro_filial integer DEFAULT 0, filtro_id_fornecedor bigint DEFAULT 0)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE 
	rec_produto_filial record;
BEGIN 
    
    update produtos_compras_filial 
    set flag='D' 
    where 
        (produtos_compras_filial.filial = filtro_filial OR filtro_filial = 0)
        AND (produtos_compras_filial.idfornecedor  = filtro_id_fornecedor OR filtro_id_fornecedor = 0);
    
	FOR rec_produto_filial IN (
		SELECT 
			lote.id_grupo,
			lote.filial,
			lote.idproduto,
			lote.descricao_produto,
			lote.idcomprador,
			lote.idfornecedor,
			lote.idfamilia_produto,
			lote.revenda,
			lote.status,
			lote.estoque,
			lote.cobertura_estoque,
			lote.estoque_seguranca,
			lote.ponto_pedido,
			lote.estoque_maximo,
			lote.consumo_medio_mensal,
			lote.desvio_padrao_consumo,
			lote.tempo_medio_ressuprimento,
			lote.tempo_ressuprimento,
			lote.desvio_padrao_ressuprimento,
			lote.coeficiente_variacao,
			lote.compra_transito,
			lote.lote_minimo,
			lote.lote_compras_bruto,
			lote.arvore_decisao,
			lote.nivel_servico,
			lote.peso_compras,
			lote.unidade_compra,
			lote.lote_embalagem,
			CASE
				WHEN lote.lote_compras_bruto > 0::numeric AND lote.lote_embalagem = 0::numeric THEN 1
				ELSE 0
			END AS sob_encomenda,
			--lote.lote_embalagem AS lote_compras,
			CASE
			    WHEN lote.lote_embalagem > 0::numeric AND COALESCE(round(lote.estoque / NULLIF(lote.consumo_medio_mensal, 0::numeric), 4), 0::numeric) < lote.tempo_ressuprimento AND lote.compra_transito = 0::numeric THEN gerar_lote_embalagem(lote.estoque_maximo, COALESCE(lote.lote_minimo, 1::numeric))
			    ELSE lote.lote_embalagem
			END AS lote_compras,
			lote.preco_compra,
			lote.custo_unitario,
			lote.valor_unitario,
			lote.estoque_bloqueado,
			CASE
				WHEN lote.coeficiente_variacao::numeric >= 0::numeric AND lote.coeficiente_variacao::numeric <= 200::numeric THEN 'REPETITIVO'::text
				WHEN lote.coeficiente_variacao::numeric > 200::numeric AND lote.coeficiente_variacao::numeric <= 600::numeric THEN 'ESTATISTICO'::text
				ELSE 'OCASIONAL'::text
			END AS perfil_demanda,
			lote.tempo_medio_apanhe,
			lote.embalagem,
			lote.idunidade_medida,
			lote.ressuprimento_manual,
			lote.ressuprimento_manual_dias,
			lote.cod_produto,
			lote.codigo_barras,
			lote.fator_atuacao,
			lote.estoque_avaria,
			lote.estoque_reservado,
			lote.multiplo_compra,
			lote.unidade_master,
			lote.tipo_fator_conversao,
			lote.compra_transito_entregue,
            lote.estoque_minimo,
            lote.classificacao_rentabilidade,
            lote.estoque_seguranca_estetico,
            lote.ponto_pedido_estetico,
            (lote.ponto_pedido_estetico + lote.consumo_medio_mensal) AS estoque_maximo_estetico,
			lote.estoque_pendente,
			lote.idsecao,
			lote.idcategoria
		FROM (
			SELECT 
				a.id_grupo,
				a.filial,
				a.idproduto,
				a.descricao_produto,
				a.idcomprador,
				a.idfornecedor,
				a.idfamilia_produto,
				a.revenda,
				a.status,
				a.estoque,
				a.cobertura_estoque,
				a.estoque_seguranca,
				a.ponto_pedido,
				a.estoque_maximo,
				a.consumo_medio_mensal,
				a.desvio_padrao_consumo,
				a.tempo_medio_ressuprimento,
				a.tempo_ressuprimento,
				a.desvio_padrao_ressuprimento,
				a.coeficiente_variacao,
				a.compra_transito,
				a.lote_minimo,
				CASE
					WHEN a.coeficiente_variacao::numeric >= 0::numeric AND a.compra_transito = 0::numeric AND a.estoque <= a.ponto_pedido AND a.revenda::text = 'S'::text AND a.status::text <> 'FL'::text THEN round(a.estoque_maximo + a.consumo_medio_mensal * (a.tempo_ressuprimento + a.desvio_padrao_ressuprimento) - a.estoque, 2)
					WHEN a.coeficiente_variacao::numeric = 0::numeric AND a.compra_transito = 0::numeric AND a.estoque <= a.ponto_pedido AND a.revenda::text = 'S'::text AND a.status::text <> 'FL'::text THEN ceil(a.consumo_medio_mensal / 2::numeric)
					ELSE 0::numeric
				END AS lote_compras_bruto,
				a.arvore_decisao,
				a.nivel_servico,
				a.peso_compras,
				a.unidade_compra,
				gerar_lote_embalagem(
					CASE
						WHEN a.coeficiente_variacao::numeric >= 0::numeric AND a.compra_transito = 0::numeric AND a.estoque <= a.ponto_pedido AND a.revenda::text = 'S'::text AND a.status::text <> 'FL'::text THEN round(a.estoque_maximo + a.consumo_medio_mensal * (a.tempo_ressuprimento + a.desvio_padrao_ressuprimento) - a.estoque, 2)
						WHEN a.coeficiente_variacao::numeric = 0::numeric AND a.compra_transito = 0::numeric AND a.estoque <= a.ponto_pedido AND a.revenda::text = 'S'::text AND a.status::text <> 'FL'::text THEN ceil(a.consumo_medio_mensal / 2::numeric)
						ELSE 0::numeric
					END, 
					COALESCE(a.lote_minimo, 1::numeric)
				) AS lote_embalagem,
				a.preco_compra,
				a.custo_unitario,
				a.valor_unitario,
				a.estoque_bloqueado,
				a.tempo_medio_apanhe,
				a.embalagem,
				a.idunidade_medida,
				a.ressuprimento_manual,
				a.ressuprimento_manual_dias,
				a.cod_produto,
				a.codigo_barras,
				a.fator_atuacao,
				a.estoque_avaria,
				a.estoque_reservado,
				a.multiplo_compra,
				a.unidade_master,
				a.tipo_fator_conversao,
				a.compra_transito_entregue,
				a.estoque_minimo,
				a.classificacao_rentabilidade,
                a.estoque_seguranca_estetico,
                (a.estoque_seguranca_estetico + ((a.consumo_medio_mensal / 30) * a.tempo_medio_ressuprimento)) AS ponto_pedido_estetico,
				a.estoque_pendente,
				a.idsecao,
				a.idcategoria
			FROM (
			    WITH compras_pendentes_com_entrega AS (
                    SELECT 
                        gf.id_grupo,
                        r.idfilial AS filial,
                        r.idproduto,
                        sum(r.qtde_entregue) AS compra_transito_entregue
                    FROM requisicoes r 
                        INNER JOIN grupo_filial gf ON gf.filial = r.idfilial 
                    WHERE 
                        r.qtde_pendente > 0
                        AND r.qtde_entregue > 0
                    GROUP BY 
                        r.idfilial,
                        gf.id_grupo,
                        r.idproduto 
                )
				SELECT 
					p.filial,
					g.id_grupo,
					p.idproduto,
					p.descricao_produto,
					p.idcomprador,
					p.idfornecedor,
					p.idfamilia_produto,
					p.revenda,
					p.status,
					p.unidade_compra,
					p.estoque * p.fator_conversao AS estoque,
					NULLIF(p.cobertura_estoque, 0::numeric) AS cobertura_estoque,
					p.estoque_seguranca * p.fator_conversao AS estoque_seguranca,
					p.ponto_pedido * p.fator_conversao AS ponto_pedido,
					p.estoque_maximo * p.fator_conversao AS estoque_maximo,
					p.consumo_medio_mensal * p.fator_conversao AS consumo_medio_mensal,
					p.desvio_padrao_consumo * p.fator_conversao AS desvio_padrao_consumo,
					p.tempo_medio_ressuprimento,
					p.tempo_ressuprimento,
					p.desvio_padrao_ressuprimento,
					p.coeficiente_variacao::text AS coeficiente_variacao,
					getcompra_transito_filial(p.filial::numeric, p.idproduto) AS compra_transito,
					p.lote_minimo * p.fator_conversao AS lote_minimo,
					p.arvore_decisao,
					p.nivel_servico,
					p.peso_compras,
					p.preco_compra,
					p.custo_unitario,
					p.valor_unitario,
					p.estoque_bloqueado * p.fator_conversao AS estoque_bloqueado,
					p.tempo_medio_apanhe,
					p.embalagem,
					p.idunidade_medida,
					p.ressuprimento_manual,
					COALESCE(p.ressuprimento_manual_dias, 0::numeric) AS ressuprimento_manual_dias,
					p.cod_produto,
					p.codigo_barras,
					p.fator_atuacao,
					p.estoque_avaria,
					COALESCE(p.estoque_reservado) AS estoque_reservado,
					p.multiplo_compra,
					p.unidade_master,
					p.tipo_fator_conversao,
                    COALESCE(cpce.compra_transito_entregue, 0) AS compra_transito_entregue,
                    p.estoque_minimo,
                    p.classificacao_rentabilidade,
                    p.estoque_minimo AS estoque_seguranca_estetico,
					p.estoque_pendente,
					p.idsecao,
					p.idcategoria
				FROM produtos_filial p
					JOIN grupo_filial g ON p.filial = g.filial
                    LEFT JOIN compras_pendentes_com_entrega cpce ON cpce.id_grupo = g.id_grupo AND  cpce.filial = p.filial AND  cpce.idproduto = p.idproduto
				WHERE 
					p.processar_analise::text = 'S'::text 
					AND p.revenda::text = 'S'::text
					AND p.status::text <> 'FL'::text 
					AND p.processar_analise::text = 'S'::TEXT
		    		AND (g.filial = filtro_filial OR filtro_filial = 0)
		    		AND (p.idfornecedor = filtro_id_fornecedor OR filtro_id_fornecedor = 0)
				ORDER BY p.idproduto, g.id_grupo, p.filial
			) a
		) lote
	)
	LOOP 
		UPDATE
		  public.produtos_compras_filial
		SET
		  id_grupo = rec_produto_filial.id_grupo,
		  descricao_produto = rec_produto_filial.descricao_produto,
		  idcomprador = rec_produto_filial.idcomprador,
		  idfornecedor = rec_produto_filial.idfornecedor,
          idfamilia_produto = rec_produto_filial.idfamilia_produto,
          iddepartamento = rec_produto_filial.idfamilia_produto,
		  revenda = rec_produto_filial.revenda,
		  status = rec_produto_filial.status,
		  estoque = rec_produto_filial.estoque,
		  cobertura_estoque = rec_produto_filial.cobertura_estoque,
		  estoque_seguranca = rec_produto_filial.estoque_seguranca,
		  ponto_pedido = rec_produto_filial.ponto_pedido,
		  estoque_maximo = rec_produto_filial.estoque_maximo,
		  consumo_medio_mensal = rec_produto_filial.consumo_medio_mensal,
		  desvio_padrao_consumo = rec_produto_filial.desvio_padrao_consumo,
		  tempo_medio_ressuprimento = rec_produto_filial.tempo_medio_ressuprimento,
		  tempo_ressuprimento = rec_produto_filial.tempo_ressuprimento,
		  desvio_padrao_ressuprimento = rec_produto_filial.desvio_padrao_ressuprimento,
		  coeficiente_variacao = rec_produto_filial.coeficiente_variacao,
		  compra_transito = rec_produto_filial.compra_transito,
		  lote_minimo = rec_produto_filial.lote_minimo,
		  lote_compras_bruto = rec_produto_filial.lote_compras_bruto,
		  arvore_decisao = rec_produto_filial.arvore_decisao,
		  nivel_servico = rec_produto_filial.nivel_servico,
		  peso_compras = rec_produto_filial.peso_compras,
		  unidade_compra = rec_produto_filial.unidade_compra,
		  lote_embalagem = rec_produto_filial.lote_embalagem,
		  sob_encomenda = rec_produto_filial.sob_encomenda,
		  lote_compras = rec_produto_filial.lote_compras,
		  preco_compra = rec_produto_filial.preco_compra,
		  custo_unitario = rec_produto_filial.custo_unitario,
		  valor_unitario = rec_produto_filial.valor_unitario,
		  estoque_bloqueado = rec_produto_filial.estoque_bloqueado,
		  perfil_demanda = rec_produto_filial.perfil_demanda,
		  tempo_medio_apanhe = rec_produto_filial.tempo_medio_apanhe,
		  embalagem = rec_produto_filial.embalagem,
		  idunidade_medida = rec_produto_filial.idunidade_medida,
		  ressuprimento_manual = rec_produto_filial.ressuprimento_manual,
		  ressuprimento_manual_dias = rec_produto_filial.ressuprimento_manual_dias,
		  cod_produto = rec_produto_filial.cod_produto,
		  codigo_barras = rec_produto_filial.codigo_barras,
		  fator_atuacao = rec_produto_filial.fator_atuacao,
		  estoque_avaria = rec_produto_filial.estoque_avaria,
		  estoque_reservado = rec_produto_filial.estoque_reservado,
		  multiplo_compra = rec_produto_filial.multiplo_compra,
		  unidade_master = rec_produto_filial.unidade_master,
		  tipo_fator_conversao = rec_produto_filial.tipo_fator_conversao,
		  compra_transito_entregue = rec_produto_filial.compra_transito_entregue,
		  estoque_minimo = rec_produto_filial.estoque_minimo,
		  processamento = current_timestamp,
          flag=NULL,
          classificacao_rentabilidade = rec_produto_filial.classificacao_rentabilidade,
          estoque_seguranca_estetico = rec_produto_filial.estoque_seguranca_estetico,
          ponto_pedido_estetico = rec_produto_filial.ponto_pedido_estetico,
          estoque_maximo_estetico = rec_produto_filial.estoque_maximo_estetico,
		  estoque_pendente = rec_produto_filial.estoque_pendente,
          idsecao = rec_produto_filial.idsecao,
		  idcategoria = rec_produto_filial.idcategoria
		WHERE
		  id_grupo = rec_produto_filial.id_grupo
		  and filial = rec_produto_filial.filial
		  AND idproduto = rec_produto_filial.idproduto;

		IF NOT FOUND THEN
			INSERT INTO public.produtos_compras_filial(
			    id_grupo, 
			    filial, 
			    idproduto, 
			    descricao_produto, 
			    idcomprador, 
			    idfornecedor, 
			    idfamilia_produto,
			    iddepartamento,
			    revenda, 
			    status, 
			    estoque, 
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
			    lote_minimo,
			    lote_compras_bruto,
			    arvore_decisao, 
			    nivel_servico, 
			    peso_compras, 
			    unidade_compra, 
			    lote_embalagem, 
			    sob_encomenda, 
			    lote_compras, 
			    preco_compra, 
			    custo_unitario, 
			    valor_unitario, 
			    estoque_bloqueado, 
			    perfil_demanda, 
			    tempo_medio_apanhe, 
			    embalagem, 
			    idunidade_medida, 
			    ressuprimento_manual, 
			    ressuprimento_manual_dias, 
			    cod_produto, 
			    codigo_barras, 
			    fator_atuacao, 
			    estoque_avaria, 
			    estoque_reservado, 
			    multiplo_compra, 
			    unidade_master,
				tipo_fator_conversao,
				compra_transito_entregue,
				estoque_minimo,
			    processamento,
			    classificacao_rentabilidade,
                estoque_seguranca_estetico,
                ponto_pedido_estetico,
                estoque_maximo_estetico,
				estoque_pendente,
	            idsecao,
				idcategoria
			)
			VALUES(
			    rec_produto_filial.id_grupo, 
			    rec_produto_filial.filial, 
			    rec_produto_filial.idproduto, 
			    rec_produto_filial.descricao_produto, 
			    rec_produto_filial.idcomprador, 
			    rec_produto_filial.idfornecedor, 
                rec_produto_filial.idfamilia_produto, 
                rec_produto_filial.idfamilia_produto, 
			    rec_produto_filial.revenda, 
			    rec_produto_filial.status, 
			    rec_produto_filial.estoque, 
			    rec_produto_filial.cobertura_estoque, 
			    rec_produto_filial.estoque_seguranca, 
			    rec_produto_filial.ponto_pedido,
			    rec_produto_filial.estoque_maximo,
			    rec_produto_filial.consumo_medio_mensal,
			    rec_produto_filial.desvio_padrao_consumo,
			    rec_produto_filial.tempo_medio_ressuprimento,
			    rec_produto_filial.tempo_ressuprimento,
			    rec_produto_filial.desvio_padrao_ressuprimento,
			    rec_produto_filial.coeficiente_variacao,
			    rec_produto_filial.compra_transito,
			    rec_produto_filial.lote_minimo,
			    rec_produto_filial.lote_compras_bruto,
			    rec_produto_filial.arvore_decisao, 
			    rec_produto_filial.nivel_servico, 
			    rec_produto_filial.peso_compras, 
			    rec_produto_filial.unidade_compra, 
			    rec_produto_filial.lote_embalagem, 
			    rec_produto_filial.sob_encomenda, 
			    rec_produto_filial.lote_compras, 
			    rec_produto_filial.preco_compra, 
			    rec_produto_filial.custo_unitario, 
			    rec_produto_filial.valor_unitario, 
			    rec_produto_filial.estoque_bloqueado, 
			    rec_produto_filial.perfil_demanda, 
			    rec_produto_filial.tempo_medio_apanhe, 
			    rec_produto_filial.embalagem, 
			    rec_produto_filial.idunidade_medida, 
			    rec_produto_filial.ressuprimento_manual, 
			    rec_produto_filial.ressuprimento_manual_dias, 
			    rec_produto_filial.cod_produto, 
			    rec_produto_filial.codigo_barras, 
			    rec_produto_filial.fator_atuacao, 
			    rec_produto_filial.estoque_avaria, 
			    rec_produto_filial.estoque_reservado, 
			    rec_produto_filial.multiplo_compra, 
			    rec_produto_filial.unidade_master,
		  		rec_produto_filial.tipo_fator_conversao,
		  		rec_produto_filial.compra_transito_entregue,
		  		rec_produto_filial.estoque_minimo,
			    current_timestamp,
			    rec_produto_filial.classificacao_rentabilidade,
                rec_produto_filial.estoque_seguranca_estetico,
                rec_produto_filial.ponto_pedido_estetico,
                rec_produto_filial.estoque_maximo_estetico,
				rec_produto_filial.estoque_pendente,
            	rec_produto_filial.idsecao,
				rec_produto_filial.idcategoria
			);
		END IF;
	END LOOP;
    
    delete from produtos_compras_filial 
    where
        flag='D' 
        and (produtos_compras_filial.filial = filtro_filial OR filtro_filial = 0)
        AND (produtos_compras_filial.idfornecedor  = filtro_id_fornecedor OR filtro_id_fornecedor = 0);
    
END;
$function$

