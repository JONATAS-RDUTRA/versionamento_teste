CREATE OR REPLACE FUNCTION public.processar_produtos_forecast_categoria(p_grupo integer DEFAULT 0, p_departamento character varying DEFAULT '0'::character varying, p_idcategoria character varying DEFAULT '0'::character varying)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
declare

rec_forecast record;

begin

update produtos_forecast_categorias
set flag ='D'
WHERE
	(id_grupo = p_grupo or p_grupo = 0)
	and (iddepartamento = p_departamento or p_departamento = '0')
	and (idcategoria = p_idcategoria or p_idcategoria = '0');

for rec_forecast in(
	select
		*,
		gerar_lote_embalagem(a.lote_compras_bruto, a.lote_minimo) AS lote_compras
	from
		(
		select
			pcc.id_grupo,
			pcc.iddepartamento,
			pcc.idsecao,
			pcc.idcategoria,
			pcc.descricao_categoria,
			pcc.consumo_medio_mensal,
			pcc.desvio_padrao_consumo ,
			pcc.estoque,
			pcc.ponto_pedido,
			pcc.estoque_maximo,
			(pcc.estoque - (((pcc.consumo_medio_mensal)/ 30) * COALESCE(c.tempo_forecast, d.tempo_forecast))) AS saldo_futuro,
			pcc.processamento,
			round((pcc.estoque_maximo + (pcc.consumo_medio_mensal * (pcc.tempo_ressuprimento  + pcc.desvio_padrao_ressuprimento) - pcc.estoque)), 2) AS lote_compras_bruto,
			pcc.tempo_ressuprimento,
			pcc.tempo_medio_ressuprimento,
			pcc.lote_minimo,
			pcc.nivel_servico
		from
			produtos_compras_categorias pcc
			INNER JOIN departamentos d ON d.iddepartamento::TEXT = pcc.iddepartamento
	        INNER JOIN categorias c ON c.idcategoria::TEXT = pcc.idcategoria
		where
			pcc.lote_compras = 0
			and pcc.compra_transito = 0
			and pcc.consumo_medio_mensal > 0
			and (pcc.id_grupo = p_grupo or p_grupo = 0)
			and (pcc.iddepartamento = p_departamento or p_departamento = '0')
			and (pcc.idcategoria = p_idcategoria or p_idcategoria = '0')
		) a
	where
		saldo_futuro <= ponto_pedido
  )
  loop


	update
		produtos_forecast_categorias
	set
		iddepartamento = rec_forecast.iddepartamento,
		idsecao = rec_forecast.idsecao,
		descricao_categoria = rec_forecast.descricao_categoria,
		consumo_medio_mensal = rec_forecast.consumo_medio_mensal,
		desvio_padrao_consumo = rec_forecast.desvio_padrao_consumo,
		estoque = rec_forecast.estoque,
		ponto_pedido = rec_forecast.ponto_pedido,
		estoque_maximo = rec_forecast.estoque_maximo,
		saldo_futuro = rec_forecast.saldo_futuro,
		lote_compras = rec_forecast.lote_compras,
		flag = null,
		tempo_ressuprimento = rec_forecast.tempo_ressuprimento,
		tempo_medio_ressuprimento = rec_forecast.tempo_medio_ressuprimento,
		lote_minimo = rec_forecast.lote_minimo,
		nivel_servico = rec_forecast.nivel_servico,
		processamento = current_timestamp
	where
		id_grupo = rec_forecast.id_grupo
		and idcategoria = rec_forecast.idcategoria;


	if not found then

		insert
			into
			produtos_forecast_categorias (
				id_grupo,
				iddepartamento,
				idsecao,
				idcategoria,
				descricao_categoria,
				consumo_medio_mensal,
				desvio_padrao_consumo,
				estoque,
				ponto_pedido,
				estoque_maximo,
				saldo_futuro,
				lote_compras,
				tempo_ressuprimento,
				tempo_medio_ressuprimento,
				lote_minimo,
				nivel_servico,
				processamento
			)
			values(
			    rec_forecast.id_grupo,
				rec_forecast.iddepartamento,
				rec_forecast.idsecao,
				rec_forecast.idcategoria,
				rec_forecast.descricao_categoria,
				rec_forecast.consumo_medio_mensal,
				rec_forecast.desvio_padrao_consumo,
				rec_forecast.estoque,
				rec_forecast.ponto_pedido,
				rec_forecast.estoque_maximo,
				rec_forecast.saldo_futuro,
				rec_forecast.lote_compras,
				rec_forecast.tempo_ressuprimento,
				rec_forecast.tempo_medio_ressuprimento,
				rec_forecast.lote_minimo,
				rec_forecast.nivel_servico,
				rec_forecast.processamento
			);

       end if;

	 end loop;


 delete
 from  produtos_forecast_categorias
 where  flag ='D'
	and (id_grupo = p_grupo or p_grupo = 0)
	and (iddepartamento = p_departamento or p_departamento = '0')
	and (idcategoria = p_idcategoria or p_idcategoria = '0');

end
$function$

