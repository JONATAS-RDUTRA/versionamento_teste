CREATE OR REPLACE FUNCTION public.get_cmm_heranca_filial(p_filial numeric, idprod character varying, dataref date DEFAULT ('now'::text)::date)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$ 

declare cmm3 numeric;

cmm6 numeric;
cmm numeric;
primeiro_consumo numeric;
qtde3 numeric;
qtde6 numeric;
idforn numeric;
fator_atuacao  numeric;
tipo_fator varchar;
grupo numeric;

begin

IF substring(idprod, 0, 8) = 'SYSCOMB' THEN
    return (
        SELECT sum(COALESCE(get_cmm_heranca_filial(p_filial, s.idproduto, dataref), 0))
        FROM sys_produtos_combinados_itens s
        WHERE s.id_produto_combinado = idprod
    );
END IF;

select
	current_date - min(emissao) into primeiro_consumo
from
	consumos c
where
	c.filial = p_filial
	and c.idproduto = idprod;

--Media do Consumo  sai 365 para  (90+180)/2 
-- 30/05/2019 - Inclusao do abatimento Corte nas saidas
SELECT
	coalesce(
		round(
			cast(
				sum(saidas) /(
					abs(
						case
							when abs(
								datediff(
									'mm',
									cast(to_char(dataref, 'YYYYMMDD') as date),
									cast(min(mes) || '01' as date)
								)
							) + 1 > 3 then 3
							when abs(
								datediff(
									'mm',
									cast(to_char(dataref, 'YYYYMMDD') as date),
									cast(min(mes) || '01' as date)
								)
							) + 1 < 3
							and primeiro_consumo >= 90 then 3
							else abs(
								datediff(
									'mm',
									cast(to_char(dataref, 'YYYYMMDD') as date),
									cast(min(mes) || '01' as date)
								)
							) + 1
						end
					)
				) as numeric
			),
			2
		),
		0
	),
	(
		abs(
			case
				when abs(
					datediff(
						'mm',
						cast(to_char(dataref, 'YYYYMMDD') as date),
						cast(min(mes) || '01' as date)
					)
				) + 1 > 3 then 3
				when abs(
					datediff(
						'mm',
						cast(to_char(dataref, 'YYYYMMDD') as date),
						cast(min(mes) || '01' as date)
					)
				) + 1 < 3
				and primeiro_consumo >= 90 then 3
				else abs(
					datediff(
						'mm',
						cast(to_char(dataref, 'YYYYMMDD') as date),
						cast(min(mes) || '01' as date)
					)
				) + 1
			end
		)
	) into cmm3,
	qtde3
FROM
	(
		SELECT
			to_char(emissao, 'YYYYMM') AS mes,
			to_char(emissao, 'YYYYMMDD') AS dia,
			sum(qtde) AS saidas
		FROM
			consumos
		WHERE
			consumos.filial = p_filial
			and consumos.idproduto = idprod
			AND emissao BETWEEN (dataref - 90)
			AND dataref
		GROUP BY
			mes,
			dia
	) com;

SELECT
	coalesce(
		round(
			cast(
				sum(saidas) /(
					abs(
						case
							when abs(
								datediff(
									'mm',
									cast(to_char(dataref, 'YYYYMMDD') as date),
									cast(min(mes) || '01' as date)
								)
							) + 1 > 6 then 6
							when abs(
								datediff(
									'mm',
									cast(to_char(dataref, 'YYYYMMDD') as date),
									cast(min(mes) || '01' as date)
								)
							) + 1 < 6
							and primeiro_consumo >= 180 then 6
							else abs(
								datediff(
									'mm',
									cast(to_char(dataref, 'YYYYMMDD') as date),
									cast(min(mes) || '01' as date)
								)
							) + 1
						end
					)
				) as numeric
			),
			2
		),
		0
	),
	(
		abs(
			case
				when abs(
					datediff(
						'mm',
						cast(to_char(dataref, 'YYYYMMDD') as date),
						cast(min(mes) || '01' as date)
					)
				) + 1 > 6 then 6
				when abs(
					datediff(
						'mm',
						cast(to_char(dataref, 'YYYYMMDD') as date),
						cast(min(mes) || '01' as date)
					)
				) + 1 < 6
				and primeiro_consumo >= 180 then 6
				else abs(
					datediff(
						'mm',
						cast(to_char(dataref, 'YYYYMMDD') as date),
						cast(min(mes) || '01' as date)
					)
				) + 1
			end
		)
	) into cmm6,
	qtde6
FROM
	(
		SELECT
			to_char(emissao, 'YYYYMM') AS mes,
			to_char(emissao, 'YYYYMMDD') AS dia,
			sum(qtde) AS saidas
		FROM
			consumos
		WHERE
			consumos.filial = p_filial
			and consumos.idproduto = idprod
			AND emissao BETWEEN (dataref - 180)
			AND dataref
		GROUP BY
			mes,
			dia
	) com;

if qtde6 < 6 then cmm6 = cmm3;

end if;

cmm = (cmm3 + cmm6) / 2;

if cmm = 0 then
 
   return 0;

else 

return cmm ;

end if;

end;
$function$

