CREATE OR REPLACE FUNCTION public.processar_analise_diagnostico_estoque_filial()
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
    rec_produto record;
begin
    
    update analise_diagnostico_estoque_filial set flag = 'D';
    
    FOR rec_produto IN (
        with ultimas_saidas as (
            SELECT
                c.filial,
                c.idproduto,
                max(c.emissao) as ult_saida
            from consumos c
            group by c.filial, c.idproduto
        ),
        ultimas_e_primeiras_entradas_produto AS (
            SELECT 
                em.idfilial AS filial,
                em.idproduto,
                min(em.data_entrada) AS data_primeira_entrada,
                max(em.data_entrada) AS data_ultima_entrada 
            FROM entrada_mercadorias em 
                INNER JOIN grupo_filial gf ON gf.filial = em.idfilial 
            GROUP BY em.idfilial, em.idproduto
        ),
        pedidos_em_aberto as (
            SELECT
                r.idfilial AS filial,
                r.idproduto,
                string_agg(r.id_solicitacao::TEXT, ',') AS id_solicitacao,
                min(r.data_solicitacao) AS data_solicitacao,
                min(r.data_previsao) AS data_previsao,
                sum(r.qtde_pendente)::NUMERIC as estoque_transito
            from requisicoes r
            where r.qtde_pendente > 0
            group by r.idfilial, r.idproduto
        ),
        produtos_classificados AS (
            SELECT 
                pf.*,
                CASE
                    WHEN (pf.tempo_medio_apanhe = 0 OR (current_date - pf.data_ult_saida) > 180) THEN 'S'
                    ELSE substring(pf.arvore_decisao, 4, 1)
                END AS classificacao_popularidade,
                CASE
                    WHEN (pf.tempo_medio_apanhe = 0 OR (current_date - pf.data_ult_saida) > 180) THEN 'W'
                    ELSE substring(pf.arvore_decisao, 2, 1)
                END AS classificacao_criticidade
            FROM (
                SELECT
                    pf.filial,
                    d.iddepartamento AS idsegmento,
                    trim(d.descricao_departamento) AS descricao_segmento,
                    s.idsecao,
                    s.descricao_secao,
                    pf.idcomprador,
                    c2.nome_completo AS descricao_comprador,
                    f.id AS idfornecedor,
                    trim(f.razao_social) AS descricao_fornecedor,
                    pf.idproduto,
                    pf.cod_produto,
                    trim(pf.descricao_produto) AS descricao_produto,
                    pf.data_cadastro,
                    pf.custo_unitario AS preco_custo,
                    pf.valor_unitario AS preco_venda,
                    us.ult_saida AS data_ult_saida,
                    (current_date - us.ult_saida) AS qtde_dias_sem_vender,
                    GREATEST(pf.estoque - pf.estoque_similar, 0) AS estoque,
                    pf.estoque_seguranca AS esseg,
                    pf.ponto_pedido AS pp,
                    pf.estoque_maximo AS emax,
                    pf.consumo_medio_mensal,
                    (pf.consumo_medio_mensal / 30) AS consumo_medio_diario,
                    substring(arvore_decisao, 1, 1) AS classificacao_financeira,
                    substring(arvore_decisao, 3, 1) AS classificacao_comprabilidade,
                    arvore_decisao,
                    pf.nivel_servico,
                    CASE 
                        WHEN length(pf.heranca) > 0 AND (current_date - pf.cadastro_heranca) <= 60 THEN pf.tempo_medio_apanhe + (SELECT COALESCE(pf1.tempo_medio_apanhe, 0) FROM produtos_filial pf1 WHERE pf1.idproduto = pf.heranca AND pf1.filial = pf.filial)
                        ELSE pf.tempo_medio_apanhe
                    END AS tempo_medio_apanhe,
                    COALESCE(pt.estoque_transito, 0) AS estoque_transito,
                    pt.id_solicitacao,
                    pt.data_solicitacao,
                    pt.data_previsao,
                    CASE
                        WHEN pf.revenda = 'S' THEN 'SIM'
                        ELSE 'NAO'
                    END AS ativo_para_venda,
                    CASE
                        WHEN pf.status = 'FL' THEN 'SIM'
                        ELSE 'NAO'
                    END AS fora_de_linha,
                    pf.tempo_ressuprimento AS tempo_ressuprimento_meses,
                    pf.tempo_medio_ressuprimento AS tempo_ressuprimento_dias,
                    COALESCE(round((pf.estoque_maximo / NULLIF(pf.consumo_medio_mensal, 0) * 30)), 0) AS cobertura_emax, -- cobertura systock
                    COALESCE(pf.estoque_maximo * pf.custo_unitario, 0) AS emax_em_preco_custo, -- saldo de estoque systock
                    GREATEST(ceil((GREATEST(pf.estoque - pf.estoque_similar, 0) / NULLIF(pf.consumo_medio_mensal, 0) * 30)), 0) AS cobertura_estoque,
                    coalesce(GREATEST(pf.estoque - pf.estoque_similar, 0) * pf.custo_unitario, 0) AS estoque_em_preco_custo,
                    coalesce(GREATEST(pf.estoque - pf.estoque_similar, 0) * pf.valor_unitario, 0) AS estoque_em_preco_venda,
                    coalesce(pf.consumo_medio_mensal * pf.preco_medio_venda, 0) AS cmm_em_preco_venda,
                    coalesce(pf.consumo_medio_mensal * pf.custo_unitario, 0) AS cmm_em_preco_custo,
                    GREATEST(GREATEST(pf.estoque - pf.estoque_similar, 0) - pf.estoque_maximo, 0) AS estoque_em_excesso,
                    COALESCE(GREATEST(GREATEST(pf.estoque - pf.estoque_similar, 0) - pf.estoque_maximo, 0) * pf.custo_unitario, 0) AS estoque_em_excesso_em_preco_custo,
                    current_date AS data_analise_demanda_real,
                    COALESCE(w1.sugestao, 0) AS sugestao_compra,
                    COALESCE(w1.sugestao * pf.custo_unitario, 0) AS sugestao_compra_preco_custo,
                    upe.data_primeira_entrada,
                    upe.data_ultima_entrada,
                    pf.estoque_minimo,
                    verificar_cobertura_personalizada_produto_filial(pf.filial::INT, pf.idproduto) AS cobertura_personalizada_ativa,
                    pf.classificacao_rentabilidade
                FROM produtos_filial pf
                    INNER JOIN fornecedor f ON f.id = pf.idfornecedor
                    INNER JOIN departamentos d ON d.iddepartamento = pf.idfamilia_produto
                    LEFT JOIN secao s ON s.idsecao::TEXT = pf.idsecao::TEXT
                    LEFT JOIN comprador c2 ON c2.id = pf.idcomprador 
                    LEFT JOIN vw_lista_compras_dinamica_grupo_filial w1 ON w1.filial = pf.filial AND w1.idproduto = pf.idproduto
                    LEFT JOIN ultimas_saidas us ON us.filial = pf.filial AND us.idproduto = pf.idproduto
                    LEFT JOIN pedidos_em_aberto pt ON pt.filial = pf.filial AND pt.idproduto = pf.idproduto
                    LEFT JOIN ultimas_e_primeiras_entradas_produto upe ON upe.filial = pf.filial AND upe.idproduto = pf.idproduto
                WHERE pf.idproduto NOT IN (SELECT pd.idproduto FROM produtos_desconsiderados_analise_diagnostico_estoque pd)
            ) AS pf
        ),
        v1 AS (
            SELECT 
                v1.filial,
                0 AS idsegmento,
                'COMBINADOS'::TEXT AS descricao_segmento,
                0 AS idsecao,
                'COMBINADOS'::TEXT AS descricao_secao,
                max(v1.idcomprador) AS idcomprador,
                max(v1.descricao_comprador) AS descricao_comprador,
                max(v1.idfornecedor) AS idfornecedor,
                max(v1.descricao_fornecedor) AS descricao_fornecedor,
                spc.id::TEXT AS idproduto,
                NULL AS cod_produto,
                spc.descricao AS descricao_produto,
                min(v1.data_cadastro) AS data_cadastro,
                avg(v1.preco_custo) AS preco_custo,
                avg(v1.preco_venda) AS preco_venda,
                max(v1.data_ult_saida) AS data_ult_saida,
                min(v1.qtde_dias_sem_vender) AS qtde_dias_sem_vender,
                sum(v1.estoque) AS estoque,
                sum(v1.esseg) AS esseg,
                sum(v1.pp) AS pp,
                sum(v1.emax) AS emax,
                sum(v1.consumo_medio_mensal) AS consumo_medio_mensal,
                sum(v1.consumo_medio_diario) AS consumo_medio_diario,
                min(v1.classificacao_financeira::text) AS classificacao_financeira,
                min(v1.classificacao_comprabilidade) AS classificacao_comprabilidade,
                getnivelservico(COALESCE(((min(v1.classificacao_financeira::text) || max(v1.classificacao_criticidade::text)) || min(v1.classificacao_comprabilidade)) || min(v1.classificacao_popularidade::text), 'CX2R'::character varying)) AS nivel_servico,
                sum(v1.tempo_medio_apanhe) AS tempo_medio_apanhe,
                sum(v1.estoque_transito) AS estoque_transito,
                string_agg(v1.id_solicitacao::TEXT, ',') AS id_solicitacao,
                min(v1.data_solicitacao) AS data_solicitacao,
                min(v1.data_previsao) AS data_previsao,
                max(v1.ativo_para_venda) AS ativo_para_venda,
                max(v1.fora_de_linha) AS fora_de_linha,
                avg(v1.tempo_ressuprimento_meses) AS tempo_ressuprimento_meses,
                avg(v1.tempo_ressuprimento_dias) AS tempo_ressuprimento_dias,
                avg(v1.cobertura_emax) AS cobertura_emax,
                sum(v1.emax_em_preco_custo) AS emax_em_preco_custo,
                avg(v1.cobertura_estoque) AS cobertura_estoque,
                sum(v1.estoque_em_preco_custo) AS estoque_em_preco_custo,
                sum(v1.estoque_em_preco_venda) AS estoque_em_preco_venda,
                sum(v1.cmm_em_preco_venda) AS cmm_em_preco_venda,
                sum(v1.cmm_em_preco_custo) AS cmm_em_preco_custo,
                sum(v1.estoque_em_excesso) AS estoque_em_excesso,
                sum(v1.estoque_em_excesso_em_preco_custo) AS estoque_em_excesso_em_preco_custo,
                max(v1.data_analise_demanda_real) AS data_analise_demanda_real,
                sum(v1.sugestao_compra) AS sugestao_compra,
                sum(v1.sugestao_compra_preco_custo) AS sugestao_compra_preco_custo,
                min(v1.data_primeira_entrada) AS data_primeira_entrada,
                max(v1.data_ultima_entrada) AS data_ultima_entrada,
                sum(v1.estoque_minimo) AS estoque_minimo,
                FALSE AS cobertura_personalizada_ativa,
                min(v1.classificacao_rentabilidade) AS classificacao_rentabilidade,
                min(v1.classificacao_popularidade::text) AS classificacao_popularidade,
                max(v1.classificacao_criticidade::text) AS classificacao_criticidade,
                TRUE AS produto_combinado
            FROM produtos_classificados v1
                INNER JOIN sys_produtos_combinados_itens spci ON spci.idproduto = v1.idproduto
                INNER JOIN sys_produtos_combinados spc ON spc.id = spci.id_produto_combinado
            WHERE 
                spc.deleted_at IS NULL
            GROUP BY 
                v1.filial,
                spc.id
    
            UNION ALL 
            
            SELECT 
                v1.filial, 
                v1.idsegmento, 
                v1.descricao_segmento, 
                v1.idsecao, 
                v1.descricao_secao, 
                v1.idcomprador, 
                v1.descricao_comprador, 
                v1.idfornecedor, 
                v1.descricao_fornecedor, 
                v1.idproduto, 
                v1.cod_produto,
                v1.descricao_produto, 
                v1.data_cadastro, 
                v1.preco_custo, 
                v1.preco_venda, 
                v1.data_ult_saida, 
                v1.qtde_dias_sem_vender, 
                v1.estoque, 
                v1.esseg, 
                v1.pp, 
                v1.emax, 
                v1.consumo_medio_mensal, 
                v1.consumo_medio_diario, 
                v1.classificacao_financeira, 
                v1.classificacao_comprabilidade, 
                v1.nivel_servico, 
                v1.tempo_medio_apanhe, 
                v1.estoque_transito, 
                v1.id_solicitacao, 
                v1.data_solicitacao, 
                v1.data_previsao, 
                v1.ativo_para_venda, 
                v1.fora_de_linha, 
                v1.tempo_ressuprimento_meses, 
                v1.tempo_ressuprimento_dias, 
                v1.cobertura_emax, 
                v1.emax_em_preco_custo, 
                v1.cobertura_estoque, 
                v1.estoque_em_preco_custo, 
                v1.estoque_em_preco_venda, 
                v1.cmm_em_preco_venda, 
                v1.cmm_em_preco_custo, 
                v1.estoque_em_excesso, 
                v1.estoque_em_excesso_em_preco_custo, 
                v1.data_analise_demanda_real, 
                v1.sugestao_compra, 
                v1.sugestao_compra_preco_custo, 
                v1.data_primeira_entrada, 
                v1.data_ultima_entrada, 
                v1.estoque_minimo, 
                v1.cobertura_personalizada_ativa, 
                v1.classificacao_rentabilidade, 
                v1.classificacao_popularidade, 
                v1.classificacao_criticidade,
                FALSE AS produto_combinado
            FROM produtos_classificados v1
        ),
        grupos_intervalo_cobertura AS (
            with grupos_range as (
                select null as intervalo
                union
                select *
                from generate_series(0, 180 + 30, 30) AS s(intervalo)
                order by 1
            )
            SELECT
                CASE
                    WHEN s.intervalo is null THEN (999 * 999 * 999) -- gambiarra para identificar quandor for 'Sem comportamento'
                    WHEN (row_number() over()) = 2 THEN 0.0001
                    ELSE GREATEST(s.intervalo - 30, 0)
                END AS valor_inicial_intervalo,
                concat(
                    (row_number() over() - 1),
                    (CASE
                        WHEN s.intervalo is null THEN '. Sem comportamento'
                        WHEN s.intervalo = 0 THEN '. Rutura'
                        WHEN (row_number() over()) = 2 THEN ('. Menor ou igual a ' || s.intervalo || ' dias')
                        WHEN s.intervalo = (LAST_VALUE(s.intervalo) OVER()) THEN ('. Acima de ' || s.intervalo - 30 || ' dias')
                        ELSE ('. ' || 'Acima de ' || (s.intervalo - 30) || ' e menor ou igual a ' || s.intervalo || ' dias')
                    end)
                ) AS grupo
            FROM grupos_range s
            ORDER BY s.intervalo desc
        ),
        v2 AS (
            SELECT
                v1.*,
                COALESCE((v1.estoque_em_preco_venda / NULLIF(v1.estoque_em_preco_custo, 0)) - 1, 0) AS markup,
                CASE
                    WHEN v1.classificacao_popularidade = 'P' THEN '1. Frequência Alta de Saída'
                    WHEN v1.classificacao_popularidade = 'Q' THEN '2. Frequência Média de Saída'
                    WHEN v1.classificacao_popularidade = 'R' THEN '3. Frequência Baixa de Saída'
                    WHEN v1.classificacao_popularidade = 'S' THEN '4. Frequência Nula de Saída'
                    ELSE ''
                END AS frequencia_saida,
                CASE
                    WHEN v1.classificacao_criticidade = 'Z' THEN '1. Faturamento Elevado'
                    WHEN v1.classificacao_criticidade = 'Y' THEN '2. Faturamento Médio'
                    WHEN v1.classificacao_criticidade = 'X' THEN '3. Faturamento Baixo'
                    WHEN v1.classificacao_criticidade = 'W' THEN '4. Faturamento Nulo'
                    ELSE ''
                END AS faturamento,
                CASE
                    WHEN v1.estoque = 0 THEN '5. Em Ruptura'::text
                    WHEN v1.estoque > v1.emax THEN '1. Excesso'::text
                    WHEN v1.estoque <= v1.emax AND v1.estoque > v1.pp  THEN '2. Adequado'::TEXT
                    WHEN v1.estoque <= v1.pp AND v1.cobertura_estoque >= v1.tempo_ressuprimento_dias THEN '3. Baixa Exposição a Ruptura'::text
                    WHEN v1.estoque <= v1.pp AND v1.cobertura_estoque < v1.tempo_ressuprimento_dias THEN '4. Elevada Exposição a Ruptura'::text
                    ELSE ''
                END AS status_produto,
                (
                    SELECT gic.grupo
                    FROM grupos_intervalo_cobertura gic
                    WHERE
                        gic.valor_inicial_intervalo <= (
                            CASE
                                WHEN v1.consumo_medio_mensal = 0 AND v1.estoque > 0 then (999 * 999 * 999) -- gambiarra para identificar quandor for 'Sem comportamento'
                                ELSE v1.cobertura_estoque
                            END
                        )
                    LIMIT 1
                ) AS grupo_intervalo_cobertura, -- 'Analise Cobertura'
                CASE
                    WHEN v1.qtde_dias_sem_vender IS NULL THEN '0. Sem histórico de vendas'
                    WHEN v1.qtde_dias_sem_vender <= 30 THEN '1. Até 1 mês sem vender'
                    WHEN v1.qtde_dias_sem_vender <= 60 THEN '2. De 1 a 2 meses sem vender'
                    WHEN v1.qtde_dias_sem_vender <= 90 THEN '3. De 2 a 3 meses sem vender'
                    WHEN v1.qtde_dias_sem_vender <= 180 THEN '4. De 3 a 6 meses sem vender'
                    WHEN v1.qtde_dias_sem_vender <= 270 THEN '5. De 6 a 9 meses sem vender'
                    WHEN v1.qtde_dias_sem_vender <= 360 THEN '6. De 9 a 12 meses sem vender'
                    ELSE '7. Acima de 12 meses sem vender'
                END AS histograma,
                CASE
                    WHEN v1.data_cadastro IS NULL THEN '0. Sem data de cadastro'
                    WHEN (current_date - v1.data_cadastro) < 90 THEN '1. Menor que 90 dias'
                    WHEN (current_date - v1.data_cadastro) <= 180 THEN '2. Entre 90 dias a 180 dias'
                    ELSE '3. Acima de 180 dias'
                END AS idade,
                CASE
                    when v1.cobertura_estoque = 0 then null
                    WHEN (v1.cobertura_estoque <= 30) THEN (v1.data_analise_demanda_real + v1.cobertura_estoque::int)
                    ELSE NULL
                END AS data_cobertura_instatanea,
                tc.tempo_cobertura AS qtde_dias_cobertura_parametrizada
            FROM v1
                LEFT JOIN tempo_cobertura_compras_geral tc
                    ON tc.pqr = v1.classificacao_popularidade
                    AND tc.xyz = v1.classificacao_criticidade
                    AND tc.deleted_at IS NULL
        ),
        v3 AS (
            SELECT
                v2.*,
                CASE
                    WHEN (v2.cobertura_estoque = 0 AND v2.data_previsao > (v2.data_analise_demanda_real + 30)) THEN 'DEMANDA REPRIMIDA'
                    WHEN (v2.cobertura_estoque > 30) THEN NULL
                    WHEN (v2.cobertura_estoque < 30 AND v2.data_previsao is null) THEN 'SEM PEDIDO'
                    WHEN (v2.cobertura_estoque <= 30 AND v2.data_previsao is not null AND v2.data_previsao > v2.data_cobertura_instatanea) THEN 'DEMANDA REPRIMIDA'
                    ELSE 'DEMANDA POSITIVADA'
                END AS status_demanda
            FROM v2
        ),
        v4 AS (
            SELECT
                v3.*,
                CASE
                    WHEN (v3.estoque = 0) THEN
                        CASE
                            WHEN (v3.status_demanda = 'SEM PEDIDO') THEN 0 -- estoque zerado e sem pedido em transito, logo a venda é 0
                            WHEN (v3.data_analise_demanda_real > v3.data_previsao) THEN -- pedido esta atrasado
                                CASE
                                    WHEN ((v3.data_analise_demanda_real - v3.data_previsao) > 90) THEN 0 -- se o atrasado for maior que 90 dias, desconsideramos o estoque em transito
                                    ELSE LEAST(v3.estoque_transito, v3.consumo_medio_mensal) -- caso contrario consideramos o estoque em transito como estoque em casa e que este estoque será vendido
                                END
                            WHEN (v3.data_analise_demanda_real <= v3.data_previsao) THEN  -- pedido não esta atrasado
                                CASE
                                    WHEN ((v3.data_previsao - v3.data_analise_demanda_real) > 30) THEN 0 -- se o pedido for chegar depois dos proximos 30 dias, nao haverá venda, pois a projecao de venda é sempre pros proximos 30 dias
                                    ELSE LEAST(v3.estoque_transito, (v3.consumo_medio_diario * (v3.data_previsao - v3.data_analise_demanda_real))) -- porem, se o pedido chegar dentro dos 30 dias haverá venda dos dias restantes ou até acabar o estoque do pedido
                                END
                        END
                    WHEN v3.cobertura_estoque >= 30 THEN v3.consumo_medio_mensal -- tem estoque suficiente para suprir a projeção de venda (estoque >= consumo_medio_mensal)
                    ELSE -- estoque insuficiente para suprir a projeção de venda
                        CASE
                            WHEN v3.status_demanda = 'SEM PEDIDO' THEN (v3.consumo_medio_diario * v3.cobertura_estoque)
                            WHEN v3.data_previsao IS NOT NULL THEN -- com pedido em transito
                                CASE
                                    when v3.data_cobertura_instatanea >= v3.data_previsao THEN
                                        CASE
                                           WHEN v3.estoque_transito < COALESCE(((v3.consumo_medio_mensal * ((v3.data_analise_demanda_real + 30) - v3.data_cobertura_instatanea)) / 30), 0) THEN (v3.consumo_medio_diario * v3.cobertura_estoque) + v3.estoque_transito --v3.estoque + v3.estoque_transito
                                           ELSE (((v3.consumo_medio_mensal / 30) * v3.cobertura_estoque) + COALESCE(((v3.consumo_medio_mensal * ((v3.data_analise_demanda_real + 30) - v3.data_cobertura_instatanea)) / 30), 0))
                                        END
                                    ELSE
                                        CASE
                                            WHEN v3.data_previsao > (v3.data_analise_demanda_real + 30) THEN v3.estoque -- estoque trânsito chegará depois da data analisada
                                            ELSE -- estoque transito chegará dentro da data analisada
                                                CASE
                                                   when v3.estoque_transito >= (v3.consumo_medio_diario * (v3.data_analise_demanda_real + 30 - v3.data_previsao)) THEN ((v3.consumo_medio_mensal / 30) * v3.cobertura_estoque) + (v3.consumo_medio_diario * (v3.data_analise_demanda_real + 30 - v3.data_previsao)) -- será vendido todo o estoque mais o restante dos dias após o estoque trânsito chegar
                                                   ELSE LEAST(v3.consumo_medio_mensal, v3.estoque + v3.estoque_transito) -- será vendido toda projecao ou todo o estoque e o estoque em trânsito pois o estoque que vai chegar é inferior a projeção de venda restante
                                                end
                                        END
                                END
                        END
                END AS demanda_real,
                CASE
                    WHEN (v3.estoque_transito > 0 AND v3.estoque > 0 AND v3.estoque < v3.consumo_medio_mensal) THEN v3.data_previsao - v3.data_cobertura_instatanea
                    ELSE 0
                END AS dif_data
            FROM v3
        ),
        v5 AS (
            SELECT
                v4.*,
                trunc(COALESCE(v4.demanda_real * v4.preco_venda, 0), 4) AS faturamento_real,
                trunc(COALESCE(v4.cmm_em_preco_venda - (v4.demanda_real * v4.preco_venda), 0), 4) AS diferenca,
                COALESCE((CASE
                    WHEN (v4.consumo_medio_mensal = 0) THEN 0
                    WHEN v4.cobertura_personalizada_ativa THEN round((v4.emax::NUMERIC / NULLIF(v4.consumo_medio_mensal, 0)::NUMERIC) * 30) -- calcula a cobertura manual atualmente parametrizada
                    WHEN (v4.classificacao_popularidade = 'S') THEN 0
                    WHEN (v4.qtde_dias_cobertura_parametrizada = 0) THEN 0
                    WHEN (v4.qtde_dias_cobertura_parametrizada <= v4.tempo_ressuprimento_dias) THEN v4.tempo_ressuprimento_dias + 15
                    ELSE v4.qtde_dias_cobertura_parametrizada
                END), 0) AS cobertura_parametrizavel
            FROM v4
        ),
        v6 AS (
            SELECT
                v5.*,
                CASE 
                    WHEN v5.cobertura_personalizada_ativa THEN v5.emax
                    ELSE trunc(GREATEST((v5.consumo_medio_mensal / 30::numeric) * v5.cobertura_parametrizavel, 0), 4)
                END AS estoque_parametrizavel,
                CASE 
                    WHEN v5.cobertura_personalizada_ativa THEN v5.emax * v5.preco_custo
                    ELSE trunc(GREATEST((v5.consumo_medio_mensal / 30::numeric) * v5.cobertura_parametrizavel, 0), 4)  * v5.preco_custo
                END AS estoque_parametrizavel_preco_custo
            FROM v5
        ),
        v7 AS (
            SELECT
                v6.*,
                GREATEST((v6.estoque_parametrizavel - v6.estoque), 0) AS total_estoque_para_aumentar,
                LEAST((v6.estoque_parametrizavel - v6.estoque), 0) AS total_estoque_para_reduzir,
                GREATEST((v6.estoque_parametrizavel_preco_custo - (v6.estoque * v6.preco_custo)), 0) AS total_estoque_para_aumentar_preco_custo,
                --LEAST((v6.estoque_parametrizavel_preco_custo - (v6.estoque * v6.preco_custo)), 0) AS total_estoque_para_reduzir_preco_custo,
                LEAST(GREATEST((v6.estoque_parametrizavel_preco_custo - v6.estoque_em_preco_custo), v6.estoque_em_preco_custo * -1), 0) AS total_estoque_para_reduzir_preco_custo,
                CASE 
                    WHEN v6.cobertura_personalizada_ativa THEN v6.emax
                    ELSE round(GREATEST((v6.consumo_medio_mensal / 30::numeric) * v6.cobertura_parametrizavel, 0), 4)
                END AS emax_parametrizavel
            FROM v6
        ),
        v8 AS (
            SELECT
                v7.*,
                GREATEST(v7.estoque - v7.emax_parametrizavel, 0) AS estoque_em_excesso_parametrizavel,
                (GREATEST(v7.estoque - v7.emax_parametrizavel, 0) * v7.preco_custo) AS estoque_em_excesso_parametrizavel_em_preco_custo,
                CASE
                    WHEN (v7.cobertura_estoque <= v7.tempo_ressuprimento_dias) THEN v7.estoque
                    WHEN (v7.estoque <= v7.pp) THEN (v7.consumo_medio_mensal * v7.tempo_ressuprimento_meses)
                    ELSE 0
                END AS consumo_transito
            FROM v7
        )
        SELECT
            v8.*,
            (v8.consumo_transito * v8.preco_custo) AS consumo_transito_preco_custo,
            CASE
                WHEN (v8.estoque >= v8.emax_parametrizavel OR v8.cobertura_estoque <= v8.tempo_ressuprimento_dias) THEN 0
                WHEN (v8.estoque <= v8.pp) THEN (v8.estoque - (v8.consumo_medio_mensal * v8.tempo_ressuprimento_meses))
                ELSE 0
            END AS estoque_residual,
            (v8.consumo_transito * v8.preco_custo) AS estoque_futuro_preco_custo
        FROM v8
    )
    LOOP
        UPDATE public.analise_diagnostico_estoque_filial
        SET
            idsegmento = rec_produto.idsegmento,
            descricao_segmento = rec_produto.descricao_segmento,
            idsecao = rec_produto.idsecao,
            descricao_secao = rec_produto.descricao_secao,
            idcomprador = rec_produto.idcomprador,
            descricao_comprador = rec_produto.descricao_comprador,
            idfornecedor = rec_produto.idfornecedor,
            descricao_fornecedor = rec_produto.descricao_fornecedor,
            data_cadastro = rec_produto.data_cadastro,
            preco_custo = rec_produto.preco_custo,
            preco_venda = rec_produto.preco_venda,
            data_ult_saida = rec_produto.data_ult_saida,
            qtde_dias_sem_vender = rec_produto.qtde_dias_sem_vender,
            estoque = rec_produto.estoque,
            esseg = rec_produto.esseg,
            pp = rec_produto.pp,
            emax = rec_produto.emax,
            consumo_medio_mensal = rec_produto.consumo_medio_mensal,
            consumo_medio_diario = rec_produto.consumo_medio_diario,
            classificacao_financeira = rec_produto.classificacao_financeira,
            classificacao_popularidade = rec_produto.classificacao_popularidade,
            classificacao_criticidade = rec_produto.classificacao_criticidade,
            classificacao_comprabilidade = rec_produto.classificacao_comprabilidade,
            nivel_servico = rec_produto.nivel_servico,
            tempo_medio_apanhe = rec_produto.tempo_medio_apanhe,
            estoque_transito = rec_produto.estoque_transito,
            id_solicitacao = rec_produto.id_solicitacao,
            data_solicitacao = rec_produto.data_solicitacao,
            data_previsao = rec_produto.data_previsao,
            ativo_para_venda = rec_produto.ativo_para_venda,
            fora_de_linha = rec_produto.fora_de_linha,
            tempo_ressuprimento_meses = rec_produto.tempo_ressuprimento_meses,
            tempo_ressuprimento_dias = rec_produto.tempo_ressuprimento_dias,
            cobertura_emax = rec_produto.cobertura_emax,
            emax_em_preco_custo = rec_produto.emax_em_preco_custo,
            cobertura_estoque = rec_produto.cobertura_estoque,
            estoque_em_preco_custo = rec_produto.estoque_em_preco_custo,
            estoque_em_preco_venda = rec_produto.estoque_em_preco_venda,
            cmm_em_preco_venda = rec_produto.cmm_em_preco_venda,
            cmm_em_preco_custo = rec_produto.cmm_em_preco_custo,
            estoque_em_excesso = rec_produto.estoque_em_excesso,
            estoque_em_excesso_em_preco_custo = rec_produto.estoque_em_excesso_em_preco_custo,
            data_analise_demanda_real = rec_produto.data_analise_demanda_real,
            sugestao_compra = rec_produto.sugestao_compra,
            sugestao_compra_preco_custo = rec_produto.sugestao_compra_preco_custo,
            qtde_dias_cobertura_parametrizada = rec_produto.qtde_dias_cobertura_parametrizada,
            markup = rec_produto.markup,
            frequencia_saida = rec_produto.frequencia_saida,
            faturamento = rec_produto.faturamento,
            status_produto = rec_produto.status_produto,
            grupo_intervalo_cobertura = rec_produto.grupo_intervalo_cobertura,
            histograma = rec_produto.histograma,
            idade = rec_produto.idade,
            data_cobertura_instatanea = rec_produto.data_cobertura_instatanea,
            status_demanda = rec_produto.status_demanda,
            demanda_real = rec_produto.demanda_real,
            dif_data = rec_produto.dif_data,
            faturamento_real = rec_produto.faturamento_real,
            diferenca = rec_produto.diferenca,
            cobertura_parametrizavel = rec_produto.cobertura_parametrizavel,
            estoque_parametrizavel = rec_produto.estoque_parametrizavel,
            estoque_parametrizavel_preco_custo = rec_produto.estoque_parametrizavel_preco_custo,
            total_estoque_para_aumentar = rec_produto.total_estoque_para_aumentar,
            total_estoque_para_reduzir = rec_produto.total_estoque_para_reduzir,
            total_estoque_para_aumentar_preco_custo = rec_produto.total_estoque_para_aumentar_preco_custo,
            total_estoque_para_reduzir_preco_custo = rec_produto.total_estoque_para_reduzir_preco_custo,
            emax_parametrizavel = rec_produto.emax_parametrizavel,
            estoque_em_excesso_parametrizavel = rec_produto.estoque_em_excesso_parametrizavel,
            estoque_em_excesso_parametrizavel_em_preco_custo = rec_produto.estoque_em_excesso_parametrizavel_em_preco_custo,
            consumo_transito = rec_produto.consumo_transito,
            consumo_transito_preco_custo = rec_produto.consumo_transito_preco_custo,
            estoque_residual = rec_produto.estoque_residual,
            estoque_futuro_preco_custo = rec_produto.estoque_futuro_preco_custo,
            data_primeira_entrada = rec_produto.data_primeira_entrada,
            data_ultima_entrada = rec_produto.data_ultima_entrada,
            classificacao_rentabilidade = rec_produto.classificacao_rentabilidade,
            estoque_minimo = rec_produto.estoque_minimo,
            flag = NULL,
            cod_produto = rec_produto.cod_produto,
            produto_combinado = rec_produto.produto_combinado,
            data = current_date
        WHERE 
            filial = rec_produto.filial 
            AND idproduto = rec_produto.idproduto;

        IF NOT FOUND THEN
            INSERT INTO public.analise_diagnostico_estoque_filial (
                filial,
                idsegmento,
                descricao_segmento,
                idsecao,
                descricao_secao,
                idcomprador,
                descricao_comprador,
                idfornecedor,
                descricao_fornecedor,
                idproduto,
                descricao_produto,
                data_cadastro,
                preco_custo,
                preco_venda,
                data_ult_saida,
                qtde_dias_sem_vender,
                estoque,
                esseg,
                pp,
                emax,
                consumo_medio_mensal,
                consumo_medio_diario,
                classificacao_financeira,
                classificacao_popularidade,
                classificacao_criticidade,
                classificacao_comprabilidade,
                nivel_servico,
                tempo_medio_apanhe,
                estoque_transito,
                id_solicitacao,
                data_solicitacao,
                data_previsao,
                ativo_para_venda,
                fora_de_linha,
                tempo_ressuprimento_meses,
                tempo_ressuprimento_dias,
                cobertura_emax,
                emax_em_preco_custo,
                cobertura_estoque,
                estoque_em_preco_custo,
                estoque_em_preco_venda,
                cmm_em_preco_venda,
                cmm_em_preco_custo,
                estoque_em_excesso,
                estoque_em_excesso_em_preco_custo,
                data_analise_demanda_real,
                sugestao_compra,
                sugestao_compra_preco_custo,
                qtde_dias_cobertura_parametrizada,
                markup,
                frequencia_saida,
                faturamento,
                status_produto,
                grupo_intervalo_cobertura,
                histograma,
                idade,
                data_cobertura_instatanea,
                status_demanda,
                demanda_real,
                dif_data,
                faturamento_real,
                diferenca,
                cobertura_parametrizavel,
                estoque_parametrizavel,
                estoque_parametrizavel_preco_custo,
                total_estoque_para_aumentar,
                total_estoque_para_reduzir,
                total_estoque_para_aumentar_preco_custo,
                total_estoque_para_reduzir_preco_custo,
                emax_parametrizavel,
                estoque_em_excesso_parametrizavel,
                estoque_em_excesso_parametrizavel_em_preco_custo,
                consumo_transito,
                consumo_transito_preco_custo,
                estoque_residual,
                estoque_futuro_preco_custo,
                data_primeira_entrada,
                data_ultima_entrada,
                classificacao_rentabilidade,
                estoque_minimo,
                produto_combinado,
                cod_produto,
                DATA
            )
            VALUES(
                rec_produto.filial,
                rec_produto.idsegmento,
                rec_produto.descricao_segmento,
                rec_produto.idsecao,
                rec_produto.descricao_secao,
                rec_produto.idcomprador,
                rec_produto.descricao_comprador,
                rec_produto.idfornecedor,
                rec_produto.descricao_fornecedor,
                rec_produto.idproduto,
                rec_produto.descricao_produto,
                rec_produto.data_cadastro,
                rec_produto.preco_custo,
                rec_produto.preco_venda,
                rec_produto.data_ult_saida,
                rec_produto.qtde_dias_sem_vender,
                rec_produto.estoque,
                rec_produto.esseg,
                rec_produto.pp,
                rec_produto.emax,
                rec_produto.consumo_medio_mensal,
                rec_produto.consumo_medio_diario,
                rec_produto.classificacao_financeira,
                rec_produto.classificacao_popularidade,
                rec_produto.classificacao_criticidade,
                rec_produto.classificacao_comprabilidade,
                rec_produto.nivel_servico,
                rec_produto.tempo_medio_apanhe,
                rec_produto.estoque_transito,
                rec_produto.id_solicitacao,
                rec_produto.data_solicitacao,
                rec_produto.data_previsao,
                rec_produto.ativo_para_venda,
                rec_produto.fora_de_linha,
                rec_produto.tempo_ressuprimento_meses,
                rec_produto.tempo_ressuprimento_dias,
                rec_produto.cobertura_emax,
                rec_produto.emax_em_preco_custo,
                rec_produto.cobertura_estoque,
                rec_produto.estoque_em_preco_custo,
                rec_produto.estoque_em_preco_venda,
                rec_produto.cmm_em_preco_venda,
                rec_produto.cmm_em_preco_custo,
                rec_produto.estoque_em_excesso,
                rec_produto.estoque_em_excesso_em_preco_custo,
                rec_produto.data_analise_demanda_real,
                rec_produto.sugestao_compra,
                rec_produto.sugestao_compra_preco_custo,
                rec_produto.qtde_dias_cobertura_parametrizada,
                rec_produto.markup,
                rec_produto.frequencia_saida,
                rec_produto.faturamento,
                rec_produto.status_produto,
                rec_produto.grupo_intervalo_cobertura,
                rec_produto.histograma,
                rec_produto.idade,
                rec_produto.data_cobertura_instatanea,
                rec_produto.status_demanda,
                rec_produto.demanda_real,
                rec_produto.dif_data,
                rec_produto.faturamento_real,
                rec_produto.diferenca,
                rec_produto.cobertura_parametrizavel,
                rec_produto.estoque_parametrizavel,
                rec_produto.estoque_parametrizavel_preco_custo,
                rec_produto.total_estoque_para_aumentar,
                rec_produto.total_estoque_para_reduzir,
                rec_produto.total_estoque_para_aumentar_preco_custo,
                rec_produto.total_estoque_para_reduzir_preco_custo,
                rec_produto.emax_parametrizavel,
                rec_produto.estoque_em_excesso_parametrizavel,
                rec_produto.estoque_em_excesso_parametrizavel_em_preco_custo,
                rec_produto.consumo_transito,
                rec_produto.consumo_transito_preco_custo,
                rec_produto.estoque_residual,
                rec_produto.estoque_futuro_preco_custo,
                rec_produto.data_primeira_entrada,
                rec_produto.data_ultima_entrada,
                rec_produto.classificacao_rentabilidade,
                rec_produto.estoque_minimo,
                rec_produto.produto_combinado,
                rec_produto.cod_produto,
                current_date
            );
        END IF;
    END LOOP;

    DELETE FROM analise_diagnostico_estoque_filial WHERE flag = 'D';

END;
$function$

