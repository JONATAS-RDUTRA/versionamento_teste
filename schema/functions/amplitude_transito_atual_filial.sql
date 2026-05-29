CREATE OR REPLACE FUNCTION public.amplitude_transito_atual_filial(p_filial numeric, idprod character varying)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$
declare amp numeric;
begin
	select round(((tempo_medio_ressuprimento - amplitude))::numeric, 1)
	into amp
	from (
		select vw_requisicoes.idproduto::varchar
			,data_prevista_cal
			,(
				case 
					when data_previsao is null
						then (data_prevista_cal - current_date)
					else (data_prevista_cal - current_date)
					end
				) amplitude
			,perfil_demanda
			,tempo_medio_ressuprimento
		from vw_requisicoes
		inner join  produtos_filial as produtos on  produtos.filial = vw_requisicoes.filial and produtos.idproduto = vw_requisicoes.idproduto::varchar
		where vw_requisicoes.idproduto::varchar = idprod
			and vw_requisicoes.filial = p_filial
			and data_entrada isnull
		order by data_solicitacao desc limit 1
		) a;
	return coalesce(amp, 0);
end;$function$

