CREATE OR REPLACE FUNCTION public.processar_analise_rupturas_produtos_filial(data_inicial date DEFAULT CURRENT_DATE)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
        DECLARE
            rec_analise record;
        begin
            data_inicial = to_char(data_inicial, '01/MM/YYYY')::date;

            UPDATE analise_rupturas_produtos_filial SET flag = 'D' WHERE data_ruptura >= data_inicial;

            FOR rec_analise IN (
                SELECT
                    r.ano,
                    r.mes,
                    r.filial,
                    r.idproduto,
                    r.qtde_dias_ruptura,
                    r.venda_diaria_calc,
                    r.qtde_dias_ruptura::numeric * r.venda_diaria_calc AS valor_ruptura,
                    r.tipo_ruptura,
                    COALESCE(NULLIF(trim(r.nivel_servico), ''), 'NIVEL ORDINARIO') AS nivel_servico,
                    r.data_ruptura,
                    r.media_mensal,
                    r.data_ultima_compra,
                    r.data_ultima_venda,
                    r.produto_eh_combinacao
                FROM (
                        SELECT
                            st.filial,
                            st.idproduto,
                            st.ano,
                            st.mes,
                            st.qtde_dias_ruptura,
                            st.venda_diaria_calc,
                            CASE
                                WHEN (SELECT sg.estoque > sg.esseg
                                FROM saldo_grupos sg
                                WHERE sg.id_grupo = st.id_grupo AND sg.idproduto::text = st.idproduto::text AND sg.data = st.data_ruptura) THEN 'DRP'::text
                                ELSE 'COMPRA'::text
                            END AS tipo_ruptura,
                            st.nivel_servico,
                            st.data_ruptura,
                            st.media_mensal,
                            st.ultima_solicitacao AS data_ultima_compra,
                            st.ult_saida AS data_ultima_venda,
                            false AS produto_eh_combinacao
                        FROM status_produto st
                            JOIN grupo_compras gc ON gc.id = st.id_grupo
                            JOIN grupo_filial gf ON st.id_grupo = gf.id_grupo AND gf.filial = st.filial
                        WHERE
                            gc.grupo_agrega::text = 'N'::text
                            AND (gf.subgrupo IS NULL OR gf.subgrupo = gf.filial)
                            AND st.data_referencia >= data_inicial
                            AND st.qtde_dias_ruptura > 0
                            AND st.venda_diaria_calc > 0::numeric
                            AND ((
                                SELECT COALESCE(sum(sg.estoque), 0::numeric) AS "coalesce"
                                FROM saldo_grupos sg
                                WHERE
                                    sg.id_grupo = st.id_grupo
                                    AND (sg.idproduto::text IN (
                                        SELECT s.id_item_filho
                                        FROM similares s
                                        WHERE s.id_item_pai::text = st.idproduto::text AND s.agregar_estoque::text = 'S'::TEXT
                                    ))
                                    AND sg.data = st.data_referencia
                        )) = 0::numeric
                        AND NOT ((st.idproduto::text, st.id_grupo) IN (
                                SELECT npb.idproduto, npb.grupo
                                FROM notificacao_produtos_blacklist npb
                                WHERE
                                    npb.grupo = st.id_grupo
                                    AND npb.filial = 0
                                    AND npb.data_limite >= CURRENT_DATE
                                    AND npb.deleted_at IS NULL
                            ))
                            AND NOT (st.idproduto::text IN (
                                SELECT DISTINCT spci.idproduto
                                FROM sys_produtos_combinados spc
                                    JOIN sys_produtos_combinados_itens spci ON spci.id_produto_combinado::text = spc.id::text
                                WHERE spc.deleted_at IS NULL
                            ))

                        UNION ALL

                        SELECT
                            st.filial,
                            spc.id AS idproduto,
                            st.ano,
                            st.mes,
                            max(st.qtde_dias_ruptura) AS qtde_dias_ruptura,
                            sum(st.venda_diaria_calc) AS venda_diaria_calc,
                            CASE
                                WHEN ( SELECT sum(sg.estoque) > sum(sg.esseg)
                                FROM saldo_grupos sg
                                WHERE sg.id_grupo = st.id_grupo AND (sg.idproduto::text IN ( SELECT v.idproduto
                                        FROM sys_produtos_combinados_itens v
                                        WHERE v.id_produto_combinado::text = spc.id::text)) AND sg.data = st.data_ruptura) THEN 'DRP'::text
                                ELSE 'COMPRA'::text
                            END AS tipo_ruptura,
                            getnivelservico(COALESCE(((min(substring(st.arvore_decisao, 1, 1)::text) || max(substring(st.arvore_decisao, 2, 1)::TEXT)) || min(substring(st.arvore_decisao, 3, 1)::TEXT)) || min(substring(st.arvore_decisao, 4, 1)::text), 'CX2R'::character varying)) AS nivel_servico,
                            st.data_ruptura,
                            sum(st.media_mensal) AS media_mensal,
                            max(st.ultima_solicitacao) AS data_ultima_compra,
                            max(st.ult_saida) AS data_ultima_venda,
                            true AS produto_eh_combinacao
                        FROM status_produto st
                            JOIN grupo_compras gc ON gc.id = st.id_grupo
                            JOIN grupo_filial gf ON st.id_grupo = gf.id_grupo AND gf.filial = st.filial
                            JOIN sys_produtos_combinados_itens spci ON spci.idproduto::text = st.idproduto::text
                            JOIN sys_produtos_combinados spc ON spc.id::text = spci.id_produto_combinado::text
                        WHERE
                            spc.deleted_at IS NULL
                            AND gc.grupo_agrega::text = 'N'::text
                            AND (gf.subgrupo IS NULL OR gf.subgrupo = gf.filial)
                            AND st.data_referencia >= data_inicial
                            AND st.qtde_dias_ruptura > 0
                            AND st.venda_diaria_calc > 0::numeric
                            AND (
                                SELECT COALESCE(sum(sg.estoque), 0::numeric) = 0::numeric
                                FROM saldo_grupos sg
                                WHERE
                                    sg.id_grupo = st.id_grupo
                                    AND (sg.idproduto::text IN (
                                        SELECT v.idproduto
                                        FROM sys_produtos_combinados_itens v
                                        WHERE v.id_produto_combinado::text = spc.id::TEXT
                                    ))
                                    AND sg.data = st.data_referencia
                            )
                            AND NOT ((spc.id::text, st.id_grupo) IN (
                                SELECT npb.idproduto, npb.grupo
                                FROM notificacao_produtos_blacklist npb
                                WHERE
                                    npb.grupo = st.id_grupo
                                    AND npb.filial IN (0, st.filial)
                                    AND npb.data_limite >= CURRENT_DATE
                                    AND npb.deleted_at IS NULL
                            ))
                        GROUP BY st.id_grupo, st.filial, spc.id, st.ano, st.mes, st.data_ruptura
                ) r
            )
            LOOP
                UPDATE analise_rupturas_produtos_filial
                SET
                    ano = rec_analise.ano,
                    mes = rec_analise.mes,
                    filial = rec_analise.filial,
                    idproduto = rec_analise.idproduto,
                    qtde_dias_ruptura = rec_analise.qtde_dias_ruptura,
                    venda_diaria_calc = rec_analise.venda_diaria_calc,
                    valor_ruptura = rec_analise.valor_ruptura,
                    tipo_ruptura = rec_analise.tipo_ruptura,
                    nivel_servico = rec_analise.nivel_servico,
                    data_ruptura = rec_analise.data_ruptura,
                    media_mensal = rec_analise.media_mensal,
                    data_ultima_compra = rec_analise.data_ultima_compra,
                    data_ultima_venda = rec_analise.data_ultima_venda,
                    produto_eh_combinacao = rec_analise.produto_eh_combinacao,
                    flag = null
                WHERE
                    ano = rec_analise.ano
                    AND mes = rec_analise.mes
                    AND filial = rec_analise.filial
                    AND idproduto = rec_analise.idproduto;

                IF NOT FOUND THEN
                    INSERT INTO analise_rupturas_produtos_filial (
                        ano,
                        mes,
                        filial,
                        idproduto,
                        qtde_dias_ruptura,
                        venda_diaria_calc,
                        valor_ruptura,
                        tipo_ruptura,
                        nivel_servico,
                        data_ruptura,
                        media_mensal,
                        data_ultima_compra,
                        data_ultima_venda,
                        produto_eh_combinacao
                    )
                    VALUES (
                        rec_analise.ano,
                        rec_analise.mes,
                        rec_analise.filial,
                        rec_analise.idproduto,
                        rec_analise.qtde_dias_ruptura,
                        rec_analise.venda_diaria_calc,
                        rec_analise.valor_ruptura,
                        rec_analise.tipo_ruptura,
                        rec_analise.nivel_servico,
                        rec_analise.data_ruptura,
                        rec_analise.media_mensal,
                        rec_analise.data_ultima_compra,
                        rec_analise.data_ultima_venda,
                        rec_analise.produto_eh_combinacao
                    );
                END IF;
            END LOOP;

            DELETE FROM analise_rupturas_produtos_filial WHERE flag = 'D' AND data_ruptura >= data_inicial;

            DELETE FROM analise_rupturas_produtos_filial WHERE idproduto IN (select idproduto from produtos_para_nao_exibir_nos_indicadores);

        END;
    $function$

