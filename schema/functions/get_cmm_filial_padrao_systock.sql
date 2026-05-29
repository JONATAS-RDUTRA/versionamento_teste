CREATE OR REPLACE FUNCTION public.get_cmm_filial_padrao_systock(p_filial numeric, idprod character varying, dataref date DEFAULT ('now'::text)::date)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$  

declare cmm3 numeric;

cmm6 numeric;
cmm numeric;
cmm_atual numeric;
primeiro_consumo numeric;
qtde3 numeric;
qtde6 numeric;
idforn numeric;
fator_atuacao  numeric;
tipo_fator varchar;
grupo numeric;
prod_heranca varchar;
modo_heranca int4;
tempo_heranca numeric;
cmm_heranca  numeric;
data_calc_cmm_heranca date;
lim_inf numeric;
lim_sup numeric;
begin

select
	current_date - min(emissao) into primeiro_consumo
from
	consumos c
where
	c.filial = p_filial
	and c.idproduto = idprod;




--Ajuste para aplicacao_fator de atuacao

 select
	idfornecedor,
	tipo_fator_atuacao,
	id_grupo,
	heranca,
	tipo_heranca,
	current_date - cadastro_heranca,
	limite_inferior,
	limite_superior
	
into
	idforn,
	tipo_fator,
	grupo,
	prod_heranca,
	modo_heranca,
	tempo_heranca,
	lim_inf, lim_sup
from
	produtos_filial pf
inner join grupo_filial gf on
	gf.filial = pf.filial
where
	pf.filial = p_filial
	and pf.idproduto = idprod;


--90 dias de análise;

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
		having sum(qtde) between 0 and lim_sup
	) com;



--180 dias de análise;

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
	    having sum(qtde) between 0 and lim_sup		
	) com;




if qtde6 < 6 then cmm6 = cmm3;

end if;


-- Venda Atual Corrente 


SELECT	
	greatest(coalesce(sum(qtde),0),0) AS saidas
  into cmm_atual		
FROM
	consumos
WHERE
	consumos.filial = p_filial
	and consumos.idproduto = idprod
	AND emissao BETWEEN (dataref - 30)
	AND dataref;


cmm = (cmm3 + cmm6 + cmm_atual) / 3;


 
if tipo_fator ='F' then

--     select fator into fator_atuacao  from hist_fator_atuacao where id  = ( select max(id) from hist_fator_atuacao where id_grupo=grupo and id_fornecedor=idforn  and idproduto is null);
  	SELECT COALESCE(nullif(p.fator_atuacao, 0), 1) into fator_atuacao FROM produtos_filial p WHERE p.filial = p_filial AND p.idproduto = idprod;

  else
  
--     select fator into fator_atuacao  from hist_fator_atuacao where id  = ( select max(id) from hist_fator_atuacao where id_grupo=grupo and id_fornecedor=idforn and idproduto =idprod);
  	SELECT COALESCE(nullif(p.fator_atuacao, 0), 1) into fator_atuacao FROM produtos_filial p WHERE p.filial = p_filial AND p.idproduto = idprod;
  
end if;

-- Herança de comportamento

cmm_heranca = 0;

 if prod_heranca <> '' then 
     -- 1-Lançamento
     -- 2-Continua
 
	   if modo_heranca =  1 then
	  
	       select
	         min(emissao)+ 90
	         into data_calc_cmm_heranca
			from
				consumos c
			where
				c.filial = p_filial
				and c.idproduto = prod_heranca ;
	   
		   if tempo_heranca <= 60 then	
	           cmm_heranca = (select get_cmm_heranca_filial(p_filial,prod_heranca,data_calc_cmm_heranca));
	           cmm = 0;
	   
	       end if;    
	    else 
	    
	      if tempo_heranca <= 60 then	
	       	   cmm_heranca = (select get_cmm_heranca_filial(p_filial,prod_heranca));
	      end if;
	    
	   end if; 

	  
    else
    
     cmm_heranca = 0;
      
 
 end if;
 


fator_atuacao = coalesce(fator_atuacao,1); 
 

return ((cmm +cmm_heranca)) * fator_atuacao;


end;
 $function$

