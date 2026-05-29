CREATE OR REPLACE FUNCTION public.processar_produtos_combinados_forecast_grupo(f_id_produto_combinado character varying DEFAULT NULL::character varying)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
        DECLARE rec_forecast record;
    BEGIN
        IF trim(f_id_produto_combinado) = '' THEN
            f_id_produto_combinado = NULL;
        END IF;

        UPDATE produtos_combinados_forecast_grupo SET flag = 'D' WHERE (f_id_produto_combinado = id_produto_combinado OR f_id_produto_combinado IS NULL);

        FOR rec_forecast IN (
            SELECT a.id_grupo,
                a.id_produto_combinado,
                a.estoque_futuro::double precision AS estoque_futuro,
                gerar_lote_embalagem(a.lote_compras, a.lote_minimo) AS lote_compras,
                a.lote_compras AS lote_compras_bruto
            FROM (
                SELECT a_1.id_grupo,
                    a_1.id_produto_combinado,
                    a_1.estoque_futuro,
                    round((a_1.estoque_maximo::double precision + (a_1.consumo_medio_mensal * (a_1.tempo_ressuprimento + a_1.desvio_padrao_ressuprimento))::double precision - a_1.estoque::double precision)::numeric, 2) AS lote_compras,
                    a_1.lote_minimo
                FROM (
                    SELECT DISTINCT p.id_grupo,
                        p.id_produto_combinado,
                        p.ponto_pedido,
                        sum(
                            get_forecast_grupo(p.id_grupo::numeric, spci.idproduto, COALESCE((SELECT avg(f.tempo_forecast) AS avg FROM fornecedor f WHERE f.id = ANY (p.fornecedores)), 15::numeric)
                        ) / spci.fator_conversao) AS estoque_futuro,
                        p.estoque_maximo,
                        p.estoque,
                        p.tempo_ressuprimento,
                        p.desvio_padrao_ressuprimento,
                        p.consumo_medio_mensal,
                        p.lote_minimo,
                        p.fator_conversao
                    FROM produtos_combinados_compras_grupo p
                        JOIN sys_produtos_combinados_itens spci ON spci.id_produto_combinado::text = p.id_produto_combinado::text
                    WHERE
                        p.lote_compras = 0::numeric
                        AND p.consumo_medio_mensal > 0::numeric
                        AND p.compra_transito = 0::numeric
                        AND p.revenda = 'S'::text
                        AND p.status <> 'FL'::TEXT
                        AND (f_id_produto_combinado = p.id_produto_combinado OR f_id_produto_combinado IS NULL)
                    GROUP BY p.id_grupo, p.id_produto_combinado, p.ponto_pedido, p.estoque_maximo, p.estoque, p.tempo_ressuprimento, p.desvio_padrao_ressuprimento, p.consumo_medio_mensal, p.lote_minimo, p.fator_conversao
                ) a_1
                WHERE a_1.estoque_futuro::double precision <= a_1.ponto_pedido::double PRECISION
            ) a
            WHERE gerar_lote_embalagem(a.lote_compras, a.lote_minimo) > 0::numeric
        )
        LOOP
            -- UPDATE
            UPDATE produtos_combinados_forecast_grupo
            SET
                id_grupo = rec_forecast.id_grupo,
                id_produto_combinado = rec_forecast.id_produto_combinado,
                estoque_futuro = rec_forecast.estoque_futuro,
                lote_compras = rec_forecast.lote_compras,
                lote_compras_bruto = rec_forecast.lote_compras_bruto,
                flag = NULL
            WHERE
                id_grupo = rec_forecast.id_grupo
                AND id_produto_combinado = rec_forecast.id_produto_combinado;

            -- INSERT
            IF NOT FOUND THEN
                INSERT INTO produtos_combinados_forecast_grupo (
                    id_grupo,
                    id_produto_combinado,
                    estoque_futuro,
                    lote_compras,
                    lote_compras_bruto,
                    flag
                ) VALUES (
                    rec_forecast.id_grupo,
                    rec_forecast.id_produto_combinado,
                    rec_forecast.estoque_futuro,
                    rec_forecast.lote_compras,
                    rec_forecast.lote_compras_bruto,
                    NULL
                );
            END IF;
        END LOOP;

        DELETE FROM produtos_combinados_forecast_grupo WHERE flag = 'D';
    END $function$

