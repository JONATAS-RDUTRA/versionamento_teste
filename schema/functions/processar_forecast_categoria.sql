CREATE OR REPLACE FUNCTION public.processar_forecast_categoria(p_idcategoria bigint DEFAULT 0)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
declare

rec_forecast record;

begin

update produtos_forecast_categorias set flag ='D' where id_grupo in (select id from grupo_compras) and (idcategoria = p_idcategoria or p_idcategoria = 0);

for rec_forecast in(
    select
        *
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
            (pcc.estoque - (((pcc.consumo_medio_mensal + pcc.desvio_padrao_consumo)/ 30)* 25)) AS saldo_futuro,
            processamento,
            round((pcc.estoque_maximo + (pcc.consumo_medio_mensal * (pcc.tempo_ressuprimento + pcc.desvio_padrao_ressuprimento) - pcc.estoque)), 2) AS lote_compras
        from
            produtos_compras_categorias pcc
        where
            lote_compras = 0
            and compra_transito = 0
            and consumo_medio_mensal > 0 and (idcategoria = p_idcategoria or p_idcategoria = 0) ) a
    where
        saldo_futuro <= ponto_pedido
  )
  loop


    update
        produtos_forecast_categorias
    set
        descricao_categoria = rec_forecast.descricao_categoria,
        consumo_medio_mensal = rec_forecast.consumo_medio_mensal,
        desvio_padrao_consumo = rec_forecast.desvio_padrao_consumo,
        estoque = rec_forecast.estoque,
        ponto_pedido = rec_forecast.ponto_pedido,
        estoque_maximo = rec_forecast.estoque_maximo,
        saldo_futuro = rec_forecast.saldo_futuro,
        lote_compras = rec_forecast.lote_compras,
        flag = null,
        processamento = current_timestamp
    where
        id_grupo = rec_forecast.id_grupo
        and idcategoria = rec_forecast.idcategoria;


    if not found then

        insert
            into
            produtos_forecast_categorias (
            id_grupo,
            idcategoria,
            descricao_categoria,
            consumo_medio_mensal,
            desvio_padrao_consumo,
            estoque,
            ponto_pedido,
            estoque_maximo,
            saldo_futuro,
            lote_compras,
            processamento)
            values(
            rec_forecast.id_grupo,
            rec_forecast.idcategoria,
            rec_forecast.descricao_categoria,
            rec_forecast.consumo_medio_mensal,
            rec_forecast.desvio_padrao_consumo,
            rec_forecast.estoque,
            rec_forecast.ponto_pedido,
            rec_forecast.estoque_maximo,
            rec_forecast.saldo_futuro,
            rec_forecast.lote_compras,
            rec_forecast.processamento);

       end if;

     end loop;


 delete from  produtos_forecast_categorias  where  flag ='D'  and (idcategoria = p_idcategoria or p_idcategoria = 0);

end
$function$

