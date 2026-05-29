CREATE OR REPLACE FUNCTION public.verificar_sazonalidade_periodo(param_filial integer, param_idproduto character varying, param_periodo_inicial text, param_periodo_final text)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$
	DECLARE
		results record;
	BEGIN
		WITH temp_periodos_sazonalidades AS (
			SELECT DISTINCT
				q.filial ,
				q.idproduto ,
				UNNEST(string_to_array(q.datas_inicio, '#')) AS init,
				UNNEST(string_to_array(q.datas_final, '#')) AS finish
			FROM
				(
				SELECT
					param_filial AS filial,
					param_idproduto AS idproduto,
					REPLACE(REPLACE(REPLACE(REPLACE(param_periodo_inicial , '["', ''), '"]', ''), '\', ''), '","', '#') AS datas_inicio,
					REPLACE(REPLACE(REPLACE(REPLACE(param_periodo_final , '["', ''), '"]', ''), '\', ''), '","', '#') AS datas_final
				) AS q
			)
			SELECT
				sum(crescimento) / count(1) AS crescimento
			FROM (
				SELECT
					w.filial ,
					w.init ,
					w.finish ,
					(soma / meses) as crescimento
				FROM (
					SELECT
						c.filial ,
						c.idproduto ,
						t.init ,
						t.finish ,
						sum(c.qtde) as soma,
				        count(EXTRACT(MONTH FROM c.emissao)) as meses
					FROM consumos c
					LEFT JOIN temp_periodos_sazonalidades t ON t.idproduto = c.idproduto
					WHERE
						c.idproduto = t.idproduto
						AND c.filial = t.filial
						AND c.emissao >= concat(t.init, '/', date_part('year', now()) - 1)::date
			        	AND c.emissao <= concat(t.finish, '/', date_part('year', now()) - 1)::date
					group by
				        c.filial,
				        c.idproduto,
				        t.init ,
				        t.finish ,
				        EXTRACT(year FROM c.emissao),
				        EXTRACT(month FROM c.emissao)
				) AS w
			) AS p
			INTO results;
		RETURN sum(results.crescimento) ;
	END;
$function$

