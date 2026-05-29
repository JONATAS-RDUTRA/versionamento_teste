CREATE OR REPLACE FUNCTION public.processar_produtos_compras_grupo(filtro_id_grupo integer DEFAULT 0, filtro_id_fornecedor bigint DEFAULT 0)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE 
	rec_produto_grupo record;
BEGIN 
    
    update produtos_compras_grupo  
    set flag='D' 
    where  
        (produtos_compras_grupo.id_grupo  = filtro_id_grupo OR filtro_id_grupo = 0)
        AND (produtos_compras_grupo.idfornecedor  = filtro_id_fornecedor OR filtro_id_fornecedor = 0);
    
	FOR rec_produto_grupo IN (
		SELECT 
			lote.id_grupo,
			lote.idproduto,
			lote.descricao_produto,
			lote.idcomprador,
			lote.idfornecedor,
			lote.idfamilia_produto,
			lote.revenda,
			lote.status,
			lote.estoque,
			COALESCE(round(lote.estoque / NULLIF(lote.consumo_medio_mensal, 0::numeric), 4), 0::numeric) AS cobertura_estoque,
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
			    WHEN lote.flag_sob_encomenda::text = 'S'::text THEN 1
			    -- WHEN lote.lote_compras_bruto > 0::numeric AND lote.lote_embalagem = 0::numeric THEN 1 -- OCTADESK99905315
			    ELSE 0
			END AS sob_encomenda,
			CASE
			    WHEN lote.lote_embalagem > 0::numeric AND COALESCE(round(lote.estoque / NULLIF(lote.consumo_medio_mensal, 0::numeric), 4), 0::numeric) < lote.tempo_ressuprimento AND lote.compra_transito = 0::numeric THEN gerar_lote_embalagem(lote.estoque_maximo, COALESCE(lote.lote_minimo, 1::numeric))
			    ELSE lote.lote_embalagem
			END AS lote_compras,
			lote.preco_compra,
			lote.custo_unitario,
			lote.valor_unitario,
			lote.valor_liquido,
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
			lote.fator_conversao,
			lote.fator_atuacao,
			lote.projecao_rentabilidade,
			lote.estoque_avaria,
			lote.peso,
			lote.altura,
			lote.largura,
			lote.comprimento,
			(
				SELECT max(r.data_solicitacao) AS max
				FROM requisicoes r
			    WHERE r.idproduto::text = lote.idproduto::text AND (r.idfilial IN ( SELECT gf.filial FROM grupo_filial gf WHERE gf.id_grupo = lote.id_grupo))
			) AS data_ultima_requisicao,
			lote.estoque_reservado,
			lote.multiplo_compra::numeric(12,6) AS multiplo_compra,
			lote.unidade_master,
			lote.tipo_fator_conversao,
            lote.compra_transito_entregue,
            lote.detalhamento_tecnico,
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
				COALESCE(a.lote_minimo, 1::numeric)) AS lote_embalagem,
				a.preco_compra,
				a.custo_unitario,
				a.valor_unitario,
				a.valor_liquido,
				a.estoque_bloqueado,
				a.tempo_medio_apanhe,
				a.embalagem,
				a.idunidade_medida,
				a.ressuprimento_manual,
				a.ressuprimento_manual_dias,
				a.cod_produto,
				a.codigo_barras,
				a.fator_conversao,
				a.fator_atuacao,
				a.projecao_rentabilidade,
				a.estoque_avaria,
				a.peso,
				a.altura,
				a.largura,
				a.comprimento,
				a.flag_sob_encomenda,
				a.estoque_reservado,
				a.multiplo_compra,
				a.unidade_master,
				a.tipo_fator_conversao,
                a.compra_transito_entregue,
                a.detalhamento_tecnico,
                a.estoque_minimo,
                a.classificacao_rentabilidade,
                a.estoque_seguranca_estetico,
                (a.estoque_seguranca_estetico + ((a.consumo_medio_mensal / 30) * a.tempo_medio_ressuprimento)) AS ponto_pedido_estetico,
				a.estoque_pendente,
				a.idsecao,
				a.idcategoria
			FROM (
				WITH prismas AS (
					SELECT 
						gf.id_grupo,
				   		pf.idproduto,
				    	((min(pf.classificacao_financeira::text) || max(pf.classificacao_criticidade::text)) || min(pf.classificacao_comprabilidade)) || min(pf.classificacao_popularidade::text) AS arvore_decisao
				   	FROM produtos_filial pf
				    	JOIN grupo_filial gf ON gf.filial = pf.filial
				  	WHERE pf.processar_analise::text = 'S'::text
				  	GROUP BY gf.id_grupo, pf.idproduto
				),
                compras_pendentes_com_entrega AS (
                    SELECT 
                        gf.id_grupo,
                        r.idproduto,
                        sum(r.qtde_entregue) AS compra_transito_entregue
                    FROM requisicoes r 
                        INNER JOIN grupo_filial gf ON gf.filial = r.idfilial 
                    WHERE 
                        r.qtde_pendente > 0
                        AND r.qtde_entregue > 0
                    GROUP BY 
                        gf.id_grupo,
                        r.idproduto 
                )
				SELECT 
					g.id_grupo,
				    p.idproduto,
				    max(TRIM(BOTH FROM p.descricao_produto::text))::character varying(60) AS descricao_produto,
				    max(p.idcomprador) AS idcomprador,
				    max(p.idfornecedor) AS idfornecedor,
				    max(p.idfamilia_produto) AS idfamilia_produto,
				    max(p.revenda) as revenda,
				    min(p.status) as status,
				    p.unidade_compra,
				    sum(p.estoque * p.fator_conversao) AS estoque,
				    avg(NULLIF(p.cobertura_estoque, 0::numeric)) AS cobertura_estoque,
				    sum(p.estoque_seguranca * p.fator_conversao) AS estoque_seguranca,
				    sum(p.ponto_pedido * p.fator_conversao) AS ponto_pedido,
				    sum(p.estoque_maximo * p.fator_conversao) AS estoque_maximo,
				    sum(p.consumo_medio_mensal * p.fator_conversao) AS consumo_medio_mensal,
				    sum(p.desvio_padrao_consumo * p.fator_conversao) AS desvio_padrao_consumo,
				    avg(p.tempo_medio_ressuprimento) AS tempo_medio_ressuprimento,
				    avg(p.tempo_ressuprimento) AS tempo_ressuprimento,
				    avg(p.desvio_padrao_ressuprimento) AS desvio_padrao_ressuprimento,
				    coalesce((sum(p.desvio_padrao_consumo * p.fator_conversao)/nullif(sum(p.consumo_medio_mensal * p.fator_conversao),0)*100),0)::text AS coeficiente_variacao,
				    getcompra_transito_grupo(g.id_grupo::numeric, p.idproduto) AS compra_transito,
				    max(p.lote_minimo * p.fator_conversao) AS lote_minimo,
				    COALESCE(pm.arvore_decisao, 'CX2R'::text) AS arvore_decisao,
					getnivelservico(COALESCE(pm.arvore_decisao::character varying, 'CX2R'::character varying)) AS nivel_servico,
					getpesocompras(COALESCE(pm.arvore_decisao::character varying, 'CX2R'::character varying), "substring"(COALESCE(pm.arvore_decisao::character varying, 'CX2R'::character varying)::text, 3, 1)::numeric) AS peso_compras,
				    COALESCE(avg(NULLIF(p.preco_compra, 0::numeric)), 0::numeric) AS preco_compra,
				    COALESCE(avg(NULLIF(p.custo_unitario, 0::numeric)), 0::numeric) AS custo_unitario,
				    COALESCE(avg(NULLIF(p.valor_unitario, 0::numeric)), 0::numeric) AS valor_unitario,
					COALESCE(avg(NULLIF(p.valor_liquido, 0::numeric)), 0::numeric) AS valor_liquido,
				    sum(p.estoque_bloqueado * p.fator_conversao) AS estoque_bloqueado,
				    sum(p.tempo_medio_apanhe) AS tempo_medio_apanhe,
				    p.embalagem,
				    p.idunidade_medida,
				    max(p.ressuprimento_manual::text)::character varying(1) AS ressuprimento_manual,
				    max(COALESCE(p.ressuprimento_manual_dias, 0::numeric)) AS ressuprimento_manual_dias,
				    max(p.cod_produto::text)::character varying(30) AS cod_produto,
				    max(p.codigo_barras::text)::character varying(25) AS codigo_barras,
				    avg(p.fator_conversao) AS fator_conversao,
				    avg(p.fator_atuacao) AS fator_atuacao,
				    sum(p.projecao_rentabilidade) AS projecao_rentabilidade,
				    sum(p.estoque_avaria) AS estoque_avaria,
				    max(p.peso) AS peso,
				    max(p.altura) AS altura,
				    max(p.largura) AS largura,
				    max(p.comprimento) AS comprimento,
				    p.flag_sob_encomenda,
				    sum(COALESCE(p.estoque_reservado, 0::numeric)) AS estoque_reservado,
				    max(p.multiplo_compra) AS multiplo_compra,
				    max(p.unidade_master::text) AS unidade_master,
				    p.tipo_fator_conversao,
                    coalesce(cpce.compra_transito_entregue, 0) AS compra_transito_entregue,
                    max(p.detalhamento_tecnico) AS detalhamento_tecnico,
                    sum(p.estoque_minimo) as estoque_minimo,
                    min(p.classificacao_rentabilidade) AS classificacao_rentabilidade,
                    sum(p.estoque_minimo) AS estoque_seguranca_estetico,
					sum(p.estoque_pendente) as estoque_pendente,
					max(p.idsecao) as idsecao,
					max(p.idcategoria) as idcategoria
				FROM produtos_filial p
					INNER JOIN grupo_filial g ON p.filial = g.filial
			    	LEFT JOIN prismas pm ON pm.id_grupo = g.id_grupo AND pm.idproduto::text = p.idproduto::TEXT
                    LEFT JOIN compras_pendentes_com_entrega cpce ON cpce.id_grupo = g.id_grupo AND  cpce.idproduto = p.idproduto
		    	WHERE 
		    		(g.id_grupo = filtro_id_grupo OR filtro_id_grupo = 0)
		    		AND (p.idfornecedor = filtro_id_fornecedor OR filtro_id_fornecedor = 0)
                    AND p.revenda::text = 'S'::text 
					AND p.status::text <> 'FL'::text
                    AND p.processar_analise::text = 'S'::TEXT
			  	GROUP BY g.id_grupo, p.idproduto, p.unidade_compra, p.embalagem, p.idunidade_medida, p.flag_sob_encomenda, pm.arvore_decisao, p.tipo_fator_conversao, cpce.compra_transito_entregue
			) AS a	
		) AS lote
	)
	LOOP 
		UPDATE public.produtos_compras_grupo
		SET 
			descricao_produto = rec_produto_grupo.descricao_produto,
			idcomprador = rec_produto_grupo.idcomprador,
			idfornecedor = rec_produto_grupo.idfornecedor,
			idfamilia_produto = rec_produto_grupo.idfamilia_produto,
            iddepartamento = rec_produto_grupo.idfamilia_produto,
			revenda = rec_produto_grupo.revenda,
			status = rec_produto_grupo.status,
			estoque = rec_produto_grupo.estoque,
			cobertura_estoque = rec_produto_grupo.cobertura_estoque,
			estoque_seguranca = rec_produto_grupo.estoque_seguranca,
			ponto_pedido = rec_produto_grupo.ponto_pedido,
			estoque_maximo = rec_produto_grupo.estoque_maximo,
			consumo_medio_mensal = rec_produto_grupo.consumo_medio_mensal,
			desvio_padrao_consumo = rec_produto_grupo.desvio_padrao_consumo,
			tempo_medio_ressuprimento = rec_produto_grupo.tempo_medio_ressuprimento,
			tempo_ressuprimento = rec_produto_grupo.tempo_ressuprimento,
			desvio_padrao_ressuprimento = rec_produto_grupo.desvio_padrao_ressuprimento,
			coeficiente_variacao = rec_produto_grupo.coeficiente_variacao,
			compra_transito = rec_produto_grupo.compra_transito,
			lote_minimo = rec_produto_grupo.lote_minimo,
			lote_compras_bruto = rec_produto_grupo.lote_compras_bruto,
			arvore_decisao = rec_produto_grupo.arvore_decisao,
			nivel_servico = rec_produto_grupo.nivel_servico,
			peso_compras = rec_produto_grupo.peso_compras,
			unidade_compra = rec_produto_grupo.unidade_compra,
			lote_embalagem = rec_produto_grupo.lote_embalagem,
			sob_encomenda = rec_produto_grupo.sob_encomenda,
			lote_compras = rec_produto_grupo.lote_compras,
			preco_compra = rec_produto_grupo.preco_compra,
			custo_unitario = rec_produto_grupo.custo_unitario,
			valor_unitario = rec_produto_grupo.valor_unitario,
			valor_liquido = rec_produto_grupo.valor_liquido,
			estoque_bloqueado = rec_produto_grupo.estoque_bloqueado,
			perfil_demanda = rec_produto_grupo.perfil_demanda,
			tempo_medio_apanhe = rec_produto_grupo.tempo_medio_apanhe,
			embalagem = rec_produto_grupo.embalagem,
			idunidade_medida = rec_produto_grupo.idunidade_medida,
			ressuprimento_manual = rec_produto_grupo.ressuprimento_manual,
			ressuprimento_manual_dias = rec_produto_grupo.ressuprimento_manual_dias,
			cod_produto = rec_produto_grupo.cod_produto,
			codigo_barras = rec_produto_grupo.codigo_barras,
			fator_conversao = rec_produto_grupo.fator_conversao,
			fator_atuacao = rec_produto_grupo.fator_atuacao,
			projecao_rentabilidade = rec_produto_grupo.projecao_rentabilidade,
			estoque_avaria = rec_produto_grupo.estoque_avaria,
			peso = rec_produto_grupo.peso,
			altura = rec_produto_grupo.altura,
			largura = rec_produto_grupo.largura,
			comprimento = rec_produto_grupo.comprimento,
			data_ultima_requisicao = rec_produto_grupo.data_ultima_requisicao,
			estoque_reservado = rec_produto_grupo.estoque_reservado,
			multiplo_compra = rec_produto_grupo.multiplo_compra,
			unidade_master = rec_produto_grupo.unidade_master,
			tipo_fator_conversao = rec_produto_grupo.tipo_fator_conversao,
			processamento = current_timestamp,
            compra_transito_entregue = rec_produto_grupo.compra_transito_entregue,
            detalhamento_tecnico = rec_produto_grupo.detalhamento_tecnico,
            estoque_minimo = rec_produto_grupo.estoque_minimo,
            flag=NULL,
            classificacao_rentabilidade = rec_produto_grupo.classificacao_rentabilidade,
            estoque_seguranca_estetico = rec_produto_grupo.estoque_seguranca_estetico,
            ponto_pedido_estetico = rec_produto_grupo.ponto_pedido_estetico,
            estoque_maximo_estetico = rec_produto_grupo.estoque_maximo_estetico,
			estoque_pendente = rec_produto_grupo.estoque_pendente,
            idsecao = rec_produto_grupo.idsecao,
			idcategoria = rec_produto_grupo.idcategoria
		WHERE id_grupo = rec_produto_grupo.id_grupo AND idproduto = rec_produto_grupo.idproduto;

		IF NOT FOUND THEN
			INSERT INTO produtos_compras_grupo (
			    id_grupo,
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
				valor_liquido,
			    estoque_bloqueado,
			    perfil_demanda,
			    tempo_medio_apanhe,
			    embalagem,
			    idunidade_medida,
			    ressuprimento_manual,
			    ressuprimento_manual_dias,
			    cod_produto,
			    codigo_barras,
			    fator_conversao,
			    fator_atuacao,
			    projecao_rentabilidade,
			    estoque_avaria,
			    peso,
			    altura,
			    largura,
			    comprimento,
			    data_ultima_requisicao,
			    estoque_reservado,
			    multiplo_compra,
			    unidade_master,
				tipo_fator_conversao,
				compra_transito_entregue,
                detalhamento_tecnico,
			    processamento,
			    estoque_minimo,
			    classificacao_rentabilidade,
                estoque_seguranca_estetico,
                ponto_pedido_estetico,
                estoque_maximo_estetico,
				estoque_pendente,
	            idsecao,
				idcategoria
			)
			VALUES(
			    rec_produto_grupo.id_grupo,
			    rec_produto_grupo.idproduto,
			    rec_produto_grupo.descricao_produto,
			    rec_produto_grupo.idcomprador,
			    rec_produto_grupo.idfornecedor,
                rec_produto_grupo.idfamilia_produto,
                rec_produto_grupo.idfamilia_produto,
			    rec_produto_grupo.revenda,
			    rec_produto_grupo.status,
			    rec_produto_grupo.estoque,
			    rec_produto_grupo.cobertura_estoque,
			    rec_produto_grupo.estoque_seguranca,
			    rec_produto_grupo.ponto_pedido,
			    rec_produto_grupo.estoque_maximo,
			    rec_produto_grupo.consumo_medio_mensal,
			    rec_produto_grupo.desvio_padrao_consumo,
			    rec_produto_grupo.tempo_medio_ressuprimento,
			    rec_produto_grupo.tempo_ressuprimento,
			    rec_produto_grupo.desvio_padrao_ressuprimento,
			    rec_produto_grupo.coeficiente_variacao,
			    rec_produto_grupo.compra_transito,
			    rec_produto_grupo.lote_minimo,
			    rec_produto_grupo.lote_compras_bruto,
			    rec_produto_grupo.arvore_decisao,
			    rec_produto_grupo.nivel_servico,
			    rec_produto_grupo.peso_compras,
			    rec_produto_grupo.unidade_compra,
			    rec_produto_grupo.lote_embalagem,
			    rec_produto_grupo.sob_encomenda,
			    rec_produto_grupo.lote_compras,
			    rec_produto_grupo.preco_compra,
			    rec_produto_grupo.custo_unitario,
			    rec_produto_grupo.valor_unitario,
				rec_produto_grupo.valor_liquido,
			    rec_produto_grupo.estoque_bloqueado,
			    rec_produto_grupo.perfil_demanda,
			    rec_produto_grupo.tempo_medio_apanhe,
			    rec_produto_grupo.embalagem,
			    rec_produto_grupo.idunidade_medida,
			    rec_produto_grupo.ressuprimento_manual,
			    rec_produto_grupo.ressuprimento_manual_dias,
			    rec_produto_grupo.cod_produto,
			    rec_produto_grupo.codigo_barras,
			    rec_produto_grupo.fator_conversao,
			    rec_produto_grupo.fator_atuacao,
			    rec_produto_grupo.projecao_rentabilidade,
			    rec_produto_grupo.estoque_avaria,
			    rec_produto_grupo.peso,
			    rec_produto_grupo.altura,
			    rec_produto_grupo.largura,
			    rec_produto_grupo.comprimento,
			    rec_produto_grupo.data_ultima_requisicao,
			    rec_produto_grupo.estoque_reservado,
			    rec_produto_grupo.multiplo_compra,
			    rec_produto_grupo.unidade_master,
			    rec_produto_grupo.tipo_fator_conversao,
                rec_produto_grupo.compra_transito_entregue,
                rec_produto_grupo.detalhamento_tecnico,
			    current_timestamp,
			    rec_produto_grupo.estoque_minimo,
			    rec_produto_grupo.classificacao_rentabilidade,
                rec_produto_grupo.estoque_seguranca_estetico,
                rec_produto_grupo.ponto_pedido_estetico,
                rec_produto_grupo.estoque_maximo_estetico,
				rec_produto_grupo.estoque_pendente,
            	rec_produto_grupo.idsecao,
				rec_produto_grupo.idcategoria
			);
		END IF;
	END LOOP;
	
    
   delete from produtos_compras_grupo 
   where 
        flag='D' 
        and (produtos_compras_grupo.id_grupo  = filtro_id_grupo OR filtro_id_grupo = 0)
        AND (produtos_compras_grupo.idfornecedor  = filtro_id_fornecedor OR filtro_id_fornecedor = 0);
          
END;
$function$

