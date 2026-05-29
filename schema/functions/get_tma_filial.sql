CREATE OR REPLACE FUNCTION public.get_tma_filial(p_filial numeric, idprod character varying, dataref date DEFAULT ('now'::text)::date)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$
declare tma numeric;

--#### Mário Almeida - 26/07/2023 ####  - Ajuste na Função para calcular a frequência em  6 meses

begin
select
	coalesce(sum(saidas)/6, 0)
into
	tma
from
	(
	select
		to_char(emissao, 'YYYYMM') as mes,
		count(*) as saidas
	from
		consumos
	where
		filial = p_filial
		and idproduto = idProd
		and emissao between (dataref - 180) and dataref
	group by
		mes ) saidas;

return tma;
end;

$function$

