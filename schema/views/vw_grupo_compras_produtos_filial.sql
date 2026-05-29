--
-- PostgreSQL database dump
--

\restrict g6N4ehbsAj9hH80hE0ZMzpHcjqGR4GEcmHyeRVKNAvrL5r0sETmidxrU0COWksy

-- Dumped from database version 16.13 (Ubuntu 16.13-1.pgdg24.04+1)
-- Dumped by pg_dump version 16.13 (Ubuntu 16.13-1.pgdg24.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: vw_grupo_compras_produtos_filial; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.vw_grupo_compras_produtos_filial AS
 SELECT id_grupo,
    filial,
    idproduto,
    descricao_produto,
    idcomprador,
    idfornecedor,
    idfamilia_produto,
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
        CASE
            WHEN ((lote_compras_bruto > (0)::numeric) AND (lote_embalagem = (0)::numeric)) THEN 1
            ELSE 0
        END AS sob_encomenda,
    lote_embalagem AS lote_compras,
    preco_compra,
    custo_unitario,
    valor_unitario,
    estoque_bloqueado,
        CASE
            WHEN (((coeficiente_variacao)::numeric > (0)::numeric) AND ((coeficiente_variacao)::numeric <= (200)::numeric)) THEN 'REPETITIVO'::text
            WHEN (((coeficiente_variacao)::numeric > (200)::numeric) AND ((coeficiente_variacao)::numeric <= (600)::numeric)) THEN 'ESTATISTICO'::text
            ELSE 'OCASIONAL'::text
        END AS perfil_demanda,
    tempo_medio_apanhe,
    embalagem,
    idunidade_medida,
    ressuprimento_manual,
    ressuprimento_manual_dias,
    cod_produto,
    codigo_barras,
    fator_atuacao,
    estoque_avaria,
    peso,
    altura,
    largura,
    comprimento,
    ( SELECT max(r.data_solicitacao) AS max
           FROM public.requisicoes r
          WHERE (((r.idproduto)::text = (lote.idproduto)::text) AND (r.idfilial = lote.filial))) AS data_ultima_requisicao,
    estoque_reservado,
    multiplo_compra,
    unidade_master
   FROM ( SELECT a.id_grupo,
            a.filial,
            a.idproduto,
            a.descricao_produto,
            a.idcomprador,
            a.idfornecedor,
            a.idfamilia_produto,
            a.revenda,
            a.status,
            a.estoque,
            a.cobertura_estoque,
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
                    WHEN (((a.coeficiente_variacao)::numeric > (0)::numeric) AND (a.compra_transito = (0)::numeric) AND (a.estoque <= a.ponto_pedido) AND ((a.revenda)::text = 'S'::text) AND ((a.status)::text <> 'FL'::text)) THEN round(((a.estoque_maximo + (a.consumo_medio_mensal * (a.tempo_ressuprimento + a.desvio_padrao_ressuprimento))) - a.estoque), 2)
                    WHEN (((a.coeficiente_variacao)::numeric = (0)::numeric) AND (a.compra_transito = (0)::numeric) AND (a.estoque <= a.ponto_pedido) AND ((a.revenda)::text = 'S'::text) AND ((a.status)::text <> 'FL'::text)) THEN ceil((a.consumo_medio_mensal / (2)::numeric))
                    ELSE (0)::numeric
                END AS lote_compras_bruto,
            a.arvore_decisao,
            a.nivel_servico,
            a.peso_compras,
            a.unidade_compra,
            public.gerar_lote_embalagem(
                CASE
                    WHEN (((a.coeficiente_variacao)::numeric > (0)::numeric) AND (a.compra_transito = (0)::numeric) AND (a.estoque <= a.ponto_pedido) AND ((a.revenda)::text = 'S'::text) AND ((a.status)::text <> 'FL'::text)) THEN round(((a.estoque_maximo + (a.consumo_medio_mensal * (a.tempo_ressuprimento + a.desvio_padrao_ressuprimento))) - a.estoque), 2)
                    WHEN (((a.coeficiente_variacao)::numeric = (0)::numeric) AND (a.compra_transito = (0)::numeric) AND (a.estoque <= a.ponto_pedido) AND ((a.revenda)::text = 'S'::text) AND ((a.status)::text <> 'FL'::text)) THEN ceil((a.consumo_medio_mensal / (2)::numeric))
                    ELSE (0)::numeric
                END, COALESCE(a.lote_minimo, (1)::numeric)) AS lote_embalagem,
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
            a.fator_atuacao,
            a.estoque_avaria,
            a.peso,
            a.altura,
            a.largura,
            a.comprimento,
            a.estoque_reservado,
            a.multiplo_compra,
            a.unidade_master
           FROM ( SELECT p.filial,
                    g.id_grupo,
                    p.idproduto,
                    p.descricao_produto,
                    p.idcomprador,
                    p.idfornecedor,
                    p.idfamilia_produto,
                    p.revenda,
                    p.status,
                    p.unidade_compra,
                    (p.estoque * p.fator_conversao) AS estoque,
                    NULLIF(p.cobertura_estoque, (0)::numeric) AS cobertura_estoque,
                    (p.estoque_seguranca * p.fator_conversao) AS estoque_seguranca,
                    (p.ponto_pedido * p.fator_conversao) AS ponto_pedido,
                    (p.estoque_maximo * p.fator_conversao) AS estoque_maximo,
                    (p.consumo_medio_mensal * p.fator_conversao) AS consumo_medio_mensal,
                    (p.desvio_padrao_consumo * p.fator_conversao) AS desvio_padrao_consumo,
                    p.tempo_medio_ressuprimento,
                    p.tempo_ressuprimento,
                    p.desvio_padrao_ressuprimento,
                    (p.coeficiente_variacao)::text AS coeficiente_variacao,
                    public.getcompra_transito_filial((p.filial)::numeric, p.idproduto) AS compra_transito,
                    (p.lote_minimo * p.fator_conversao) AS lote_minimo,
                    p.arvore_decisao,
                    p.nivel_servico,
                    p.peso_compras,
                    p.preco_compra,
                    p.custo_unitario,
                    p.valor_unitario,
                    (p.estoque_bloqueado * p.fator_conversao) AS estoque_bloqueado,
                    p.tempo_medio_apanhe,
                    p.embalagem,
                    p.idunidade_medida,
                    p.ressuprimento_manual,
                    COALESCE(p.ressuprimento_manual_dias, (0)::numeric) AS ressuprimento_manual_dias,
                    p.cod_produto,
                    p.codigo_barras,
                    p.fator_atuacao,
                    p.estoque_avaria,
                    p.peso,
                    p.altura,
                    p.largura,
                    p.comprimento,
                    p.estoque_reservado,
                    p.multiplo_compra,
                    p.unidade_master
                   FROM (public.produtos_filial p
                     JOIN public.grupo_filial g ON ((p.filial = g.filial)))
                  ORDER BY (p.idproduto)::numeric, g.id_grupo, p.filial) a) lote;


--
-- PostgreSQL database dump complete
--

\unrestrict g6N4ehbsAj9hH80hE0ZMzpHcjqGR4GEcmHyeRVKNAvrL5r0sETmidxrU0COWksy

