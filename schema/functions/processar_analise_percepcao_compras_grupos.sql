CREATE OR REPLACE FUNCTION public.processar_analise_percepcao_compras_grupos(data_inicial date DEFAULT CURRENT_DATE)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
        DECLARE
            rec_analise record;
        BEGIN
            data_inicial = to_char(data_inicial, '01/MM/YYYY')::date;

            UPDATE analise_percepcao_compras_grupos SET flag = 'D' WHERE data_solicitacao >= data_inicial;

            FOR rec_analise IN (
                SELECT DISTINCT
                    analise.id_grupo,
                    analise.filial,
                    analise.data_solicitacao,
                    analise.ordem_compra,
                    analise.data_entrada,
                    analise.total_entradas,
                    analise.sugestao,
                    analise.idproduto,
                    analise.descricao_produto,
                    analise.descricao_familia_produto,
                    analise.estoque_no_dia_entrada,
                    analise.estoque_seguranca,
                    analise.ponto_pedido,
                    analise.estoque_maximo,
                    analise.tempo_medio_ressuprimento,
                    analise.consumo_medio,
                    analise.estoque_solicitacao,
                    analise.valor_unitario,
                    analise.custo_unitario,
                    analise.nome_comprador,
                    CASE
                        WHEN (
                            SELECT count(*) AS count
                            FROM entrada_mercadorias em
                                INNER JOIN grupo_filial gf ON gf.filial = em.idfilial
                            WHERE
                                gf.id_grupo = analise.id_grupo
                                AND em.idproduto::TEXT = ANY(analise.produtos)
                                AND em.data_entrada < analise.data_solicitacao
                                AND em.data_entrada >= (em.data_entrada - 730)
                                AND em.data_entrada <= 'now'::text::date
                        ) = 0 THEN 'PRIMEIRA COMPRA'::text
                        WHEN analise.consumo_medio = 0::numeric THEN 'SEM COMPORTAMENTO'::TEXT
                        WHEN analise.consumo_medio > 0::numeric AND analise.estoque_solicitacao = 0::numeric THEN 'PERCEPCAO EM RUPTURA'::text
                        WHEN analise.consumo_medio > 0::numeric AND analise.estoque_solicitacao::double precision > analise.ponto_pedido::double precision AND analise.estoque_solicitacao::double precision <= (ceil(analise.estoque_maximo::double precision) * analise.peso::double precision) THEN 'PERCEPCAO EM PONTO DE PEDIDO'::text
                        WHEN analise.consumo_medio > 0::numeric AND analise.estoque_solicitacao::double precision < analise.ponto_pedido::double precision AND analise.estoque_solicitacao > (analise.ponto_pedido - analise.estoque_seguranca) THEN 'PERCEPCAO EM PONTO DE PEDIDO'::text
                        WHEN analise.consumo_medio > 0::numeric AND analise.estoque_solicitacao::double precision > (ceil(analise.estoque_maximo::double precision) * analise.peso::double precision) THEN 'PERCEPCAO COM ELEVADA PREMATURIDADE'::text
                        WHEN analise.consumo_medio > 0::numeric AND analise.estoque_solicitacao::double precision <= analise.ponto_pedido::double precision THEN 'PERCEPCAO COM ELEVADA EXPOSICAO RUPTURA'::text
                        ELSE 'SEM COMPORTAMENTO'::text
                    END AS status_percepcao,
                    CASE
                        WHEN (
                                SELECT count(*) > 0
                                FROM entrada_mercadorias em
                                WHERE
                                    em.idfilial = analise.filial
                                    AND em.idproduto::TEXT = ANY(analise.produtos)
                                    AND em.data_entrada < analise.data_solicitacao
                                    AND em.data_entrada >= (em.data_entrada - 730)
                                    AND em.data_entrada <= 'now'::text::date
                            )
                            AND analise.consumo_medio = 0::numeric
                        THEN (analise.data_solicitacao - (
                                SELECT max(em.data_entrada) AS max
                                FROM entrada_mercadorias em
                                WHERE
                                    em.idfilial = analise.filial
                                    AND em.idproduto::TEXT = ANY(analise.produtos)
                                    AND em.data_entrada < analise.data_solicitacao
                                    AND em.data_entrada >= (em.data_entrada - 730)
                                    AND em.data_entrada <= 'now'::text::date
                            )
                        )::character varying
                        ELSE NULL::character varying
                    END AS qtde_sem_comportamento,
                    analise.fator_conversao,
                    analise.idcomprador,
                    analise.idfornecedor,
                    analise.nivel_servico,
                    analise.produto_eh_combinacao,
                    analise.produto_eh_categoria_mp_pa
                FROM (
                    SELECT
                        gf.id_grupo,
                        requisicoes.idfilial AS filial,
                        requisicoes.data_solicitacao,
                        requisicoes.ordem_compra,
                        entrada_mercadorias.data_entrada,
                        entrada_mercadorias.qtde AS total_entradas,
                        saldos.idproduto,
                        ARRAY[saldos.idproduto] AS produtos,
                        produtos.descricao_produto,
                        familia_produtos.descricao_familia_produto,
                        (
                            SELECT a.estoque
                            FROM saldo_filiais a
                            WHERE a.filial = saldos.filial AND a.idproduto::text = saldos.idproduto::text AND a.data = entrada_mercadorias.data_entrada
                            LIMIT 1
                        ) AS estoque_no_dia_entrada,
                        produtos.tempo_medio_ressuprimento,
                        sg.estoque AS estoque_solicitacao,
                        produtos.valor_unitario,
                        produtos.custo_unitario,
                        comprador.nome_completo AS nome_comprador,
                        sg.esseg AS estoque_seguranca,
                        sg.ppd AS ponto_pedido,
                        sg.emax AS estoque_maximo,
                        saldos.sugestao_compras AS sugestao,
                        sg.cmm AS consumo_medio,
                        produtos.fator_conversao,
                        produtos.idcomprador,
                        produtos.idfornecedor,
                        produtos.nivel_servico,
                        n.peso,
                        FALSE AS produto_eh_combinacao,
                        FALSE AS produto_eh_categoria_mp_pa
                    FROM requisicoes
                        JOIN saldo_filiais saldos ON requisicoes.idfilial = saldos.filial AND requisicoes.idproduto::text = saldos.idproduto::text AND requisicoes.data_solicitacao = saldos.data
                        JOIN produtos_filial produtos ON produtos.filial = saldos.filial AND produtos.idproduto::text = saldos.idproduto::text
                        LEFT JOIN entrada_mercadorias ON entrada_mercadorias.idproduto::text = saldos.idproduto::text AND entrada_mercadorias.ordem_compra = requisicoes.ordem_compra
                        JOIN comprador ON comprador.id = produtos.idcomprador
                        JOIN familia_produtos ON familia_produtos.idfamilia_produto = produtos.idfamilia_produto
                        JOIN nivel_servico n ON n.descricao_nivel_servico::text = produtos.nivel_servico::text
                        JOIN grupo_filial gf ON gf.filial = requisicoes.idfilial
                        JOIN grupo_compras gc ON gc.id = gf.id_grupo
                        JOIN saldo_grupos sg ON sg.id_grupo = gf.id_grupo AND requisicoes.idproduto::text = sg.idproduto::text AND requisicoes.data_solicitacao = sg.data
                    WHERE
                        saldos.data >= data_inicial
                        AND saldos.data <= ('now'::text::date - 1)
                        AND produtos.revenda::text = 'S'::TEXT
                        AND saldos.idproduto NOT IN (
                            SELECT spci.idproduto
                            FROM sys_produtos_combinados spc
                                INNER JOIN sys_produtos_combinados_itens spci ON spci.id_produto_combinado = spc.id AND spc.deleted_at IS NULL
                            GROUP BY spci.idproduto
                        )
                        AND gc.grupo_agrega <> 'S'
                        AND NOT ((requisicoes.idproduto::text, gf.id_grupo) IN (
                            SELECT npb.idproduto, npb.grupo
                            FROM notificacao_produtos_blacklist npb
                            WHERE
                                npb.grupo = gf.id_grupo
                                AND npb.filial IN (0, gf.filial)
                                AND npb.data_limite >= CURRENT_DATE
                                AND npb.deleted_at IS NULL
                        ))

                    UNION ALL

                    SELECT
                        gf.id_grupo,
                        gf.filial,
                        r.data_solicitacao,
                        r.ordem_compra,
                        e.data_entrada,
                        e.qtde AS total_entradas,
                        spc.id AS idproduto,
                        pccf.produtos,
                        spc.descricao AS descricao_produto,
                        '' AS descricao_familia_produto,
                        (
                            SELECT sum(a.estoque)
                            FROM saldo_filiais a
                            WHERE
                                a.filial = gf.filial
                                AND a.idproduto::text IN (SELECT v.idproduto FROM sys_produtos_combinados_itens v WHERE v.id_produto_combinado = spc.id)
                                AND a.data = e.data_entrada
                        ) AS estoque_no_dia_entrada,
                        pccf.tempo_medio_ressuprimento,
                        sg.estoque AS estoque_solicitacao,
                        pccf.valor_unitario,
                        pccf.custo_unitario,
                        ''::TEXT AS nome_comprador,
                        sum(sg.esseg) AS estoque_seguranca,
                        sum(sg.ppd) AS ponto_pedido,
                        sum(sg.emax) AS estoque_maximo,
                        NULL AS sugestao,
                        sum(sg.cmm) AS consumo_medio,
                        pccf.fator_conversao,
                        (
                            SELECT max(pf.idcomprador)
                            FROM produtos_filial pf
                            WHERE pf.filial = gf.filial AND pf.idproduto = ANY(pccf.produtos)
                        ) AS idcomprador,
                        0 AS idfornecedor,
                        pccf.nivel_servico,
                        n.peso,
                        TRUE AS produto_eh_combinacao,
                        FALSE AS produto_eh_categoria_mp_pa
                    FROM requisicoes r
                        INNER JOIN grupo_filial gf ON gf.filial = r.idfilial
                        INNER JOIN grupo_compras gc ON gc.id = gf.id_grupo
                        INNER JOIN sys_produtos_combinados_itens spci ON spci.idproduto = r.idproduto
                        INNER JOIN sys_produtos_combinados spc ON spc.id = spci.id_produto_combinado
                        INNER JOIN produtos_combinados_compras_filial pccf ON pccf.id_grupo = gf.id_grupo AND pccf.filial = gf.filial AND pccf.id_produto_combinado = spc.id
                        INNER JOIN saldo_grupos sg ON sg.id_grupo = gf.id_grupo AND sg.idproduto::text = any(pccf.produtos) AND r.data_solicitacao = sg.DATA
                        INNER JOIN nivel_servico n ON n.descricao_nivel_servico::text = pccf.nivel_servico::text
                        LEFT JOIN entrada_mercadorias e ON e.idproduto::text = r.idproduto::text AND e.ordem_compra = r.ordem_compra
                    WHERE
                        spc.deleted_at IS NULL
                        AND r.data_solicitacao >= data_inicial
                        AND r.data_solicitacao <= (current_date - 1)
                        AND pccf.revenda::text = 'S'::TEXT
                        AND gc.grupo_agrega <> 'S'
                        AND NOT ((spc.id::text, gf.id_grupo) IN (
                            SELECT npb.idproduto, npb.grupo
                            FROM notificacao_produtos_blacklist npb
                            WHERE
                                npb.grupo = gf.id_grupo
                                AND npb.filial IN (0, gf.filial)
                                AND npb.data_limite >= CURRENT_DATE
                                AND npb.deleted_at IS NULL
                        ))
                    GROUP BY
                        gf.id_grupo,
                        gf.filial,
                        r.data_solicitacao,
                        r.ordem_compra,
                        e.data_entrada,
                        e.qtde,
                        spc.id,
                        pccf.produtos,
                        spc.descricao,
                        pccf.tempo_medio_ressuprimento,
                        sg.estoque,
                        pccf.valor_unitario,
                        pccf.custo_unitario,
                        pccf.fator_conversao,
                        pccf.nivel_servico,
                        n.peso

                    UNION ALL

                    (WITH produtos_categoria_mp AS (
                        SELECT DISTINCT mp.id_categoria, mp.id_produto_mp
                        FROM produtos_categoria_mp_pa mp
                    )
                    SELECT
                        gf.id_grupo,
                        requisicoes.idfilial AS filial,
                        requisicoes.data_solicitacao,
                        requisicoes.ordem_compra,
                        NULL AS data_entrada,
                        NULL AS total_entradas,
                        saldos.id_categoria::TEXT AS idproduto,
                        array_agg(id_produto_mp) AS produtos,
                        produtos.descricao_categoria AS descricao_produto,
                        NULL AS descricao_familia_produto,
                        NULL AS estoque_no_dia_entrada,
                        produtos.tempo_medio_ressuprimento,
                        saldos.estoque AS estoque_solicitacao,
                        NULL AS valor_unitario,
                        NULL AS custo_unitario,
                        comprador.nome_completo AS nome_comprador,
                        saldos.estoque_seguranca AS estoque_seguranca,
                        saldos.ponto_pedido AS ponto_pedido,
                        saldos.estoque_maximo AS estoque_maximo,
                        0 AS sugestao,
                        saldos.consumo_medio AS consumo_medio,
                        produtos.fator_conversao,
                        produtos.idcomprador,
                        NULL AS idfornecedor,
                        produtos.nivel_servico,
                        n.peso,
                        FALSE AS produto_eh_combinacao,
                        TRUE AS produto_eh_categoria_mp_pa
                    FROM requisicoes
                        JOIN grupo_filial gf ON gf.filial = requisicoes.idfilial
                        JOIN produtos_categoria_mp pcmp ON pcmp.id_produto_mp = requisicoes.idproduto
                        JOIN saldo_grupos_categorias_mp_pa saldos ON saldos.id_grupo = gf.id_grupo AND saldos.id_categoria = pcmp.id_categoria AND saldos.DATA = requisicoes.data_solicitacao
                        JOIN produtos_compras_categorias_mp_pa produtos ON produtos.id_grupo = gf.id_grupo AND produtos.id_categoria = saldos.id_categoria
                        JOIN comprador ON comprador.id = produtos.idcomprador
                        JOIN nivel_servico n ON n.descricao_nivel_servico::text = produtos.nivel_servico::text
                        JOIN grupo_compras gc ON gc.id = gf.id_grupo
                    WHERE
                        NOT EXISTS (
                            SELECT b.idcategoria
                            FROM notificacao_categorias_mp_pa_blacklist b
                            WHERE
                                b.grupo = produtos.id_grupo
                                AND b.idcategoria = produtos.id_categoria
                                AND b.filial = 0
                                AND b.data_limite >= CURRENT_DATE
                                AND b.deleted_at IS NULL
                        )
                    GROUP BY
                        gf.id_grupo,
                        requisicoes.idfilial,
                        requisicoes.data_solicitacao,
                        requisicoes.ordem_compra,
                        saldos.id_categoria::TEXT,
                        produtos.descricao_categoria,
                        produtos.tempo_medio_ressuprimento,
                        saldos.estoque,
                        comprador.nome_completo,
                        saldos.estoque_seguranca,
                        saldos.ponto_pedido,
                        saldos.estoque_maximo,
                        saldos.consumo_medio,
                        produtos.fator_conversao,
                        produtos.idcomprador,
                        produtos.nivel_servico,
                        n.peso)
                ) analise
            )
            LOOP
                UPDATE analise_percepcao_compras_grupos
                SET
                    id_grupo = rec_analise.id_grupo,
                    filial = rec_analise.filial,
                    data_solicitacao = rec_analise.data_solicitacao,
                    idproduto = rec_analise.idproduto,
                    ordem_compra = rec_analise.ordem_compra,
                    data_entrada = rec_analise.data_entrada,
                    total_entradas = rec_analise.total_entradas,
                    sugestao = rec_analise.sugestao,
                    descricao_produto = rec_analise.descricao_produto,
                    descricao_familia_produto = rec_analise.descricao_familia_produto,
                    estoque_no_dia_entrada = rec_analise.estoque_no_dia_entrada,
                    estoque_seguranca = rec_analise.estoque_seguranca,
                    ponto_pedido = rec_analise.ponto_pedido,
                    estoque_maximo = rec_analise.estoque_maximo,
                    tempo_medio_ressuprimento = rec_analise.tempo_medio_ressuprimento,
                    consumo_medio = rec_analise.consumo_medio,
                    estoque_solicitacao = rec_analise.estoque_solicitacao,
                    valor_unitario = rec_analise.valor_unitario,
                    custo_unitario = rec_analise.custo_unitario,
                    nome_comprador = rec_analise.nome_comprador,
                    status_percepcao = rec_analise.status_percepcao,
                    qtde_sem_comportamento = rec_analise.qtde_sem_comportamento,
                    fator_conversao = rec_analise.fator_conversao,
                    idcomprador = rec_analise.idcomprador,
                    idfornecedor = rec_analise.idfornecedor,
                    nivel_servico = rec_analise.nivel_servico,
                    produto_eh_combinacao = rec_analise.produto_eh_combinacao,
                    produto_eh_categoria_mp_pa = rec_analise.produto_eh_categoria_mp_pa,
                    flag = null
                WHERE
                    id_grupo = rec_analise.id_grupo
                    AND filial = rec_analise.filial
                    AND ordem_compra = rec_analise.ordem_compra
                    AND data_solicitacao = rec_analise.data_solicitacao
                    AND produto_eh_combinacao = rec_analise.produto_eh_combinacao
                    AND produto_eh_categoria_mp_pa = rec_analise.produto_eh_categoria_mp_pa
                    AND idproduto = rec_analise.idproduto;

                IF NOT FOUND THEN
                    INSERT INTO analise_percepcao_compras_grupos (
                        id_grupo,
                        filial,
                        data_solicitacao,
                        ordem_compra,
                        data_entrada,
                        total_entradas,
                        sugestao,
                        idproduto,
                        descricao_produto,
                        descricao_familia_produto,
                        estoque_no_dia_entrada,
                        estoque_seguranca,
                        ponto_pedido,
                        estoque_maximo,
                        tempo_medio_ressuprimento,
                        consumo_medio,
                        estoque_solicitacao,
                        valor_unitario,
                        custo_unitario,
                        nome_comprador,
                        status_percepcao,
                        qtde_sem_comportamento,
                        fator_conversao,
                        idcomprador,
                        idfornecedor,
                        nivel_servico,
                        produto_eh_combinacao,
                        produto_eh_categoria_mp_pa
                    )
                    VALUES (
                        rec_analise.id_grupo,
                        rec_analise.filial,
                        rec_analise.data_solicitacao,
                        rec_analise.ordem_compra,
                        rec_analise.data_entrada,
                        rec_analise.total_entradas,
                        rec_analise.sugestao,
                        rec_analise.idproduto,
                        rec_analise.descricao_produto,
                        rec_analise.descricao_familia_produto,
                        rec_analise.estoque_no_dia_entrada,
                        rec_analise.estoque_seguranca,
                        rec_analise.ponto_pedido,
                        rec_analise.estoque_maximo,
                        rec_analise.tempo_medio_ressuprimento,
                        rec_analise.consumo_medio,
                        rec_analise.estoque_solicitacao,
                        rec_analise.valor_unitario,
                        rec_analise.custo_unitario,
                        rec_analise.nome_comprador,
                        rec_analise.status_percepcao,
                        rec_analise.qtde_sem_comportamento,
                        rec_analise.fator_conversao,
                        rec_analise.idcomprador,
                        rec_analise.idfornecedor,
                        rec_analise.nivel_servico,
                        rec_analise.produto_eh_combinacao,
                        rec_analise.produto_eh_categoria_mp_pa
                    );
                END IF;
            END LOOP;

            DELETE FROM analise_percepcao_compras_grupos WHERE flag = 'D' AND data_solicitacao >= data_inicial;

            DELETE FROM analise_percepcao_compras_grupos WHERE idproduto IN (select idproduto from produtos_para_nao_exibir_nos_indicadores);
        END;
    $function$

