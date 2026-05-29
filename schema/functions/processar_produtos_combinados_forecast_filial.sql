CREATE OR REPLACE FUNCTION public.processar_produtos_combinados_forecast_filial(f_id_produto_combinado character varying DEFAULT NULL::character varying)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
        DECLARE rec_forecast record;
    BEGIN
        IF trim(f_id_produto_combinado) = '' THEN
            f_id_produto_combinado = NULL;
        END IF;

        UPDATE produtos_combinados_forecast_filial SET flag = 'D' WHERE (f_id_produto_combinado = id_produto_combinado OR f_id_produto_combinado IS NULL);

        FOR rec_forecast IN (
            SELECT
                b.id_grupo,
                b.filial,
                b.id_produto_combinado,
                b.estoque_futuro::double precision AS estoque_futuro,
                gerar_lote_embalagem(b.lote_compras, b.lote_minimo) AS lote_compras,
                b.lote_compras AS lote_compras_bruto
            FROM (
                SELECT
                    a.id_grupo,
                    a.filial,
                    a.id_produto_combinado,
                    a.estoque_futuro,
                    round((a.estoque_maximo::double precision + (a.consumo_medio_mensal * (a.tempo_ressuprimento + a.desvio_padrao_ressuprimento))::double precision - a.estoque::double precision)::numeric, 2) AS lote_compras,
                    a.lote_minimo
                FROM (
                    SELECT DISTINCT p.id_grupo,
                        p.filial,
                        p.id_produto_combinado,
                        p.ponto_pedido,
                        sum(
                            get_forecast_filial(p.filial::numeric, spci.idproduto, COALESCE(( SELECT avg(f.tempo_forecast) AS avg
                                FROM fornecedor f
                                WHERE f.id = ANY (p.fornecedores)), 15::numeric)) / spci.fator_conversao
                        ) AS estoque_futuro,
                        p.estoque_maximo,
                        p.estoque,
                        p.tempo_ressuprimento,
                        p.desvio_padrao_ressuprimento,
                        p.consumo_medio_mensal,
                        p.lote_minimo,
                        1 AS fator_conversao
                    FROM produtos_combinados_compras_filial p
                    JOIN sys_produtos_combinados_itens spci ON spci.id_produto_combinado::text = p.id_produto_combinado::text
                    WHERE
                        p.lote_compras = 0::numeric
                        AND p.consumo_medio_mensal > 0::numeric
                        AND p.compra_transito = 0::numeric
                        AND p.revenda = 'S'::text
                        AND p.status <> 'FL'::TEXT
                        AND (f_id_produto_combinado = p.id_produto_combinado OR f_id_produto_combinado IS NULL)
                    GROUP BY p.id_grupo, p.filial, p.id_produto_combinado, p.ponto_pedido, p.estoque_maximo, p.estoque, p.tempo_ressuprimento, p.desvio_padrao_ressuprimento, p.consumo_medio_mensal, p.lote_minimo
                ) a
                WHERE a.estoque_futuro::double precision <= a.ponto_pedido::double PRECISION
            ) b
            WHERE gerar_lote_embalagem(b.lote_compras, b.lote_minimo) > 0::numeric
        )
        LOOP
            -- UPDATE
            UPDATE produtos_combinados_forecast_filial
            SET
                id_grupo = rec_forecast.id_grupo,
                filial = rec_forecast.filial,
                id_produto_combinado = rec_forecast.id_produto_combinado,
                estoque_futuro = rec_forecast.estoque_futuro,
                lote_compras = rec_forecast.lote_compras,
                lote_compras_bruto = rec_forecast.lote_compras_bruto,
                flag = NULL
            WHERE
                id_grupo = rec_forecast.id_grupo
                AND filial = rec_forecast.filial
                AND id_produto_combinado = rec_forecast.id_produto_combinado;

            -- INSERT
            IF NOT FOUND THEN
                INSERT INTO produtos_combinados_forecast_filial (
                    id_grupo,
                    filial,
                    id_produto_combinado,
                    estoque_futuro,
                    lote_compras,
                    lote_compras_bruto,
                    flag
                ) VALUES (
                    rec_forecast.id_grupo,
                    rec_forecast.filial,
                    rec_forecast.id_produto_combinado,
                    rec_forecast.estoque_futuro,
                    rec_forecast.lote_compras,
                    rec_forecast.lote_compras_bruto,
                    NULL
                );
            END IF;
        END LOOP;

        DELETE FROM produtos_combinados_forecast_filial WHERE flag = 'D';
    END $function$

