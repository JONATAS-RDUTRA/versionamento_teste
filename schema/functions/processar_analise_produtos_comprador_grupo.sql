CREATE OR REPLACE FUNCTION public.processar_analise_produtos_comprador_grupo()
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
	max_data_referencia date;
    rec record;
	rec_requisicao record;
   	rec_entregue_em_valor NUMERIC;
	rec_saldos record;
	rec_percepcao_compra record;
	rec_valor_ruptura NUMERIC;
BEGIN
	SELECT max(data_referencia) INTO max_data_referencia FROM analise_produtos_comprador_grupo;
	
	FOR rec IN (
		WITH prod AS (
			SELECT
				gf.id_grupo,
				pf.idfornecedor,
				COALESCE(pf.idcomprador, 0) AS idcomprador
			FROM
				produtos_filial pf
				JOIN grupo_filial gf ON gf.filial = pf.filial
			GROUP BY
				gf.id_grupo,
				pf.idfornecedor,
				pf.idcomprador
		)
		SELECT DISTINCT
		    CASE WHEN last_day(to_char(DAY::date, '01/MM/YYYY')::date) >= (SELECT max(sf.data) FROM saldo_filiais sf WHERE sf.data <= current_date)
		        THEN  (SELECT max(sf.data) FROM saldo_filiais sf WHERE sf.data <= current_date)
		        ELSE last_day(to_char(DAY::date, '01/MM/YYYY')::date)
		    END AS data_referencia,
		    date_part('year', DAY) AS ano,
			date_part('month', DAY) AS mes,
			p.*
		FROM
		    generate_series(current_date - 370, current_date, '1 day') DAY
		    JOIN prod AS p ON TRUE
	    WHERE 
			(max_data_referencia) IS NULL OR (day > (max_data_referencia)) 
	)
	LOOP

		SELECT
			COALESCE(trunc(sum(e.qtde * e.custo_unit)::NUMERIC, 2), 0) INTO rec_entregue_em_valor
		FROM entrada_mercadorias e
			INNER JOIN grupo_filial gf ON gf.filial = e.idfilial
			JOIN produtos_filial pf ON pf.filial = e.idfilial AND pf.idproduto = e.idproduto
		WHERE
			gf.id_grupo = rec.id_grupo
			AND pf.idfornecedor = rec.idfornecedor
			AND pf.idcomprador = rec.idcomprador
			AND date_part('year', e.data_entrada) = rec.ano
			AND date_part('month', e.data_entrada) = rec.mes;


		SELECT
			COALESCE(trunc(sum(r.qtde * r.pcompra)::NUMERIC - sum(r.qtde * r.pcompraant)::NUMERIC, 4), 0) AS valor_saving,
			COALESCE(trunc(sum(r.qtde * r.pcompra)::NUMERIC, 4), 0) AS pedidos_em_valor,
			COALESCE(trunc(sum(r.qtde_pendente * r.pcompra)::NUMERIC, 4), 0) AS pendente_em_valor
			INTO rec_requisicao
		FROM requisicoes r
			INNER JOIN grupo_filial gf ON gf.filial = r.idfilial
			JOIN produtos_filial pf ON pf.filial = r.idfilial AND pf.idproduto = r.idproduto
		WHERE
			gf.id_grupo = rec.id_grupo
			AND pf.idfornecedor = rec.idfornecedor
			AND pf.idcomprador = rec.idcomprador
			AND date_part('year', r.data_solicitacao) = rec.ano
			AND date_part('month', r.data_solicitacao) = rec.mes;

		WITH prod AS (
			SELECT
				gf.id_grupo,
				pf.idproduto,
				pf.idfornecedor,
				pf.idcomprador,
				COALESCE(avg(pf.custo_unitario) FILTER (WHERE pf.estoque > 0), 0) AS custo_unitario
			FROM
				produtos_filial pf
				JOIN grupo_filial gf ON gf.filial = pf.filial
			WHERE gf.id_grupo = rec.id_grupo
			GROUP BY
				gf.id_grupo,
				pf.idproduto,
				pf.idfornecedor,
				pf.idcomprador
		)
		SELECT
			count(sg.idproduto) AS sku_total_saldo,
			count(sg.idproduto) FILTER (WHERE sg.estoque > 0) AS sku_com_estoque,
			COALESCE(sum(sg.estoque * p.custo_unitario), 0) AS valor_estoque,
			count(sg.idproduto) FILTER (WHERE sg.estoque > sg.emax) AS sku_excesso,
			COALESCE(sum(GREATEST(sg.estoque - sg.emax, 0) * p.custo_unitario), 0) AS valor_excesso,
			count(sg.idproduto) FILTER (WHERE sg.estoque = 0) AS sku_zerado
			INTO rec_saldos
		FROM
			saldo_grupos sg
			JOIN prod AS p ON p.id_grupo = sg.id_grupo AND p.idproduto = sg.idproduto
		WHERE
			sg.id_grupo = rec.id_grupo
			AND p.idfornecedor = rec.idfornecedor
			AND p.idcomprador = rec.idcomprador
			AND sg."data" = rec.data_referencia;

       	SELECT
			count(1) FILTER (WHERE trim(upper(apcg.status_percepcao)) = 'PERCEPCAO EM RUPTURA'::TEXT) AS sku_percepcao_compra_com_ruptura,
			count(1) FILTER (WHERE trim(upper(apcg.status_percepcao)) = 'PERCEPCAO COM ELEVADA EXPOSICAO RUPTURA'::TEXT) AS sku_percepcao_compra_exposto_ruptura,
			count(1) FILTER (WHERE trim(upper(apcg.status_percepcao)) = 'PERCEPCAO EM PONTO DE PEDIDO'::TEXT) AS sku_percepcao_compra_ponto_pedido,
			count(1) FILTER (WHERE trim(upper(apcg.status_percepcao)) = 'PERCEPCAO COM ELEVADA PREMATURIDADE'::TEXT) AS sku_percepcao_compra_prematuridade,
			count(1) FILTER (WHERE trim(upper(apcg.status_percepcao)) = 'SEM COMPORTAMENTO'::TEXT) AS sku_percepcao_compra_sem_comportamento
			INTO rec_percepcao_compra
		FROM
			analise_percepcao_compras_grupos apcg
		WHERE
			id_grupo = rec.id_grupo
			AND idfornecedor = rec.idfornecedor
			AND idcomprador = rec.idcomprador
			AND date_part('year', data_solicitacao) = rec.ano
			AND date_part('month', data_solicitacao) = rec.mes;
		
		SELECT
		    sum(arpf.valor_ruptura) AS valor_ruptura
		    INTO rec_valor_ruptura
		FROM
			analise_rupturas_produtos_filial arpf
			JOIN produtos_filial pf ON pf.filial = arpf.filial AND pf.idproduto = arpf.idproduto
			JOIN grupo_filial gf ON gf.filial = arpf.filial
		WHERE 
			gf.id_grupo = rec.id_grupo
			AND arpf.ano = rec.ano
			AND arpf.mes = rec.mes
			AND pf.idfornecedor = rec.idfornecedor
			AND pf.idcomprador = rec.idcomprador;

	   	rec_valor_ruptura = COALESCE(rec_valor_ruptura, 0);

		UPDATE analise_produtos_comprador_grupo
		SET
			pedidos_em_valor = rec_requisicao.pedidos_em_valor,
			entregue_em_valor = rec_entregue_em_valor,
			pendente_em_valor = rec_requisicao.pendente_em_valor,
			sku_total_saldo = rec_saldos.sku_total_saldo,
			sku_com_estoque = rec_saldos.sku_com_estoque,
			valor_estoque = rec_saldos.valor_estoque,
			sku_excesso = rec_saldos.sku_excesso,
			valor_excesso = rec_saldos.valor_excesso,
			valor_ruptura = rec_valor_ruptura,
		    sku_zerado = rec_saldos.sku_zerado,
		    valor_saving = rec_requisicao.valor_saving,
			sku_percepcao_compra_com_ruptura = rec_percepcao_compra.sku_percepcao_compra_com_ruptura,
			sku_percepcao_compra_exposto_ruptura = rec_percepcao_compra.sku_percepcao_compra_exposto_ruptura,
			sku_percepcao_compra_ponto_pedido = rec_percepcao_compra.sku_percepcao_compra_ponto_pedido,
			sku_percepcao_compra_prematuridade = rec_percepcao_compra.sku_percepcao_compra_prematuridade,
			sku_percepcao_compra_sem_comportamento = rec_percepcao_compra.sku_percepcao_compra_sem_comportamento
		WHERE
			id_grupo = rec.id_grupo
			AND idfornecedor = rec.idfornecedor
			AND idcomprador = rec.idcomprador
			AND ano = rec.ano
			AND mes = rec.mes;

	    IF NOT FOUND THEN
         	insert into analise_produtos_comprador_grupo (
         		data_referencia,
				ano,
				mes,
				id_grupo,
				idfornecedor,
				idcomprador,
				pedidos_em_valor,
				entregue_em_valor,
				pendente_em_valor,
				sku_total_saldo,
				sku_com_estoque,
				valor_estoque,
				sku_excesso,
				valor_excesso,
				valor_ruptura,
				sku_zerado,
				valor_saving,
				sku_percepcao_compra_com_ruptura,
				sku_percepcao_compra_exposto_ruptura,
				sku_percepcao_compra_ponto_pedido,
				sku_percepcao_compra_prematuridade,
				sku_percepcao_compra_sem_comportamento
        	)
            values(
           		rec.data_referencia,
				rec.ano,
				rec.mes,
				rec.id_grupo,
				rec.idfornecedor,
				rec.idcomprador,
				rec_requisicao.pedidos_em_valor,
				rec_entregue_em_valor,
				rec_requisicao.pendente_em_valor,
				rec_saldos.sku_total_saldo,
				rec_saldos.sku_com_estoque,
				rec_saldos.valor_estoque,
				rec_saldos.sku_excesso,
				rec_saldos.valor_excesso,
				rec_valor_ruptura,
				rec_saldos.sku_zerado,
				rec_requisicao.valor_saving,
				rec_percepcao_compra.sku_percepcao_compra_com_ruptura,
				rec_percepcao_compra.sku_percepcao_compra_exposto_ruptura,
				rec_percepcao_compra.sku_percepcao_compra_ponto_pedido,
				rec_percepcao_compra.sku_percepcao_compra_prematuridade,
				rec_percepcao_compra.sku_percepcao_compra_sem_comportamento
            );
	    END IF;
	END LOOP;
END $function$

