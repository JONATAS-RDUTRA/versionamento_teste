CREATE OR REPLACE FUNCTION public.processar_produtos_combinados_compras_grupo(f_id_produto_combinado character varying DEFAULT NULL::character varying)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
        DECLARE rec_forecast record;
    BEGIN
        IF trim(f_id_produto_combinado) = '' THEN
            f_id_produto_combinado = NULL;
        END IF;


        UPDATE produtos_combinados_compras_grupo SET flag = 'D' WHERE (f_id_produto_combinado = id_produto_combinado OR f_id_produto_combinado IS NULL);

        FOR rec_forecast IN (
            SELECT
                lote.id_grupo,
                lote.id_produto_combinado,
                lote.descricao_produto,
                lote.produtos,
                lote.compradores,
                lote.fornecedores,
                lote.familias_produtos,
                lote.secoes,
                lote.revenda,
                lote.status,
                lote.estoque,
                COALESCE(round(lote.estoque / NULLIF(lote.consumo_medio_mensal, 0::numeric) * 30::numeric, 4), 0::numeric) AS cobertura_estoque,
                lote.estoque_seguranca,
                lote.ponto_pedido,
                lote.estoque_maximo,
                lote.consumo_medio_mensal,
                lote.desvio_padrao_consumo,
                lote.tempo_medio_ressuprimento,
                lote.tempo_ressuprimento,
                lote.desvio_padrao_ressuprimento,
                lote.coeficiente_variacao,
                lote.compra_transito,
                lote.lote_minimo,
                lote.lote_compras_bruto,
                lote.arvore_decisao,
                lote.nivel_servico,
                lote.peso_compras,
                lote.unidade_compra,
                lote.lote_embalagem,
                CASE
                    WHEN lote.flag_sob_encomenda = 'S'::text THEN 1
                    -- WHEN lote.lote_compras_bruto > 0::numeric AND lote.lote_embalagem = 0::numeric THEN 1 -- OCTADESK99905315
                    ELSE 0
                END AS sob_encomenda,
                CASE
                    WHEN lote.lote_embalagem > 0::numeric AND COALESCE(round(lote.estoque / NULLIF(lote.consumo_medio_mensal, 0::numeric), 4), 0::numeric) < lote.tempo_ressuprimento AND lote.compra_transito = 0::numeric THEN gerar_lote_embalagem(lote.estoque_maximo, COALESCE(lote.lote_minimo, 1::numeric))
                    ELSE lote.lote_embalagem
                END AS lote_compras,
                lote.preco_compra,
                lote.custo_unitario,
                lote.valor_unitario,
                lote.estoque_bloqueado,
                CASE
                    WHEN lote.coeficiente_variacao::numeric >= 0::numeric AND lote.coeficiente_variacao::numeric <= 200::numeric THEN 'REPETITIVO'::text
                    WHEN lote.coeficiente_variacao::numeric > 200::numeric AND lote.coeficiente_variacao::numeric <= 600::numeric THEN 'ESTATISTICO'::text
                    ELSE 'OCASIONAL'::text
                END AS perfil_demanda,
                lote.tempo_medio_apanhe,
                lote.embalagem,
                lote.idunidade_medida,
                lote.ressuprimento_manual,
                lote.ressuprimento_manual_dias,
                lote.cod_produto,
                lote.codigo_barras,
                lote.fator_conversao,
                lote.fator_atuacao,
                lote.projecao_rentabilidade,
                lote.estoque_avaria,
                lote.peso,
                lote.altura,
                lote.largura,
                lote.comprimento,
                (
                    SELECT max(r.data_solicitacao) AS max
                    FROM requisicoes r
                    WHERE
                        (r.idproduto::text = ANY (lote.produtos::text[]))
                        AND (r.idfilial IN (SELECT gf.filial FROM grupo_filial gf WHERE gf.id_grupo = lote.id_grupo))
                ) AS data_ultima_requisicao,
                lote.estoque_reservado,
                lote.multiplo_compra::numeric(12,6) AS multiplo_compra,
                lote.unidade_master,
                lote.tipo_fator_conversao,
                lote.compra_transito_entregue,
                lote.detalhamento_tecnico,
                lote.estoque_minimo,
                lote.classificacao_rentabilidade,
                lote.estoque_seguranca_estetico,
                lote.ponto_pedido_estetico,
                lote.ponto_pedido_estetico + lote.consumo_medio_mensal AS estoque_maximo_estetico
                FROM (
                    SELECT
                        a.id_grupo,
                        a.id_produto_combinado,
                        a.descricao_produto,
                        a.produtos,
                        a.compradores,
                        a.fornecedores,
                        a.familias_produtos,
                        a.secoes,
                        a.revenda,
                        a.status,
                        a.estoque,
                        a.estoque_seguranca,
                        a.ponto_pedido,
                        a.estoque_maximo,
                        a.consumo_medio_mensal,
                        a.desvio_padrao_consumo,
                        a.tempo_medio_ressuprimento,
                        a.tempo_ressuprimento,
                        a.desvio_padrao_ressuprimento,
                        a.coeficiente_variacao,
                        a.compra_transito,
                        a.lote_minimo,
                        CASE
                            WHEN a.coeficiente_variacao::numeric >= 0::numeric AND a.compra_transito = 0::numeric AND a.estoque <= a.ponto_pedido AND a.revenda = 'S'::text AND a.status <> 'FL'::text THEN round(a.estoque_maximo + a.consumo_medio_mensal * (a.tempo_ressuprimento + a.desvio_padrao_ressuprimento) - a.estoque, 2)
                            WHEN a.coeficiente_variacao::numeric = 0::numeric AND a.compra_transito = 0::numeric AND a.estoque <= a.ponto_pedido AND a.revenda = 'S'::text AND a.status <> 'FL'::text THEN ceil(a.consumo_medio_mensal / 2::numeric)
                            ELSE 0::numeric
                        END AS lote_compras_bruto,
                        a.arvore_decisao,
                        a.nivel_servico,
                        a.peso_compras,
                        a.unidade_compra,
                        gerar_lote_embalagem(
                        CASE
                            WHEN a.coeficiente_variacao::numeric >= 0::numeric AND a.compra_transito = 0::numeric AND a.estoque <= a.ponto_pedido AND a.revenda = 'S'::text AND a.status <> 'FL'::text THEN round(a.estoque_maximo + a.consumo_medio_mensal * (a.tempo_ressuprimento + a.desvio_padrao_ressuprimento) - a.estoque, 2)
                            WHEN a.coeficiente_variacao::numeric = 0::numeric AND a.compra_transito = 0::numeric AND a.estoque <= a.ponto_pedido AND a.revenda = 'S'::text AND a.status <> 'FL'::text THEN ceil(a.consumo_medio_mensal / 2::numeric)
                            ELSE 0::numeric
                        END, COALESCE(a.lote_minimo, 1::numeric)) AS lote_embalagem,
                        a.preco_compra,
                        a.custo_unitario,
                        a.valor_unitario,
                        a.estoque_bloqueado,
                        a.tempo_medio_apanhe,
                        a.embalagem,
                        a.idunidade_medida,
                        a.ressuprimento_manual,
                        a.ressuprimento_manual_dias,
                        a.cod_produto,
                        a.codigo_barras,
                        a.fator_conversao,
                        a.fator_atuacao,
                        a.projecao_rentabilidade,
                        a.estoque_avaria,
                        a.peso,
                        a.altura,
                        a.largura,
                        a.comprimento,
                        a.flag_sob_encomenda,
                        a.estoque_reservado,
                        a.multiplo_compra,
                        a.unidade_master,
                        a.tipo_fator_conversao,
                        a.compra_transito_entregue,
                        a.detalhamento_tecnico,
                        a.estoque_minimo,
                        a.classificacao_rentabilidade,
                        a.estoque_seguranca_estetico,
                        a.estoque_seguranca_estetico + a.consumo_medio_mensal / 30::numeric * a.tempo_medio_ressuprimento AS ponto_pedido_estetico
                    FROM (
                        SELECT
                            v.id_grupo,
                            v.id_produto_combinado,
                            v.descricao_produto,
                            v.produtos,
                            v.compradores,
                            v.fornecedores,
                            v.familias_produtos,
                            v.secoes,
                            v.revenda,
                            v.status,
                            v.unidade_compra,
                            v.estoque,
                            CASE
                                WHEN v.qtde_dias_cobertura_eseg > 0::numeric THEN v.consumo_medio_mensal / 30::numeric * v.qtde_dias_cobertura_eseg
                                ELSE v.estoque_seguranca
                            END AS estoque_seguranca,
                            CASE
                                WHEN v.qtde_dias_cobertura_eseg > 0::numeric THEN round(v.consumo_medio_mensal / 30::numeric * v.qtde_dias_cobertura_eseg + v.consumo_medio_mensal * (v.tempo_ressuprimento + v.desvio_padrao_ressuprimento), 2)
                                ELSE v.ponto_pedido
                            END AS ponto_pedido,
                            CASE
                                WHEN v.qtde_dias_cobertura_emax > 0::numeric THEN v.consumo_medio_mensal / 30::numeric * v.qtde_dias_cobertura_emax
                                ELSE v.estoque_maximo
                            END AS estoque_maximo,
                            v.consumo_medio_mensal,
                            v.desvio_padrao_consumo,
                            v.tempo_medio_ressuprimento,
                            v.tempo_ressuprimento,
                            v.desvio_padrao_ressuprimento,
                            v.coeficiente_variacao,
                            v.compra_transito,
                            v.lote_minimo,
                            v.arvore_decisao,
                            v.nivel_servico,
                            v.peso_compras,
                            v.preco_compra,
                            v.custo_unitario,
                            v.valor_unitario,
                            v.estoque_bloqueado,
                            v.tempo_medio_apanhe,
                            v.embalagem,
                            v.idunidade_medida,
                            v.ressuprimento_manual,
                            v.ressuprimento_manual_dias,
                            v.cod_produto,
                            v.codigo_barras,
                            v.fator_conversao,
                            v.fator_atuacao,
                            v.projecao_rentabilidade,
                            v.estoque_avaria,
                            v.peso,
                            v.altura,
                            v.largura,
                            v.comprimento,
                            v.flag_sob_encomenda,
                            v.estoque_reservado,
                            v.multiplo_compra,
                            v.unidade_master,
                            v.tipo_fator_conversao,
                            v.compra_transito_entregue,
                            v.detalhamento_tecnico,
                            v.estoque_minimo,
                            v.classificacao_rentabilidade,
                            v.estoque_seguranca_estetico
                        FROM (
                            WITH prismas AS (
                                SELECT
                                    gf.id_grupo,
                                    spci_1.id_produto_combinado,
                                    (
                                        (
                                            min(pf.classificacao_financeira::text) || max(pf.classificacao_criticidade::text)
                                        ) || min(pf.classificacao_comprabilidade)
                                    ) || min(pf.classificacao_popularidade::text) AS arvore_decisao
                                FROM produtos_filial pf
                                    JOIN grupo_filial gf ON gf.filial = pf.filial
                                    JOIN sys_produtos_combinados_itens spci_1 ON spci_1.idproduto::text = pf.idproduto::text
                                WHERE pf.processar_analise::text = 'S'::text
                                GROUP BY gf.id_grupo, spci_1.id_produto_combinado
                            ),
                            compras_pendentes_com_entrega AS (
                                SELECT
                                    gf.id_grupo,
                                    spci_1.id_produto_combinado,
                                    sum(r.qtde_entregue / spci_1.fator_conversao::double precision) AS compra_transito_entregue
                                FROM requisicoes r
                                    JOIN grupo_filial gf ON gf.filial = r.idfilial
                                    JOIN sys_produtos_combinados_itens spci_1 ON spci_1.idproduto::text = r.idproduto::text
                                WHERE r.qtde_pendente > 0::double precision AND r.qtde_entregue > 0::double precision
                                GROUP BY gf.id_grupo, spci_1.id_produto_combinado
                            )
                            SELECT
                                g.id_grupo,
                                spci.id_produto_combinado,
                                spc.descricao AS descricao_produto,
                                array_agg(DISTINCT p.idproduto) AS produtos,
                                array_agg(DISTINCT p.idcomprador) AS compradores,
                                array_agg(DISTINCT p.idfornecedor) AS fornecedores,
                                array_agg(DISTINCT p.idfamilia_produto) AS familias_produtos,
                                array_agg(DISTINCT p.idsecao) AS secoes,
                                max(p.revenda::text) AS revenda,
                                min(p.status::text) AS status,
                                max(p.unidade_compra::text) AS unidade_compra,
                                (sum((p.estoque - COALESCE(p.estoque_similar, 0)) / spci.fator_conversao) + get_estoque_similar_produto_combinado(g.id_grupo::int, 0, spci.id_produto_combinado)) AS estoque,
                                sum(p.estoque_seguranca / spci.fator_conversao) AS estoque_seguranca,
                                sum(p.ponto_pedido / spci.fator_conversao) AS ponto_pedido,
                                sum(p.estoque_maximo / spci.fator_conversao) AS estoque_maximo,
                                (sum(p.consumo_medio_mensal / spci.fator_conversao) + (get_cmm_heranca_produto_combinado(g.id_grupo::int, spci.id_produto_combinado) * avg(p.fator_atuacao))) AS consumo_medio_mensal,
                                sum(p.desvio_padrao_consumo / spci.fator_conversao) AS desvio_padrao_consumo,
                                avg(p.tempo_medio_ressuprimento) AS tempo_medio_ressuprimento,
                                avg(p.tempo_ressuprimento) AS tempo_ressuprimento,
                                avg(p.desvio_padrao_ressuprimento) AS desvio_padrao_ressuprimento,
                                COALESCE(sum(p.desvio_padrao_consumo / spci.fator_conversao) / NULLIF((sum(p.consumo_medio_mensal / spci.fator_conversao) + (get_cmm_heranca_produto_combinado(g.id_grupo::int, spci.id_produto_combinado) * avg(p.fator_atuacao))), 0::numeric) * 100::numeric, 0::numeric)::text AS coeficiente_variacao,
                                sum(getcompra_transito_filial(p.filial::numeric, p.idproduto) / spci.fator_conversao) AS compra_transito,
                                trunc(max(p.lote_minimo / spci.fator_conversao), 4) AS lote_minimo,
                                COALESCE(pm.arvore_decisao, 'CX2R'::text) AS arvore_decisao,
                                getnivelservico(COALESCE(pm.arvore_decisao::character varying, 'CX2R'::character varying)) AS nivel_servico,
                                getpesocompras(COALESCE(pm.arvore_decisao::character varying, 'CX2R'::character varying), "substring"(COALESCE(pm.arvore_decisao::character varying, 'CX2R'::character varying)::text, 3, 1)::numeric) AS peso_compras,
                                COALESCE(avg(NULLIF(p.preco_compra, 0::numeric) * spci.fator_conversao), 0::numeric) AS preco_compra,
                                COALESCE(avg(NULLIF(p.custo_unitario, 0::numeric) * spci.fator_conversao), 0::numeric) AS custo_unitario,
                                COALESCE(avg(NULLIF(p.valor_unitario, 0::numeric) * spci.fator_conversao), 0::numeric) AS valor_unitario,
                                sum(p.estoque_bloqueado / spci.fator_conversao) AS estoque_bloqueado,
                                sum(p.tempo_medio_apanhe) AS tempo_medio_apanhe,
                                max(p.embalagem::text) AS embalagem,
                                max(p.idunidade_medida::text) AS idunidade_medida,
                                max(p.ressuprimento_manual::text)::character varying(1) AS ressuprimento_manual,
                                max(COALESCE(p.ressuprimento_manual_dias, 0::numeric)) AS ressuprimento_manual_dias,
                                ''::text AS cod_produto,
                                max(p.codigo_barras::text)::character varying(25) AS codigo_barras,
                                1 AS fator_conversao,
                                avg(p.fator_atuacao) AS fator_atuacao,
                                sum(p.projecao_rentabilidade) AS projecao_rentabilidade,
                                sum(p.estoque_avaria / spci.fator_conversao) AS estoque_avaria,
                                max(p.peso / spci.fator_conversao) AS peso,
                                max(p.altura / spci.fator_conversao) AS altura,
                                max(p.largura / spci.fator_conversao) AS largura,
                                max(p.comprimento / spci.fator_conversao) AS comprimento,
                                max(p.flag_sob_encomenda::text) AS flag_sob_encomenda,
                                sum(COALESCE(p.estoque_reservado, 0::numeric) / spci.fator_conversao) AS estoque_reservado,
                                max(p.multiplo_compra) AS multiplo_compra,
                                max(p.unidade_master::text) AS unidade_master,
                                'D'::text AS tipo_fator_conversao,
                                COALESCE(cpce.compra_transito_entregue, 0::double precision) AS compra_transito_entregue,
                                max(p.detalhamento_tecnico) AS detalhamento_tecnico,
                                sum(p.estoque_minimo / spci.fator_conversao) AS estoque_minimo,
                                min(p.classificacao_rentabilidade::text) AS classificacao_rentabilidade,
                                sum(p.estoque_minimo / spci.fator_conversao) AS estoque_seguranca_estetico,
                                COALESCE(
                                    (
                                        SELECT NULLIF(tccp.tempo_cobertura_esseg, 0) AS x
                                        FROM tempo_cobertura_compras_produtos tccp
                                        WHERE tccp.idproduto::text = spc.id::TEXT
                                    ), (
                                        SELECT NULLIF(tcc.tempo_cobertura_esseg, 0) AS x
                                        FROM tempo_cobertura_compras tcc
                                        WHERE
                                            tcc.id_grupo = g.id_grupo
                                            AND tcc.pqr::text = min("substring"(p.arvore_decisao::text, 4, 1))
                                            AND tcc.xyz::text = min("substring"(p.arvore_decisao::text, 2, 1))
                                        LIMIT 1
                                    ), 0
                                )::numeric AS qtde_dias_cobertura_eseg,
                                COALESCE(
                                    (
                                        SELECT NULLIF(tccp.tempo_cobertura, 0) AS x
                                        FROM tempo_cobertura_compras_produtos tccp
                                        WHERE tccp.idproduto::text = spc.id::TEXT
                                    ), (
                                        SELECT NULLIF(tcc.tempo_cobertura, 0) AS x
                                        FROM tempo_cobertura_compras tcc
                                        WHERE
                                            tcc.id_grupo = g.id_grupo
                                            AND tcc.pqr::text = min("substring"(p.arvore_decisao::text, 4, 1))
                                            AND tcc.xyz::text = min("substring"(p.arvore_decisao::text, 2, 1))
                                        LIMIT 1
                                    ), 0::bigint
                               )::numeric AS qtde_dias_cobertura_emax
                            FROM produtos_filial p
                                JOIN grupo_filial g ON p.filial = g.filial
                                JOIN sys_produtos_combinados_itens spci ON spci.idproduto::text = p.idproduto::text
                                JOIN sys_produtos_combinados spc ON spc.id::text = spci.id_produto_combinado::text
                                LEFT JOIN prismas pm ON pm.id_grupo = g.id_grupo AND pm.id_produto_combinado::text = spci.id_produto_combinado::text
                                LEFT JOIN compras_pendentes_com_entrega cpce ON cpce.id_grupo = g.id_grupo AND cpce.id_produto_combinado::text = spci.id_produto_combinado::text
                            WHERE
                                spc.deleted_at IS NULL
                                AND p.revenda::text = 'S'::text
                                AND p.processar_analise::text = 'S'::TEXT
                                AND (f_id_produto_combinado = spc.id OR f_id_produto_combinado IS NULL)
                            GROUP BY g.id_grupo, spc.id, spci.id_produto_combinado, pm.arvore_decisao, cpce.compra_transito_entregue
                        ) v
                    ) a
                ) lote
        )
        LOOP
            -- UPDATE
            UPDATE produtos_combinados_compras_grupo
            SET
                id_grupo = rec_forecast.id_grupo,
                id_produto_combinado = rec_forecast.id_produto_combinado,
                descricao_produto = rec_forecast.descricao_produto,
                produtos = rec_forecast.produtos,
                compradores = rec_forecast.compradores,
                fornecedores = rec_forecast.fornecedores,
                familias_produtos = rec_forecast.familias_produtos,
                secoes = rec_forecast.secoes,
                revenda = rec_forecast.revenda,
                status = rec_forecast.status,
                estoque = rec_forecast.estoque,
                cobertura_estoque = rec_forecast.cobertura_estoque,
                estoque_seguranca = rec_forecast.estoque_seguranca,
                ponto_pedido = rec_forecast.ponto_pedido,
                estoque_maximo = rec_forecast.estoque_maximo,
                consumo_medio_mensal = rec_forecast.consumo_medio_mensal,
                desvio_padrao_consumo = rec_forecast.desvio_padrao_consumo,
                tempo_medio_ressuprimento = rec_forecast.tempo_medio_ressuprimento,
                tempo_ressuprimento = rec_forecast.tempo_ressuprimento,
                desvio_padrao_ressuprimento = rec_forecast.desvio_padrao_ressuprimento,
                coeficiente_variacao = rec_forecast.coeficiente_variacao,
                compra_transito = rec_forecast.compra_transito,
                lote_minimo = rec_forecast.lote_minimo,
                lote_compras_bruto = rec_forecast.lote_compras_bruto,
                arvore_decisao = rec_forecast.arvore_decisao,
                nivel_servico = rec_forecast.nivel_servico,
                peso_compras = rec_forecast.peso_compras,
                unidade_compra = rec_forecast.unidade_compra,
                lote_embalagem = rec_forecast.lote_embalagem,
                sob_encomenda = rec_forecast.sob_encomenda,
                lote_compras = rec_forecast.lote_compras,
                preco_compra = rec_forecast.preco_compra,
                custo_unitario = rec_forecast.custo_unitario,
                valor_unitario = rec_forecast.valor_unitario,
                estoque_bloqueado = rec_forecast.estoque_bloqueado,
                perfil_demanda = rec_forecast.perfil_demanda,
                tempo_medio_apanhe = rec_forecast.tempo_medio_apanhe,
                embalagem = rec_forecast.embalagem,
                idunidade_medida = rec_forecast.idunidade_medida,
                ressuprimento_manual = rec_forecast.ressuprimento_manual,
                ressuprimento_manual_dias = rec_forecast.ressuprimento_manual_dias,
                cod_produto = rec_forecast.cod_produto,
                codigo_barras = rec_forecast.codigo_barras,
                fator_conversao = rec_forecast.fator_conversao,
                fator_atuacao = rec_forecast.fator_atuacao,
                projecao_rentabilidade = rec_forecast.projecao_rentabilidade,
                estoque_avaria = rec_forecast.estoque_avaria,
                peso = rec_forecast.peso,
                altura = rec_forecast.altura,
                largura = rec_forecast.largura,
                comprimento = rec_forecast.comprimento,
                data_ultima_requisicao = rec_forecast.data_ultima_requisicao,
                estoque_reservado = rec_forecast.estoque_reservado,
                multiplo_compra = rec_forecast.multiplo_compra,
                unidade_master = rec_forecast.unidade_master,
                tipo_fator_conversao = rec_forecast.tipo_fator_conversao,
                compra_transito_entregue = rec_forecast.compra_transito_entregue,
                detalhamento_tecnico = rec_forecast.detalhamento_tecnico,
                estoque_minimo = rec_forecast.estoque_minimo,
                classificacao_rentabilidade = rec_forecast.classificacao_rentabilidade,
                estoque_seguranca_estetico = rec_forecast.estoque_seguranca_estetico,
                ponto_pedido_estetico = rec_forecast.ponto_pedido_estetico,
                estoque_maximo_estetico = rec_forecast.estoque_maximo_estetico,
                flag = NULL
            WHERE
                id_grupo = rec_forecast.id_grupo
                AND id_produto_combinado = rec_forecast.id_produto_combinado;

            IF NOT FOUND THEN
                INSERT INTO produtos_combinados_compras_grupo (
                    id_grupo,
                    id_produto_combinado,
                    descricao_produto,
                    produtos,
                    compradores,
                    fornecedores,
                    familias_produtos,
                    secoes,
                    revenda,
                    status,
                    estoque,
                    cobertura_estoque,
                    estoque_seguranca,
                    ponto_pedido,
                    estoque_maximo,
                    consumo_medio_mensal,
                    desvio_padrao_consumo,
                    tempo_medio_ressuprimento,
                    tempo_ressuprimento,
                    desvio_padrao_ressuprimento,
                    coeficiente_variacao,
                    compra_transito,
                    lote_minimo,
                    lote_compras_bruto,
                    arvore_decisao,
                    nivel_servico,
                    peso_compras,
                    unidade_compra,
                    lote_embalagem,
                    sob_encomenda,
                    lote_compras,
                    preco_compra,
                    custo_unitario,
                    valor_unitario,
                    estoque_bloqueado,
                    perfil_demanda,
                    tempo_medio_apanhe,
                    embalagem,
                    idunidade_medida,
                    ressuprimento_manual,
                    ressuprimento_manual_dias,
                    cod_produto,
                    codigo_barras,
                    fator_conversao,
                    fator_atuacao,
                    projecao_rentabilidade,
                    estoque_avaria,
                    peso,
                    altura,
                    largura,
                    comprimento,
                    data_ultima_requisicao,
                    estoque_reservado,
                    multiplo_compra,
                    unidade_master,
                    tipo_fator_conversao,
                    compra_transito_entregue,
                    detalhamento_tecnico,
                    estoque_minimo,
                    classificacao_rentabilidade,
                    estoque_seguranca_estetico,
                    ponto_pedido_estetico,
                    estoque_maximo_estetico,
                    flag
                ) VALUES (
                    rec_forecast.id_grupo,
                    rec_forecast.id_produto_combinado,
                    rec_forecast.descricao_produto,
                    rec_forecast.produtos,
                    rec_forecast.compradores,
                    rec_forecast.fornecedores,
                    rec_forecast.familias_produtos,
                    rec_forecast.secoes,
                    rec_forecast.revenda,
                    rec_forecast.status,
                    rec_forecast.estoque,
                    rec_forecast.cobertura_estoque,
                    rec_forecast.estoque_seguranca,
                    rec_forecast.ponto_pedido,
                    rec_forecast.estoque_maximo,
                    rec_forecast.consumo_medio_mensal,
                    rec_forecast.desvio_padrao_consumo,
                    rec_forecast.tempo_medio_ressuprimento,
                    rec_forecast.tempo_ressuprimento,
                    rec_forecast.desvio_padrao_ressuprimento,
                    rec_forecast.coeficiente_variacao,
                    rec_forecast.compra_transito,
                    rec_forecast.lote_minimo,
                    rec_forecast.lote_compras_bruto,
                    rec_forecast.arvore_decisao,
                    rec_forecast.nivel_servico,
                    rec_forecast.peso_compras,
                    rec_forecast.unidade_compra,
                    rec_forecast.lote_embalagem,
                    rec_forecast.sob_encomenda,
                    rec_forecast.lote_compras,
                    rec_forecast.preco_compra,
                    rec_forecast.custo_unitario,
                    rec_forecast.valor_unitario,
                    rec_forecast.estoque_bloqueado,
                    rec_forecast.perfil_demanda,
                    rec_forecast.tempo_medio_apanhe,
                    rec_forecast.embalagem,
                    rec_forecast.idunidade_medida,
                    rec_forecast.ressuprimento_manual,
                    rec_forecast.ressuprimento_manual_dias,
                    rec_forecast.cod_produto,
                    rec_forecast.codigo_barras,
                    rec_forecast.fator_conversao,
                    rec_forecast.fator_atuacao,
                    rec_forecast.projecao_rentabilidade,
                    rec_forecast.estoque_avaria,
                    rec_forecast.peso,
                    rec_forecast.altura,
                    rec_forecast.largura,
                    rec_forecast.comprimento,
                    rec_forecast.data_ultima_requisicao,
                    rec_forecast.estoque_reservado,
                    rec_forecast.multiplo_compra,
                    rec_forecast.unidade_master,
                    rec_forecast.tipo_fator_conversao,
                    rec_forecast.compra_transito_entregue,
                    rec_forecast.detalhamento_tecnico,
                    rec_forecast.estoque_minimo,
                    rec_forecast.classificacao_rentabilidade,
                    rec_forecast.estoque_seguranca_estetico,
                    rec_forecast.ponto_pedido_estetico,
                    rec_forecast.estoque_maximo_estetico,
                    NULL
                );
            END IF;
        END LOOP;

        DELETE FROM produtos_combinados_compras_grupo WHERE flag = 'D';
    END $function$

