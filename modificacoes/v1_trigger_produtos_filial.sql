CREATE OR REPLACE FUNCTION public.trigger_produtos_filial ()
    RETURNS TRIGGER
    LANGUAGE plpgsql
    AS $function$
DECLARE
    cof_variacao numeric;
    existe numeric;
    saldo_drp numeric;
    consumo_horizonte numeric;
    desvio_consumo_horizonte numeric;
    tempo_distribuicao numeric;
    compra_pendente numeric;
    amplitude numeric;
    saldo_futuro numeric;
    resto_lote numeric;
    ressup_manual varchar;
    ressup_qtde_manual numeric;
    estoque_real numeric;
    cobertura_compras int8;
    cobertura_esseg numeric;
    rec_analise_requisicoes record;
    v_ctx_base text;
    v_ctx_erro text;
BEGIN
    v_ctx_base := format('ERRO | trigger=%s | tabela=%s | operacao=%s | produto=%s | filial=%s', TG_NAME, TG_TABLE_NAME, TG_OP, NEW.idproduto, NEW.filial);
    --	 Estoque Transferencia DRP
    NEW.estoque_transito_drp = coalesce((
        SELECT
            sum(GREATEST (v.qtde_item, 0))
        FROM produtos_separacao v
        WHERE
            v.filial_destino = NEW.filial
            AND v.idproduto = NEW.idproduto), 0);
    -- Recuperar Comprador pela Carteira de Compradores
    --NEW.idcomprador = get_idcomprador_carteira_comprador(new.filial,new.idproduto);
    -- Evitar Saldos Negativos no Estoque;
    IF NEW.estoque < 0 THEN
        NEW.estoque = 0;
    END IF;
    IF NEW.estoque_bloqueado < 0 THEN
        NEW.estoque_bloqueado = 0;
    END IF;
    IF NEW.estoque_reservado < 0 THEN
        NEW.estoque_reservado = 0;
    END IF;
    --Ajuste Ressuprimento Manual
    IF NEW.tipo_ressuprimento = 'F' THEN
        SELECT
            ressuprimento_manual,
            ressuprimento_qtde_dias
        INTO
            ressup_manual,
            ressup_qtde_manual
        FROM
            fornecedor f2
        WHERE
            f2.id = NEW.idfornecedor;
        NEW.ressuprimento_manual = coalesce(ressup_manual, 'N');
        NEW.ressuprimento_manual_dias = coalesce(ressup_qtde_manual, 0);
    END IF;
    NEW.arvore_decisao = coalesce(NEW.classificacao_financeira, '') || coalesce(NEW.classificacao_criticidade, '') || coalesce(cast(NEW.classificacao_comprabilidade AS varchar), '') || coalesce(NEW.classificacao_popularidade, '');
    IF length(coalesce(NEW.arvore_decisao, '')) <> 4 THEN
        NEW.arvore_decisao = COALESCE((
            SELECT
                coalesce(psm.arvore_decisao, 'CX2R')
            FROM prismas_filiais psm
            WHERE
                psm.filial = NEW.filial
                AND psm.idproduto = NEW.idproduto
                AND data_ref = to_char(CURRENT_DATE, 'YYYY-MM-01')::date LIMIT 1), 'CX2R');
        NEW.classificacao_financeira = substring(NEW.arvore_decisao, 1, 1);
        NEW.classificacao_criticidade = substring(NEW.arvore_decisao, 2, 1);
        NEW.classificacao_comprabilidade = substring(NEW.arvore_decisao, 3, 1);
        NEW.classificacao_popularidade = substring(NEW.arvore_decisao, 4, 1);
    END IF;
    NEW.nivel_servico = (
        SELECT
            getNivelServico (NEW.arvore_decisao));
    NEW.fes = (
        SELECT
            getFes (NEW.arvore_decisao));
    NEW.manter_estoque = (
        SELECT
            getManterEstoque (NEW.arvore_decisao));
    NEW.peso_compras = (
        SELECT
            getPesoCompras (NEW.arvore_decisao, coalesce(NEW.classificacao_comprabilidade, 0)));
    IF NEW.ressuprimento_manual = 'S' THEN
        NEW.tempo_medio_ressuprimento = NEW.ressuprimento_manual_dias;
        NEW.tempo_ressuprimento = NEW.ressuprimento_manual_dias / 30;
        NEW.desvio_padrao_ressuprimento = 0;
    ELSE
        NEW.tempo_medio_ressuprimento = (
            SELECT
                get_tmr_filial (NEW.filial, NEW.idproduto));
        NEW.tempo_ressuprimento = (
            SELECT
                get_temp_ressup_filial (NEW.filial, NEW.idproduto));
        NEW.desvio_padrao_ressuprimento = (
            SELECT
                get_stddev_ressup_filial (NEW.filial, NEW.idproduto));
    END IF;
    NEW.desvio_padrao_consumo = (
        SELECT
            get_stddev_consumo (NEW.filial, NEW.idproduto, CURRENT_DATE));
    NEW.consumo_medio_mensal = (
        SELECT
            get_cmm_filial (NEW.filial, NEW.idproduto, CURRENT_DATE));
    --    Análise Filial Retira DRP
    --    new.desvio_padrao_cons_ret = coalesce(get_stddev_consumo_retira(new.filial,new.idproduto,current_date), 0);
    --    new.cmm_filial_retira = coalesce(get_cmm_filial_retira(new.filial,new.idproduto,current_date), 0);
    IF NEW.consumo_medio_mensal > 0 THEN
        NEW.cobertura_estoque = (round(cast(NEW.estoque / NEW.consumo_medio_mensal AS numeric), 2));
        NEW.coeficiente_variacao = (round(cast((NEW.desvio_padrao_consumo / NEW.consumo_medio_mensal) AS numeric) * 100));
    ELSE
        NEW.cobertura_estoque = 0;
        NEW.coeficiente_variacao = 0;
        NEW.consumo_medio_mensal = 0;
        NEW.desvio_padrao_consumo = 0;
    END IF;
    --Perfil Demanda;
    IF cast(NEW.coeficiente_variacao AS numeric) >= 0 AND cast(NEW.coeficiente_variacao AS numeric) <= 200 THEN
        NEW.perfil_demanda = 'REPETITIVO';
    ELSIF cast(NEW.coeficiente_variacao AS numeric) > 200
            AND cast(NEW.coeficiente_variacao AS numeric) <= 600 THEN
            NEW.perfil_demanda = 'ESTATISTICO';
    ELSE
        NEW.perfil_demanda = 'OCASIONAL';
    END IF;
    NEW.estoque_seguranca = (round(cast(NEW.desvio_padrao_consumo * NEW.fes AS numeric), 2));
    IF NEW.desvio_padrao_consumo = 0 THEN
        NEW.estoque_seguranca = (round(cast(NEW.consumo_medio_mensal * NEW.fes AS numeric), 2));
    END IF;
    IF NEW.perfil_demanda = 'OCASIONAL' THEN
        NEW.estoque_seguranca = (round(cast((NEW.consumo_medio_mensal / 2) * NEW.fes AS numeric), 2));
    END IF;
    cobertura_compras = (
        SELECT
            get_cobertura_compras_curva (NEW.filial, NEW.idproduto));
    -- Cobertura Manual
    IF NEW.cobertura_manual_produto > 0 OR cobertura_compras > 0 THEN
        IF cobertura_compras > 0 THEN
            NEW.cobertura_manual_produto = cobertura_compras;
        END IF;
        --new.estoque_seguranca = ((new.consumo_medio_mensal/30)*new.cobertura_manual_produto)*0.30;
        NEW.estoque_seguranca = (NEW.consumo_medio_mensal * 0.30);
    END IF;
    -- cobertura manual do eseg
    cobertura_esseg = (
        SELECT
            get_cobertura_esseg (NEW.filial, NEW.idproduto));
    IF NEW.status_tempo_esseg > 0 AND cobertura_esseg > 0 THEN
        NEW.estoque_seguranca = (NEW.consumo_medio_mensal::numeric / 30::numeric) * cobertura_esseg;
    END IF;
    NEW.ponto_pedido = round(cast(NEW.estoque_seguranca + (NEW.consumo_medio_mensal * (NEW.tempo_ressuprimento + NEW.desvio_padrao_ressuprimento)) AS numeric), 2);

    /*Alterado para comercio + estoque de segurança - Retirado em 10/02/2019*/
    NEW.estoque_maximo = (NEW.ponto_pedido + NEW.consumo_medio_mensal);
    --Cobertura Manual
    IF NEW.cobertura_manual_produto > 0 OR cobertura_compras > 0 THEN
        IF ((NEW.consumo_medio_mensal / 30) * NEW.cobertura_manual_produto) > NEW.ponto_pedido THEN
            NEW.estoque_maximo = ((NEW.consumo_medio_mensal / 30) * NEW.cobertura_manual_produto);
        ELSE
            -- Cobertura Máxima atribuida ao item e inferior ao tempo de reposição do mesmo;
            NEW.estoque_maximo = (NEW.ponto_pedido + NEW.consumo_medio_mensal);
        END IF;
    ELSE
        NEW.estoque_maximo = (NEW.ponto_pedido + NEW.consumo_medio_mensal);
    END IF;
    NEW.tempo_medio_apanhe = (
        SELECT
            get_tma_filial (NEW.filial, NEW.idproduto, CURRENT_DATE));

    /*
     new.ultima_riquisicao_entrada = (select max(id_solicitacao) from vw_requisicoes where cast(idproduto as varchar) =new.idproduto);
     new.data_ultima_riquisicao = (select max(data_solicitacao) from vw_requisicoes where cast(idproduto as varchar)=new.idproduto);
     new.ultimo_pedido_compra = (select max(ordem_compra) from vw_requisicoes where cast(idproduto as varchar)=new.idproduto);
     new.data_ultima_compra = (select max(data_entrada) from vw_requisicoes where cast(idproduto as varchar)=new.idproduto);
     */
    NEW.status_ultima_compra = (
        SELECT
            CASE WHEN atraso > 0 THEN
                'PENDENTE COM ATRASO DE ' || atraso || ' DIA(S)'
            ELSE
                'ENTRADA CONFIRMADA'
            END AS status
        FROM
            vw_requisicoes
        WHERE
            cast(idproduto AS varchar) = NEW.idproduto
        GROUP BY
            atraso
        ORDER BY
            atraso DESC
        LIMIT 1);
    SELECT
        max(v.id_solicitacao) AS id_solicitacao,
        max(v.data_solicitacao) AS data_solicitacao,
        max(v.ordem_compra) AS ordem_compra,
        max(v.data_entrada) AS data_entrada
    INTO
        rec_analise_requisicoes
    FROM
        vw_requisicoes v
    WHERE
        v.idproduto = NEW.idproduto;
    NEW.ultima_riquisicao_entrada = rec_analise_requisicoes.id_solicitacao;
    NEW.data_ultima_riquisicao = rec_analise_requisicoes.data_solicitacao;
    NEW.ultimo_pedido_compra = rec_analise_requisicoes.ordem_compra;
    NEW.data_ultima_compra = rec_analise_requisicoes.data_entrada;
    --Modificado o filtro para data_entrada nula tirando atraso > 0
    NEW.status_suprimento_sku = (
        SELECT
            CASE WHEN (
                SELECT
                    count(*)
                FROM
                    vw_requisicoes
                WHERE
                    idproduto = NEW.idproduto
                    AND qtde_pendente > 0
                    AND vw_requisicoes.filial = NEW.filial) > 0 THEN
                'AGUARDANDO ENTRADA'
            WHEN (NEW.estoque <= NEW.ponto_pedido
                AND NEW.ponto_pedido > 0) THEN
                'RESSUPRIR'
            ELSE
                'OK'
            END
        FROM
            produtos_filial
        WHERE
            idproduto = NEW.idproduto
            AND filial = NEW.filial);
    -- Modelos QR - Poisson
    IF NEW.perfil_demanda = 'OCASIONAL' THEN
        NEW.taxa_media_poisson = round(cast(NEW.tempo_medio_apanhe * (NEW.tempo_ressuprimento * 30) AS numeric), 2);
        NEW.lote_medio_poisson = (
            SELECT
                getLoteMedioQR (NEW.idproduto));
        NEW.desvio_padrao_poisson = (SQRT(NEW.taxa_media_poisson) * NEW.lote_medio_poisson);
        NEW.estoque_seguranca_poisson = round(cast(NEW.fes * NEW.desvio_padrao_poisson AS numeric), 2);
        NEW.ponto_pedido_poisson = round(cast((NEW.lote_medio_poisson * NEW.taxa_media_poisson) + NEW.estoque_seguranca_poisson AS numeric), 2);
        NEW.estoque_maximo_poisson = round(cast((NEW.ponto_pedido_poisson + NEW.lote_medio_poisson) AS numeric), 2);
        NEW.ponto_pedido = round(cast(NEW.estoque_seguranca + ((NEW.consumo_medio_mensal / 2) * (NEW.tempo_ressuprimento + NEW.desvio_padrao_ressuprimento)) AS numeric), 2);
        NEW.estoque_maximo = (NEW.ponto_pedido + (NEW.consumo_medio_mensal / 2));
        IF NEW.cobertura_manual_produto > 0 OR cobertura_compras > 0 THEN
            IF (((NEW.consumo_medio_mensal / 2) / 30) * NEW.cobertura_manual_produto) > NEW.ponto_pedido THEN
                NEW.estoque_maximo = (((NEW.consumo_medio_mensal / 2) / 30) * NEW.cobertura_manual_produto);
            ELSE
                -- Cobertura Máxima atribuida ao item e inferior ao tempo de reposição do mesmo;
                NEW.estoque_maximo = (NEW.ponto_pedido + (NEW.consumo_medio_mensal / 2));
            END IF;
        ELSE
            NEW.estoque_maximo = (NEW.ponto_pedido + (NEW.consumo_medio_mensal / 2));
        END IF;
    ELSE
        NEW.taxa_media_poisson = 0;
        NEW.lote_medio_poisson = 0;
        NEW.desvio_padrao_poisson = 0;
        NEW.estoque_seguranca_poisson = 0;
        NEW.ponto_pedido_poisson = 0;
        NEW.estoque_maximo_poisson = 0;
    END IF;
    NEW.lote_compras = 0;
    NEW.lote_minimo_compras = 0;
    -- Lotes de Compra
    IF NEW.perfil_demanda <> 'OCASIONAL' AND NEW.status_suprimento_sku = 'RESSUPRIR' THEN
        NEW.lote_compras = (round(cast((NEW.estoque_maximo + (NEW.consumo_medio_mensal * (NEW.tempo_ressuprimento + NEW.desvio_padrao_ressuprimento)) - NEW.estoque) AS numeric), 2));
    ELSIF NEW.perfil_demanda <> 'OCASIONAL'
            AND NEW.status_suprimento_sku = 'OK' THEN
            NEW.lote_compras = (round(cast((NEW.estoque_maximo + (NEW.consumo_medio_mensal * (NEW.tempo_ressuprimento + NEW.desvio_padrao_ressuprimento)) - NEW.estoque) AS numeric), 2));
    END IF;
    -- Ajustar apos calculos de poisson
    IF NEW.perfil_demanda = 'OCASIONAL' AND NEW.status_suprimento_sku = 'RESSUPRIR' THEN
        NEW.lote_compras = ceil((NEW.consumo_medio_mensal / 2));
    END IF;
    --Zera lote compras caso seja < 0
    IF NEW.lote_compras < 0 THEN
        NEW.lote_compras = 0;
    END IF;
    NEW.lote_minimo = coalesce(nullif (NEW.lote_minimo::numeric, 0), 1);
    IF NEW.lote_minimo IS NULL THEN
        NEW.lote_minimo_compras = NEW.lote_compras;
    ELSE
        resto_lote = ceil(mod(NEW.lote_compras::numeric, NEW.lote_minimo::numeric)) / coalesce(nullif (NEW.lote_minimo::numeric, 0), 1);
        IF resto_lote >= 0.5 THEN
            NEW.lote_minimo_compras = ((NEW.lote_minimo::numeric - MOD(NEW.lote_compras::numeric, NEW.lote_minimo::numeric)) + NEW.lote_compras::numeric);
        ELSE
            NEW.lote_minimo_compras = ((NEW.lote_compras::numeric - MOD(NEW.lote_compras::numeric, NEW.lote_minimo::numeric)));
        END IF;
        IF NEW.lote_minimo_compras > 0 AND NEW.status_suprimento_sku = 'RESSUPRIR' THEN
            NEW.lote_compras = NEW.lote_minimo_compras;
        ELSIF NEW.lote_minimo_compras = 0
                AND NEW.status_suprimento_sku = 'RESSUPRIR' THEN
                NEW.status_suprimento_sku = 'SOB ENCOMENDA';
        END IF;
    END IF;
    NEW.processamento = CURRENT_TIMESTAMP;
    -- Lógica Gatilho de Compras
    -- Lógica Gatilho de Compras
    /*   if new.status_suprimento_sku = 'RESSUPRIR' and new.revenda='S' and new.status <> 'FL' then 
     
     select count(*) into existe from hist_gatilho_compras where idproduto=new.idproduto and status='A';
     
     if existe = 0 then 
     
     INSERT INTO public.hist_gatilho_compras
     (idproduto, filial, "data", status, estoque, ponto_pedido, sugestao,arvore_decisao,tempo_reposicao)
     VALUES(new.idproduto, new.filial, current_date,'A',new.estoque,new.ponto_pedido,new.lote_compras,new.arvore_decisao,new.tempo_medio_ressuprimento);
     
     end if;
     
     elsif new.status_suprimento_sku = 'AGUARDANDO ENTRADA' then 
     
     
     UPDATE public.hist_gatilho_compras SET status='F', idrequisicao=new.ultima_riquisicao_entrada::numeric,data_requisicao=new.data_ultima_riquisicao WHERE idproduto=new.idproduto AND status='A';
     
     else
     
     select count(*) into existe from hist_gatilho_compras where idproduto=new.idproduto and status='A';
     
     if existe > 0 then
     
     
     UPDATE public.hist_gatilho_compras SET status='F', idrequisicao=0 WHERE idproduto=new.idproduto AND status='A';
     
     else
     
     delete from public.hist_gatilho_compras  WHERE idproduto=new.idproduto and  status='F' and idrequisicao=0;
     
     end if;
     
     
     end if;
     
     new.tempo_gatilho = coalesce((select (current_date - "data") from hist_gatilho_compras where idproduto=new.idproduto and status='A'),0);
     */
    --Nível de Estoque
    NEW.nivel_estoque = coalesce(round(NEW.estoque / nullif (NEW.estoque_maximo, 0), 4), 0) * 100;
    --DRP
    estoque_real = coalesce(NEW.estoque, 0) - coalesce(NEW.estoque_bloqueado, 0) - coalesce(NEW.estoque_reservado, 0) - coalesce(NEW.estoque_similar, 0);
    --Pedido de compra mais antigo
    SELECT
        (data_prevista_cal - CURRENT_DATE),
        qtde_pendente
    INTO
        amplitude,
        compra_pendente
    FROM
        analise_requisicoes r
    WHERE
        r.filial::numeric = NEW.filial
        AND r.idproduto = NEW.idproduto
        AND r.qtde_pendente > 0
        AND qtde_entregue = 0
    ORDER BY
        data_prevista_cal
    LIMIT 1;
    compra_pendente = coalesce(compra_pendente, 0);
    amplitude = coalesce(amplitude, -1);
    saldo_drp = 0;
    IF NEW.consumo_medio_mensal = 0 AND estoque_real > 0 THEN
        saldo_drp = NEW.estoque;
    ELSIF NEW.estoque_maximo <= 0
            OR estoque_real <= 0 THEN
            saldo_drp = 0;
        --   elsif new.estoque < new.ponto_pedido then -- Ajuste Neto
        --    saldo_drp=0;
    ELSE
        --Nova lógica para disponibilidade estoque para DRP com mercadoria em trânsito
        IF compra_pendente > 0 AND amplitude > 0 AND amplitude < 30 THEN
            consumo_horizonte = (NEW.consumo_medio_mensal / 30) * amplitude;
            desvio_consumo_horizonte = (NEW.desvio_padrao_consumo / 30) * amplitude;
            saldo_futuro = coalesce(estoque_real - consumo_horizonte + desvio_consumo_horizonte + compra_pendente, 0);
            IF (saldo_futuro - NEW.ponto_pedido) < 0 THEN
                saldo_drp = 0;
                elseif (saldo_futuro - NEW.ponto_pedido) > estoque_real THEN
                saldo_drp = coalesce(ceil(estoque_real - NEW.estoque_seguranca), 0);
            ELSE
                saldo_drp = coalesce(ceil(estoque_real - NEW.estoque_seguranca), 0);
            END IF;
        ELSE
            saldo_drp = coalesce(ceil(estoque_real - NEW.ponto_pedido), 0);
        END IF;
    END IF;
    IF saldo_drp < 0 THEN
        NEW.estoque_drp = 0;
    ELSE
        NEW.estoque_drp = saldo_drp;
    END IF;
    tempo_distribuicao = 5;
    consumo_horizonte = (NEW.consumo_medio_mensal / 30) * tempo_distribuicao;
    desvio_consumo_horizonte = (NEW.desvio_padrao_consumo / 30) * tempo_distribuicao;
    IF NEW.estoque_drp <> 0 THEN
        NEW.status_drp = 'DISP DRP';
        NEW.saldo_necessidade_drp = 0;
        elseif estoque_real <= NEW.ponto_pedido
            AND NEW.consumo_medio_mensal > 0 THEN
            NEW.status_drp = 'DRP';
        NEW.saldo_necessidade_drp = ceil((NEW.estoque_maximo + (consumo_horizonte + desvio_consumo_horizonte)) - (estoque_real + (NEW.consumo_medio_mensal / 30)));
        --Embalagem Master - Distribuir
        NEW.saldo_necessidade_drp = (NEW.embalagem_master - mod(NEW.saldo_necessidade_drp, NEW.embalagem_master)) + NEW.saldo_necessidade_drp;
        elseif (estoque_real - (consumo_horizonte + desvio_consumo_horizonte)) <= NEW.ponto_pedido
            AND NEW.consumo_medio_mensal > 0 THEN
            NEW.status_drp = 'ANT DRP';
        NEW.saldo_necessidade_drp = ceil((NEW.estoque_maximo + (consumo_horizonte + desvio_consumo_horizonte)) - (estoque_real + (NEW.consumo_medio_mensal / 30)));
        --Embalagem Master - Distribuir
        NEW.saldo_necessidade_drp = (NEW.embalagem_master - mod(NEW.saldo_necessidade_drp, NEW.embalagem_master)) + NEW.saldo_necessidade_drp;
    ELSE
        NEW.status_drp = 'OK';
        NEW.saldo_necessidade_drp = 0;
    END IF;
    -- Preco Médio Vendas
    NEW.preco_medio_venda = get_preco_medio_venda_filial (NEW.filial, NEW.idproduto);
    -- Análise Financeira
    NEW.total_estoque_custo = coalesce(round(NEW.custo_unitario * NEW.estoque, 4), 0);
    NEW.total_estoque_venda = coalesce(round(NEW.valor_unitario * NEW.estoque, 4), 0);
    NEW.fator_markup = coalesce(round(NEW.total_estoque_venda / nullif (NEW.total_estoque_custo, 0), 4), 0);
    NEW.projecao_venda = coalesce(round(NEW.consumo_medio_mensal * NEW.valor_unitario, 4), 0);
    NEW.projecao_rentabilidade = coalesce(round((NEW.projecao_venda / nullif (NEW.fator_markup, 0)), 4), 0);
    --Grupo de Compras
    --new.grupo_compra = coalesce((select id_grupo from grupo_filial gf where gf.filial=new.filial),0);
    -- produto fica fora de linha quando é herdado por outro
    IF (
        SELECT
            count(*)
        FROM
            produtos_filial pf
        WHERE
            pf.heranca = NEW.idproduto AND pf.filial = NEW.filial) > 0 THEN
        NEW.status = 'FL';
    END IF;
    RETURN NEW;
    RAISE notice'Produto: %', NEW.idproduto;
EXCEPTION
    WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS v_ctx_erro = PG_EXCEPTION_CONTEXT;
        RAISE EXCEPTION '% | erro=% | contexto=%', v_ctx_base, SQLERRM, v_ctx_erro;
END;

$function$
