CREATE OR REPLACE FUNCTION public.get_estoque_futuro_tempo_ressuprimento_produto(p_idgrupo integer, p_filial integer, p_idproduto character varying)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$
    DECLARE
        cadastro_produto_red record;
        qtd_dias_ate_entrega_total_pedidos int;
        dia_ressuprimento_red record;
        qtd_saldo_estoque_futuro numeric(12, 4);
        produto_eh_combinacao bool;
    BEGIN
        produto_eh_combinacao = substring(p_idproduto, 0, 8) = 'SYSCOMB';

        if p_filial = 0 then
            IF produto_eh_combinacao THEN
                SELECT estoque, tempo_medio_ressuprimento, consumo_medio_mensal, compra_transito, produtos INTO cadastro_produto_red
                FROM produtos_combinados_compras_grupo pcg
                WHERE pcg.id_grupo = p_idgrupo AND pcg.id_produto_combinado = p_idproduto;
            ELSE
                SELECT estoque, tempo_medio_ressuprimento, consumo_medio_mensal, compra_transito INTO cadastro_produto_red
                FROM produtos_compras_grupo pcg
                WHERE pcg.id_grupo = p_idgrupo AND pcg.idproduto = p_idproduto;
            END IF;
        else
            IF produto_eh_combinacao THEN
                SELECT estoque, tempo_medio_ressuprimento, consumo_medio_mensal, compra_transito, produtos INTO cadastro_produto_red
                FROM produtos_combinados_compras_filial pcg
                WHERE pcg.id_grupo = p_idgrupo AND pcg.filial = p_filial AND pcg.id_produto_combinado = p_idproduto;
            ELSE
                SELECT estoque, tempo_medio_ressuprimento, consumo_medio_mensal, compra_transito INTO cadastro_produto_red
                FROM produtos_compras_filial pcg
                WHERE pcg.id_grupo = p_idgrupo AND pcg.filial = p_filial AND pcg.idproduto = p_idproduto;
            END IF;
        end if;

        -- Se não tiver compra em aberto faz o calculo direto sem percorrer dia a dia
        if coalesce(cadastro_produto_red.compra_transito, 0) = 0 then
            return greatest(cadastro_produto_red.estoque - ((cadastro_produto_red.consumo_medio_mensal / 30.0) * cadastro_produto_red.tempo_medio_ressuprimento), 0);
        end if;

        SELECT GREATEST(max(COALESCE(r.data_prevista_cal, data_solicitacao + cadastro_produto_red.tempo_medio_ressuprimento::int)) - current_date, 0) into qtd_dias_ate_entrega_total_pedidos
        FROM analise_requisicoes r
            INNER JOIN grupo_filial gf ON gf.filial = r.filial
        WHERE
            gf.id_grupo = p_idgrupo
            and (p_filial = 0 or p_filial = r.filial)
            AND CASE
                WHEN produto_eh_combinacao is true then exists(SELECT 1 FROM sys_produtos_combinados_itens i WHERE i.id_produto_combinado = p_idproduto AND i.idproduto = r.idproduto)
                else r.idproduto = p_idproduto
            END
            AND qtde_pendente > 0;

        -- Pega o estoque atual/inicial
        qtd_saldo_estoque_futuro = cadastro_produto_red.estoque;

        -- Percorre dia a dia computando entradas e saidas
        FOR dia_ressuprimento_red in (
            WITH _entradas AS (
                SELECT
                    CASE WHEN r.data_prevista_cal < current_date THEN current_date ELSE r.data_prevista_cal END AS data,
                    sum(qtde_pendente) AS qtde
                FROM analise_requisicoes r
                    INNER JOIN grupo_filial gf ON gf.filial = r.filial
                    LEFT JOIN sys_produtos_combinados_itens i ON i.idproduto = r.idproduto
                WHERE
                    gf.id_grupo = p_idgrupo
                    and (p_filial = 0 or p_filial = r.filial)
                    AND CASE
                        WHEN produto_eh_combinacao is true then i.id_produto_combinado = p_idproduto
                        else r.idproduto = p_idproduto
                    END
                    AND r.qtde_pendente > 0
                GROUP BY CASE WHEN r.data_prevista_cal < current_date THEN current_date ELSE r.data_prevista_cal END
            ),
            _datas_ate_entrega AS (
                SELECT v1.date::date AS data
                FROM generate_series(
                    current_date,
                    current_date + GREATEST(cadastro_produto_red.tempo_medio_ressuprimento, qtd_dias_ate_entrega_total_pedidos)::int,
                    '1 day'
                ) AS v1(data)
            )
            SELECT
                to_char(d.data, 'DD/MM/YYYY') AS data,
                COALESCE((SELECT sum(e1.qtde) FROM _entradas e1 WHERE e1.data = d.data), 0) AS entradas,
                ROW_NUMBER() over() AS numero_dia
            FROM _datas_ate_entrega d
            ORDER BY
                d.DATA
        )
        LOOP
            qtd_saldo_estoque_futuro = qtd_saldo_estoque_futuro + coalesce(dia_ressuprimento_red.entradas, 0);

            -- Não diminue do estoque o último dia do tempo de ressuprimento(igual gráfico da tela)
            if dia_ressuprimento_red.numero_dia = GREATEST(cadastro_produto_red.tempo_medio_ressuprimento, qtd_dias_ate_entrega_total_pedidos)::int then
                CONTINUE;
            end if;

            qtd_saldo_estoque_futuro = greatest(qtd_saldo_estoque_futuro - coalesce(cadastro_produto_red.consumo_medio_mensal / 30.0, 0), 0);
        END LOOP;

        return qtd_saldo_estoque_futuro;
    END;
    $function$

