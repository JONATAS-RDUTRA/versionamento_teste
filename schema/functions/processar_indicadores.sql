CREATE OR REPLACE FUNCTION public.processar_indicadores(qtd_meses integer DEFAULT 13)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE 
	item_rec record;
BEGIN 
	-- Prismas
	FOR item_rec IN (
		SELECT LEAST(last_day(day::date), current_date) as data
		FROM generate_series(current_date - make_interval(months => qtd_meses), current_date, '1 month') day
	)
	LOOP 
		PERFORM processar_prismas_filiais(item_rec.data);
	END LOOP;

	-- Saldos diário
	FOR item_rec IN (
		SELECT gf.filial, day::date as data
		FROM generate_series(current_date - make_interval(months => qtd_meses), current_date, '1 day') day
		    CROSS JOIN grupo_filial gf  
		ORDER BY day, gf.filial
	)
	LOOP
		PERFORM gerar_saldos_diario(item_rec.filial::integer, item_rec.data::date, item_rec.data::date, 0::numeric);
	END LOOP;
	
	REFRESH MATERIALIZED VIEW saldo_grupos;
          
	-- Status Produto
	FOR item_rec IN (
		SELECT LEAST(last_day(day::date), current_date) as data
		FROM generate_series(current_date - make_interval(months => qtd_meses), current_date, '1 month') day
	)
	LOOP 
		PERFORM processar_status_produto(item_rec.data);
	END LOOP;
	
	PERFORM processar_analise_rupturas_produtos_filial(current_date - 400);
	PERFORM processar_analise_percepcao_compras_grupos(current_date - 400);
END; $function$

