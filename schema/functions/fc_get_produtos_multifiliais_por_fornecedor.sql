CREATE OR REPLACE FUNCTION public.fc_get_produtos_multifiliais_por_fornecedor(p_id_fornecedor integer)
 RETURNS TABLE(id_grupo integer, idfornecedor integer, idcomprador integer, iddepartamento integer, idfamilia_produto text, tipo text, nivel_servico text, status text, filial integer, idproduto text, descricao_produto text, unidade_compra text, estoque numeric, status_suprimento_sku text, peso_compras integer, tempo_gatilho integer, estoque_maximo numeric, sugestao_drp numeric, sugestao numeric)
 LANGUAGE sql
AS $function$
		WITH produto_por_filiais_cds AS (
			SELECT
				mc.filial,
				pf.idproduto,
				sum(floor(pf.estoque)) AS estoque_disponivel
			FROM mapa_compra mc
				INNER JOIN produtos_filial pf ON pf.filial = mc.filial_cd
			WHERE pf.estoque > 0 AND pf.idfornecedor = p_id_fornecedor
			GROUP BY
				mc.filial,
				pf.idproduto
		),
		produtos_em_gatilho_compra AS (
			SELECT
				vgcp.id_grupo,
				vgcp.idfornecedor,
				vgcp.idcomprador,
				dpto.iddepartamento,
				dpto.descricao_departamento AS idfamilia_produto,
				'CP'::text AS tipo,
				vgcp.nivel_servico,
				"substring"(btrim(replace(vgcp.nivel_servico::text, 'NIVEL'::text, ''::text)), 1, 1) AS status,
				vgcp.filial,
				vgcp.idproduto,
				vgcp.descricao_produto,
				vgcp.unidade_compra,
				vgcp.estoque,
				ceil(vgcp.lote_compras) AS sugestao,
				'RESSUPRIR'::text AS status_suprimento_sku,
				vgcp.peso_compras,
				vgcp.estoque_maximo,
				(SELECT COALESCE(max(hgcg.data) - 'now'::text::date, 0) AS tempo
					FROM hist_gatilho_compras_grupo hgcg
					WHERE hgcg.grupo = vgcp.id_grupo::numeric AND hgcg.idproduto::text = vgcp.idproduto::text AND hgcg.tipo::text = 'CP'::text AND hgcg.status::text = 'A'::TEXT
					) AS tempo_gatilho,
				vgcp.lote_minimo
			FROM vw_grupo_compras_produtos_filial vgcp
				JOIN departamentos dpto ON dpto.iddepartamento = vgcp.idfamilia_produto
			WHERE
				vgcp.revenda::text = 'S'::text
				AND vgcp.revenda::text <> 'FL'::text
				AND dpto.descricao_departamento::text !~~ '%FEIRAO%'::text
				AND dpto.descricao_departamento::text !~~ '%AVARIA%'::TEXT
				AND vgcp.idfornecedor = p_id_fornecedor
		)
		SELECT
			vf.id_grupo::int,
			vf.idfornecedor::int,
			vf.idcomprador::int,
			vf.iddepartamento::int,
			vf.idfamilia_produto::text,
			vf.tipo::text,
			vf.nivel_servico::text,
			vf.status::text,
			vf.filial::int,
			vf.idproduto::text,
			vf.descricao_produto::text,
			vf.unidade_compra::text,
			vf.estoque::NUMERIC ,
			vf.status_suprimento_sku::text,
			vf.peso_compras::int,
			vf.tempo_gatilho::int,
			vf.estoque_maximo::NUMERIC AS estoque_maximo,
			(CASE
				WHEN cds.estoque_disponivel >= (sum(vf.sugestao) FILTER (WHERE cds.estoque_disponivel IS NOT NULL) OVER (PARTITION BY vf.idproduto))::NUMERIC
					THEN vf.estoque_maximo
					ELSE COALESCE(floor((vf.sugestao / NULLIF((sum(vf.sugestao) FILTER (WHERE cds.estoque_disponivel IS NOT NULL) OVER (PARTITION BY vf.idproduto)), 0)) * cds.estoque_disponivel), 0)
			END)::numeric sugestao_drp,
			gerar_lote_embalagem(
				(CASE
					WHEN cds.estoque_disponivel >= (sum(vf.sugestao) FILTER (WHERE cds.estoque_disponivel IS NOT NULL) OVER (PARTITION BY vf.idproduto))::NUMERIC
						THEN 0::NUMERIC
						ELSE CEIL(vf.sugestao - COALESCE(floor((vf.sugestao / NULLIF((sum(vf.sugestao) FILTER (WHERE cds.estoque_disponivel IS NOT NULL) OVER (PARTITION BY vf.idproduto)), 0)) * cds.estoque_disponivel), 0))::NUMERIC
				END),
				vf.lote_minimo
			) sugestao
		FROM produtos_em_gatilho_compra vf
			LEFT JOIN produto_por_filiais_cds cds
				ON cds.idproduto = vf.idproduto AND cds.filial = vf.filial AND cds.estoque_disponivel > 0
		ORDER BY vf.descricao_produto, vf.peso_compras DESC
	$function$

