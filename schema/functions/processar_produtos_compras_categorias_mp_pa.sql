CREATE OR REPLACE FUNCTION public.processar_produtos_compras_categorias_mp_pa(f_grupo integer DEFAULT 0, f_categoria integer DEFAULT 0)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE 
    rec_categoria record;
    p_estoque_seguranca numeric(12,4);
    p_ponto_pedido numeric(12,4);
    p_estoque_maximo numeric(12,4);
    p_tempo_medio_ressuprimento numeric(12,4);
    p_tempo_ressuprimento numeric(12,4);
    p_lote_compras_bruto numeric(12,4);
    p_lote_compras numeric(12,4);
BEGIN
    UPDATE produtos_compras_categorias_mp_pa SET flag = 'D';

    FOR rec_categoria IN (
        WITH produtos_categoria_mp AS (
            SELECT DISTINCT 
                mp.id_categoria,
                mp.id_produto_mp
            FROM produtos_categoria_mp_pa mp
        ),
        produtos_categoria_pa AS (
            SELECT DISTINCT 
                pa.id_categoria,
                pa.id_produto_pa
            FROM produtos_categoria_mp_pa pa
        ),
        produtos_acabado AS (
            SELECT 
                gf.id_grupo,
                cmp.id AS id_categoria,
                cmp.nome AS descricao_categoria,
                sum(pa.estoque) AS estoque,
                sum(pa.estoque * pa.peso) AS estoque_peso,
                sum(pa.estoque_bloqueado * pa.peso) AS estoque_bloqueado_peso,
                sum(pa.estoque_avaria * pa.peso) AS estoque_avaria_peso,
                sum(pa.estoque_reservado * pa.peso) AS estoque_reservado_peso,
                sum(pa.estoque_similar * pa.peso) AS estoque_similar_peso,
                sum(pa.consumo_medio_mensal * pa.peso) AS consumo_medio_mensal_peso,
                sum(pa.consumo_medio_mensal) AS consumo_medio_mensal,
                COALESCE(sum(pa.desvio_padrao_consumo * pa.peso), 0::numeric) AS desvio_padrao_consumo_peso,
                min(pa.classificacao_financeira::text) AS classificacao_financeira,
                max(pa.classificacao_criticidade::text) AS classificacao_criticidade,
                min(pa.classificacao_comprabilidade) AS classificacao_comprabilidade,
                min(pa.classificacao_popularidade::text) AS classificacao_popularidade
            FROM categorias_mp_pa cmp
                JOIN produtos_categoria_pa pcmp ON pcmp.id_categoria = cmp.id
                JOIN produtos_filial pa ON pa.idproduto::text = pcmp.id_produto_pa::text
                JOIN grupo_filial gf ON gf.filial = pa.filial
            WHERE 
                pa.revenda = 'S'
                AND pa.status <> 'FL'
            GROUP BY gf.id_grupo, cmp.id
        ),
        materia_prima AS (
            SELECT gf.id_grupo,
                cmp.id AS id_categoria,
                cmp.nome AS descricao_categoria,
                sum(mp.estoque) AS estoque,
                (sum(mp.estoque_bloqueado)) AS estoque_bloqueado,
                (sum(mp.estoque_avaria)) AS estoque_avaria,
                (sum(mp.estoque_reservado)) AS estoque_reservado,
                (sum(mp.estoque_similar)) AS estoque_similar,
                (sum(mp.consumo_medio_mensal)) AS consumo_medio_mensal,
                sum(mp.desvio_padrao_consumo) AS desvio_padrao_consumo,
                COALESCE(max(mp.fator_conversao), 1) AS fator_conversao,
                COALESCE(avg(NULLIF(mp.tempo_medio_apanhe, 0::numeric)), 0::numeric) AS tempo_medio_apanhe,
                min(mp.unidade_compra::text) AS unidade_compra,
                min(mp.idunidade_medida::text) AS idunidade_medida,
                COALESCE(avg(NULLIF(mp.tempo_medio_ressuprimento, 0)), 0) AS prazo_medio_recebimento,
                 COALESCE(NULLIF(cmp.tempo_medio_ressuprimento, 0), 35) AS tempo_medio_ressuprimento,
                COALESCE(NULLIF(cmp.tempo_ressuprimento, 0::numeric), 1.17) AS tempo_ressuprimento,
                COALESCE(avg(NULLIF(mp.custo_unitario, 0::numeric)), 0) AS custo_medio_unitario,
                COALESCE(avg(NULLIF(mp.preco_compra, 0::numeric)), 0) AS preco_medio_compra,
                max(mp.idcomprador) AS idcomprador,
                COALESCE(NULLIF(cmp.lote_minimo, 0), 1) AS lote_minimo,
                COALESCE(cmp.desvio_padrao_ressuprimento, 0) AS desvio_padrao_ressuprimento,
                min(mp.classificacao_financeira::text) AS classificacao_financeira,
                max(mp.classificacao_criticidade::text) AS classificacao_criticidade,
                min(mp.classificacao_comprabilidade) AS classificacao_comprabilidade,
                min(mp.classificacao_popularidade::text) AS classificacao_popularidade
            FROM categorias_mp_pa cmp
                JOIN produtos_categoria_mp pcmp ON pcmp.id_categoria = cmp.id
                JOIN produtos_filial mp ON mp.idproduto::text = pcmp.id_produto_mp::text
                JOIN grupo_filial gf ON gf.filial = mp.filial
            GROUP BY 
                gf.id_grupo, 
                cmp.id
        ),
        categorias_grupos AS (
            SELECT
                gc.id AS id_grupo,
                cmp.id AS id_categoria,
                cmp.nome AS descricao_categoria,
                COALESCE(cmp.cobertura_manual_categoria, 0) AS cobertura_manual_categoria,
                COALESCE(NULLIF(cmp.tempo_ressuprimento, 0::numeric), 1.17) AS tempo_ressuprimento,
                COALESCE(NULLIF(cmp.lote_minimo, 0), 1) AS lote_minimo,
                COALESCE(cmp.desvio_padrao_ressuprimento, 0) AS desvio_padrao_ressuprimento
            FROM categorias_mp_pa cmp
                INNER JOIN grupo_compras gc ON 1 = 1
        ),
        produtos_consolidados AS (
            SELECT
                cg.id_grupo,
                cg.id_categoria,
                cg.descricao_categoria,
                COALESCE(mp.estoque + pa.estoque_peso, 0) AS estoque_peso,
                COALESCE(mp.estoque, 0) AS estoque_mp_peso,
                COALESCE(pa.estoque, 0) AS estoque_pa,
                COALESCE(pa.estoque_peso, 0) AS estoque_pa_peso,
                COALESCE(mp.estoque_bloqueado + pa.estoque_bloqueado_peso, 0) AS estoque_bloqueado_peso,
                COALESCE(mp.estoque_avaria + pa.estoque_avaria_peso, 0) AS estoque_avaria_peso,
                COALESCE(mp.estoque_reservado + pa.estoque_reservado_peso, 0) AS estoque_reservado_peso,
                COALESCE(mp.estoque_similar + pa.estoque_similar_peso, 0) AS estoque_similar_peso,
                COALESCE(pa.consumo_medio_mensal_peso, 0) AS cmm_peso,
                COALESCE(pa.consumo_medio_mensal_peso, 0) AS cmm_pa_peso,
                COALESCE(pa.consumo_medio_mensal, 0) AS cmm_pa,
                COALESCE(mp.desvio_padrao_consumo + pa.desvio_padrao_consumo_peso, 0) AS desvio_padrao_consumo_peso,
                COALESCE(mp.fator_conversao, 1) AS fator_conversao,
                COALESCE(mp.tempo_medio_apanhe), 0 AS tempo_medio_apanhe,
                COALESCE(mp.unidade_compra, 'KG') AS unidade_compra,
                COALESCE(mp.idunidade_medida, 'KG') AS idunidade_medida,
                COALESCE(cg.cobertura_manual_categoria, 0) AS cobertura_manual_categoria,
                COALESCE(mp.prazo_medio_recebimento, 0) AS prazo_medio_recebimento,
                COALESCE(mp.tempo_medio_ressuprimento, 0) AS tempo_medio_ressuprimento,
                COALESCE(cg.tempo_ressuprimento, 0) AS tempo_ressuprimento,
                COALESCE(mp.custo_medio_unitario, 0) AS custo_medio_unitario,
                COALESCE(mp.preco_medio_compra, 0) AS preco_medio_compra,
                COALESCE(mp.idcomprador, 0) AS idcomprador,
                cg.lote_minimo,
                COALESCE(cg.desvio_padrao_ressuprimento, 0) AS desvio_padrao_ressuprimento,
                COALESCE(pa.classificacao_financeira::TEXT, mp.classificacao_financeira::text) AS classificacao_financeira,
                COALESCE(pa.classificacao_criticidade::TEXT, mp.classificacao_criticidade::text) AS classificacao_criticidade,
                COALESCE(pa.classificacao_comprabilidade, mp.classificacao_comprabilidade) AS classificacao_comprabilidade,
                COALESCE(pa.classificacao_popularidade::TEXT, mp.classificacao_popularidade::text) AS classificacao_popularidade
            FROM categorias_grupos cg
                LEFT JOIN materia_prima mp ON mp.id_grupo = cg.id_grupo AND mp.id_categoria = cg.id_categoria
                LEFT JOIN produtos_acabado pa ON pa.id_grupo = cg.id_grupo AND pa.id_categoria = cg.id_categoria
        ),
        prismas AS (
            SELECT 
                pc.id_grupo,
                pc.id_categoria,
                (pc.classificacao_financeira::text || pc.classificacao_criticidade::text || pc.classificacao_comprabilidade || pc.classificacao_popularidade::text) AS arvore_decisao
            FROM produtos_consolidados pc
        )
        SELECT 
            pc.*,
            round(COALESCE(pc.desvio_padrao_consumo_peso * pc.fator_conversao / NULLIF(pc.cmm_peso * pc.fator_conversao, 0::numeric) * 100::numeric, 0::numeric), 2) AS coeficiente_variacao,
            p.arvore_decisao,
            getNivelServico(p.arvore_decisao) as nivel_servico,
            getFes(p.arvore_decisao) as fes,
            getPesoCompras(p.arvore_decisao, coalesce(pc.classificacao_comprabilidade, 0)) as peso_compras,
            0.0 AS estoque_transito_peso,
            coalesce(trunc(pc.estoque_peso / NULLIF(pc.cmm_peso, 0), 4), 0) AS cobertura_estoque_peso,
            '' AS perfil_demanda,
            COALESCE((
                SELECT r.pcompra 
                FROM requisicoes r 
                    --INNER JOIN grupo_filial gf ON gf.filial = r.idfilial 
                    INNER JOIN produtos_categoria_mp mp ON mp.id_produto_mp = r.idproduto 
                WHERE mp.id_categoria = pc.id_categoria --AND gf.id_grupo = pc.id_grupo
                ORDER BY r.id_solicitacao DESC, r.data_solicitacao DESC
                LIMIT 1
            ), 0) AS ultimo_preco_compra
        FROM produtos_consolidados pc
            INNER JOIN prismas p ON p.id_grupo = pc.id_grupo AND p.id_categoria = pc.id_categoria
    )
    LOOP    
        -- define o perfil de demanda
        IF (rec_categoria.coeficiente_variacao >= 0 AND rec_categoria.coeficiente_variacao <= 200) then
            rec_categoria.perfil_demanda = 'REPETITIVO'::TEXT;
        ELSIF (rec_categoria.coeficiente_variacao <= 600) THEN 
            rec_categoria.perfil_demanda = 'ESTATISTICO'::TEXT;
        ELSE 
            rec_categoria.perfil_demanda = 'OCASIONAL'::TEXT;
        END IF;
        
        -- estoque de segurança
        if (rec_categoria.cobertura_manual_categoria > 0) THEN 
        
            p_estoque_seguranca = round(((rec_categoria.cmm_peso / 30) * rec_categoria.cobertura_manual_categoria) * 0.30, 4);
        
        ELSEIF (rec_categoria.perfil_demanda = 'OCASIONAL') THEN 
        
            p_estoque_seguranca = round(cast((rec_categoria.cmm_peso / 2) * rec_categoria.fes AS NUMERIC), 4);
        
        ELSEIF (rec_categoria.desvio_padrao_consumo_peso = 0) THEN 
        
            p_estoque_seguranca = round(cast(rec_categoria.cmm_peso * rec_categoria.fes AS NUMERIC), 4);
        
        ELSE 
        
            p_estoque_seguranca = round(cast(rec_categoria.desvio_padrao_consumo_peso * rec_categoria.fes AS NUMERIC), 4); 
        
        END IF;
     
    
        -- Ponto de Pedido 
        IF rec_categoria.perfil_demanda = 'OCASIONAL' THEN
            p_ponto_pedido = round(cast(p_estoque_seguranca + ((rec_categoria.cmm_peso / 2) * (rec_categoria.tempo_ressuprimento + rec_categoria.desvio_padrao_ressuprimento)) AS NUMERIC), 2);
        ELSE 
            p_ponto_pedido = round(cast(p_estoque_seguranca + (rec_categoria.cmm_peso * (rec_categoria.tempo_ressuprimento + rec_categoria.desvio_padrao_ressuprimento)) AS NUMERIC), 2);
        END IF;
    
    
        -- estoque maximo
        IF rec_categoria.perfil_demanda = 'OCASIONAL' THEN
        
            IF (rec_categoria.cobertura_manual_categoria > 0) AND (((rec_categoria.cmm_peso / 30) * rec_categoria.cobertura_manual_categoria) > p_ponto_pedido) THEN
                p_estoque_maximo = (((rec_categoria.cmm_peso / 2) / 30) * rec_categoria.cobertura_manual_categoria); 
            ELSE 
                p_estoque_maximo = (p_ponto_pedido + (rec_categoria.cmm_peso / 2));
            END IF;
         
        ELSEIF (rec_categoria.cobertura_manual_categoria > 0) THEN 
        
            IF ((rec_categoria.cmm_peso / 30) * rec_categoria.cobertura_manual_categoria) > p_ponto_pedido THEN
                p_estoque_maximo = ((rec_categoria.cmm_peso / 30) * rec_categoria.cobertura_manual_categoria); 
            ELSE
               -- Cobertura Máxima atribuida ao item e inferior ao tempo de reposição do mesmo;
               p_estoque_maximo = (p_ponto_pedido + rec_categoria.cmm_peso);
            END IF;
        
        ELSE 
            p_estoque_maximo = (p_ponto_pedido + rec_categoria.cmm_peso);
        END IF;
    
        -- estoque em transito        
        SELECT sum(compra_transito) INTO rec_categoria.estoque_transito_peso
        FROM (
            SELECT COALESCE(sum(qtde_pendente), 0) AS compra_transito
            FROM requisicoes r  
                INNER JOIN produtos_filial pf ON pf.filial = r.idfilial AND pf.idproduto = r.idproduto 
                INNER JOIN grupo_filial gf ON gf.filial = pf.filial 
            WHERE 
                r.qtde_pendente  > 0
                AND gf.id_grupo = rec_categoria.id_grupo
                AND pf.idproduto IN (
                    SELECT DISTINCT id_produto_mp 
                    FROM produtos_categoria_mp_pa pc
                    WHERE pc.id_categoria = rec_categoria.id_categoria
                )
        
            UNION 
        
            SELECT COALESCE(sum(qtde_pendente * pf.peso), 0) AS compra_transito
            FROM requisicoes r  
                INNER JOIN produtos_filial pf ON pf.filial = r.idfilial AND pf.idproduto = r.idproduto 
                INNER JOIN grupo_filial gf ON gf.filial = pf.filial 
            WHERE 
                r.qtde_pendente  > 0
                AND gf.id_grupo = rec_categoria.id_grupo
                AND pf.idproduto IN (
                    SELECT DISTINCT id_produto_pa 
                    FROM produtos_categoria_mp_pa pc
                    WHERE pc.id_categoria = rec_categoria.id_categoria
                )
        ) t;
           
    
        -- calcula a sugestao de compra para itens que nao estão em transito
        IF (rec_categoria.estoque_transito_peso = 0 AND rec_categoria.perfil_demanda = 'OCASIONAL' AND rec_categoria.estoque_peso <  p_ponto_pedido) THEN 
        
            p_lote_compras_bruto =  (rec_categoria.cmm_peso / 2);
            p_lote_compras = gerar_lote_embalagem(p_lote_compras_bruto, rec_categoria.lote_minimo);
        
         ELSEIF (rec_categoria.estoque_transito_peso = 0 AND rec_categoria.perfil_demanda <> 'OCASIONAL' AND rec_categoria.estoque_peso <  p_ponto_pedido) THEN 
         
            p_lote_compras_bruto = round(cast((p_estoque_maximo + (rec_categoria.cmm_peso * (rec_categoria.tempo_ressuprimento + rec_categoria.desvio_padrao_ressuprimento)) - rec_categoria.estoque_peso) AS NUMERIC), 2);
            p_lote_compras = gerar_lote_embalagem(p_lote_compras_bruto, rec_categoria.lote_minimo);
        
         ELSE
         
            p_lote_compras_bruto = 0;
            p_lote_compras  = 0;
        
         END IF;
    
        -- se cobertura de estoque for menor que o tempo de ressuprimento então compre o emax
        IF (p_lote_compras_bruto > 0 AND rec_categoria.cobertura_estoque_peso < rec_categoria.tempo_ressuprimento) THEN 
               p_lote_compras_bruto = p_estoque_maximo;
               p_lote_compras  = gerar_lote_embalagem(p_lote_compras_bruto, rec_categoria.lote_minimo);
        END IF;
       
        UPDATE produtos_compras_categorias_mp_pa
        SET
            descricao_categoria = rec_categoria.descricao_categoria,
            estoque_peso = rec_categoria.estoque_peso,
            estoque_mp_peso = rec_categoria.estoque_mp_peso,
            estoque_pa = rec_categoria.estoque_pa,
            estoque_pa_peso = rec_categoria.estoque_pa_peso,
            estoque_bloqueado_peso = rec_categoria.estoque_bloqueado_peso,
            estoque_avaria_peso = rec_categoria.estoque_avaria_peso,
            estoque_reservado_peso = rec_categoria.estoque_reservado_peso,
            estoque_similar_peso = rec_categoria.estoque_similar_peso,
            cobertura_estoque_peso = rec_categoria.cobertura_estoque_peso,
            estoque_seguranca = p_estoque_seguranca,
            ponto_pedido = p_ponto_pedido,
            estoque_maximo = p_estoque_maximo,
            cmm_peso = rec_categoria.cmm_peso,
            cmm_pa_peso = rec_categoria.cmm_pa_peso,
            cmm_pa = rec_categoria.cmm_pa,
            desvio_padrao_consumo_peso = rec_categoria.desvio_padrao_consumo_peso,
            tempo_medio_ressuprimento = rec_categoria.tempo_medio_ressuprimento,
            prazo_medio_recebimento = rec_categoria.prazo_medio_recebimento,
            tempo_ressuprimento = rec_categoria.tempo_ressuprimento,
            desvio_padrao_ressuprimento = rec_categoria.desvio_padrao_ressuprimento,
            coeficiente_variacao = rec_categoria.coeficiente_variacao,
            estoque_transito_peso = rec_categoria.estoque_transito_peso,
            arvore_decisao = rec_categoria.arvore_decisao,
            nivel_servico = rec_categoria.nivel_servico,
            peso_compras = rec_categoria.peso_compras,
            lote_minimo = rec_categoria.lote_minimo,
            lote_compras_bruto = p_lote_compras_bruto ,
            lote_compras = p_lote_compras,
            perfil_demanda = rec_categoria.perfil_demanda,
            tempo_medio_apanhe = rec_categoria.tempo_medio_apanhe,
            unidade_compra = rec_categoria.unidade_compra,
            cobertura_manual_categoria = rec_categoria.cobertura_manual_categoria,
            custo_medio_unitario = rec_categoria.custo_medio_unitario,
            preco_medio_compra = rec_categoria.preco_medio_compra,
            idunidade_medida = rec_categoria.idunidade_medida,
            fator_conversao = rec_categoria.fator_conversao,
            fes = rec_categoria.fes,
            classificacao_financeira = rec_categoria.classificacao_financeira,
            classificacao_criticidade = rec_categoria.classificacao_criticidade,
            classificacao_comprabilidade = rec_categoria.classificacao_comprabilidade,
            classificacao_popularidade = rec_categoria.classificacao_popularidade,
            ultimo_preco_compra = rec_categoria.ultimo_preco_compra,
            processamento = current_timestamp,
            flag = NULL 
        WHERE 
            id_grupo = rec_categoria.id_grupo
            AND id_categoria = rec_categoria.id_categoria;
        
        IF NOT FOUND then
            INSERT INTO produtos_compras_categorias_mp_pa (
                id_grupo,
                id_categoria,
                descricao_categoria,
                idcomprador,
                estoque_peso,
                estoque_mp_peso,
                estoque_pa,
                estoque_pa_peso,
                estoque_bloqueado_peso,
                estoque_avaria_peso,
                estoque_reservado_peso,
                estoque_similar_peso,
                cobertura_estoque_peso,
                estoque_seguranca,
                ponto_pedido,
                estoque_maximo,
                cmm_peso,
                cmm_pa_peso,
                cmm_pa,
                desvio_padrao_consumo_peso,
                tempo_medio_ressuprimento,
                prazo_medio_recebimento,
                tempo_ressuprimento,
                desvio_padrao_ressuprimento,
                coeficiente_variacao,
                estoque_transito_peso,
                arvore_decisao,
                nivel_servico,
                peso_compras,
                lote_minimo,
                lote_compras_bruto,
                lote_compras,
                perfil_demanda,
                tempo_medio_apanhe,
                unidade_compra,
                cobertura_manual_categoria,
                custo_medio_unitario,
                preco_medio_compra,
                idunidade_medida,
                fator_conversao,
                fes,
                classificacao_financeira,
                classificacao_criticidade,
                classificacao_comprabilidade,
                classificacao_popularidade,
                ultimo_preco_compra,
                processamento,
                flag
            )
            VALUES (
                rec_categoria.id_grupo,
                rec_categoria.id_categoria,
                rec_categoria.descricao_categoria,
                rec_categoria.idcomprador,
                rec_categoria.estoque_peso,
                rec_categoria.estoque_mp_peso,
                rec_categoria.estoque_pa,
                rec_categoria.estoque_pa_peso,
                rec_categoria.estoque_bloqueado_peso,
                rec_categoria.estoque_avaria_peso,
                rec_categoria.estoque_reservado_peso,
                rec_categoria.estoque_similar_peso,
                rec_categoria.cobertura_estoque_peso,
                p_estoque_seguranca,
                p_ponto_pedido,
                p_estoque_maximo,
                rec_categoria.cmm_peso,
                rec_categoria.cmm_pa_peso,
                rec_categoria.cmm_pa,
                rec_categoria.desvio_padrao_consumo_peso,
                rec_categoria.tempo_medio_ressuprimento,
                rec_categoria.prazo_medio_recebimento,
                rec_categoria.tempo_ressuprimento,
                rec_categoria.desvio_padrao_ressuprimento,
                rec_categoria.coeficiente_variacao,
                rec_categoria.estoque_transito_peso,
                rec_categoria.arvore_decisao,
                rec_categoria.nivel_servico,
                rec_categoria.peso_compras,
                rec_categoria.lote_minimo,
                p_lote_compras_bruto,
                p_lote_compras,
                rec_categoria.perfil_demanda,
                rec_categoria.tempo_medio_apanhe,
                rec_categoria.unidade_compra,
                rec_categoria.cobertura_manual_categoria,
                rec_categoria.custo_medio_unitario,
                rec_categoria.preco_medio_compra,
                rec_categoria.idunidade_medida,
                rec_categoria.fator_conversao,
                rec_categoria.fes,
                rec_categoria.classificacao_financeira,
                rec_categoria.classificacao_criticidade,
                rec_categoria.classificacao_comprabilidade,
                rec_categoria.classificacao_popularidade,
                rec_categoria.ultimo_preco_compra,
                current_timestamp,
                NULL
            );
        END IF;
        
    END LOOP;

    DELETE FROM produtos_compras_categorias_mp_pa WHERE flag = 'D';
END;
$function$

