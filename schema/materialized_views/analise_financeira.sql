--
-- PostgreSQL database dump
--

\restrict ruShU9IIGMMhf3b5FeAlUIu0PBNVcXcpfdKaBn0pwgsT1CjbfHdaEAq1VGZm1is

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: analise_financeira; Type: MATERIALIZED VIEW; Schema: public; Owner: -
--

CREATE MATERIALIZED VIEW public.analise_financeira AS
 SELECT id_grupo,
    filial,
    ano,
    mes,
    id_fornecedor,
    razao_social,
    idproduto,
    descricao_produto,
    descricao_familia_produto,
    custo_unitario,
    valor_unitario,
    estoque,
    data_solicitacao,
    arvore_decisao,
    estoque_seguranca,
    ponto_pedido,
    estoque_maximo,
    consumo_medio,
    sugestao,
    processamento,
    necessidade,
    data_cadastro,
    nivel_servico,
    peso_nivel_servico,
    status_produto,
    status_exposicao,
    peso_status,
    id_comprador,
    nome_completo,
    ult_saida,
    tempo_ult_venda,
    qtde_dias_entrada,
        CASE
            WHEN ((estoque > (0)::numeric) AND (tempo_ult_venda >= 0) AND (tempo_ult_venda <= 30)) THEN 1
            WHEN ((estoque > (0)::numeric) AND (tempo_ult_venda > 30) AND (tempo_ult_venda <= 60)) THEN 2
            WHEN ((estoque > (0)::numeric) AND (tempo_ult_venda > 60) AND (tempo_ult_venda <= 90)) THEN 3
            WHEN ((estoque > (0)::numeric) AND (tempo_ult_venda > 90) AND (tempo_ult_venda <= 180)) THEN 4
            WHEN ((estoque > (0)::numeric) AND (tempo_ult_venda > 180) AND (tempo_ult_venda <= 270)) THEN 5
            WHEN ((estoque > (0)::numeric) AND (tempo_ult_venda > 270) AND (tempo_ult_venda <= 365)) THEN 6
            WHEN ((estoque > (0)::numeric) AND (COALESCE(tempo_ult_venda, '-1'::integer) = '-1'::integer) AND (COALESCE((('now'::text)::date - data_cadastro), qtde_dias_entrada) < 90) AND ((revenda)::text = 'S'::text) AND ((status)::text <> 'FL'::text)) THEN 9
            WHEN ((estoque > (0)::numeric) AND (tempo_ult_venda > 365)) THEN 7
            WHEN ((estoque > (0)::numeric) AND (COALESCE(tempo_ult_venda, '-1'::integer) = '-1'::integer)) THEN 8
            ELSE NULL::integer
        END AS grupo_venda,
    revenda,
    status,
    tempo_medio_ressuprimento,
    idfamilia_produto
   FROM ( SELECT gf.id_grupo,
            s.filial,
            s.ano,
            s.mes,
            f.id AS id_fornecedor,
            f.razao_social,
            s.idproduto,
            p.descricao_produto,
            familia_produtos.descricao_familia_produto,
            (p.custo_unitario * p.fator_conversao) AS custo_unitario,
            (p.valor_unitario * p.fator_conversao) AS valor_unitario,
            s.estoque,
            s.data AS data_solicitacao,
            s.arvore_decisao,
            s.esseg AS estoque_seguranca,
            s.ppd AS ponto_pedido,
            s.emax AS estoque_maximo,
            s.cmm AS consumo_medio,
            s.sugestao_compras AS sugestao,
            s.processamento,
                CASE
                    WHEN (s.ppd > (s.estoque + public.getcompra_transito_grupo((gf.id_grupo)::numeric, s.idproduto))) THEN ((s.emax * n.peso) - (s.estoque + public.getcompra_transito_grupo((gf.id_grupo)::numeric, s.idproduto)))
                    ELSE (0)::numeric
                END AS necessidade,
            p.data_cadastro,
            p.nivel_servico,
            n.peso AS peso_nivel_servico,
                CASE
                    WHEN (s.estoque > (ceil(s.emax) * n.peso)) THEN 'EXCESSO'::text
                    WHEN (s.estoque = (0)::numeric) THEN 'RUPTURA'::text
                    WHEN ((s.estoque > s.ppd) AND (s.estoque <= (ceil(s.emax) * n.peso))) THEN 'ADEQUADO'::text
                    WHEN (s.estoque <= s.ppd) THEN 'EXPOSTO'::text
                    ELSE NULL::text
                END AS status_produto,
                CASE
                    WHEN ((s.estoque <= s.ppd) AND (s.estoque > (s.ppd - s.esseg))) THEN 'SUTIL'::text
                    WHEN ((s.estoque <= s.ppd) AND (s.estoque < (s.ppd - s.esseg))) THEN 'ELEVADA'::text
                    ELSE ' '::text
                END AS status_exposicao,
                CASE
                    WHEN (s.estoque > (ceil(s.emax) * n.peso)) THEN 10
                    WHEN ((s.estoque = (0)::numeric) AND (public.getcompra_transito_periodo_filial((s.filial)::numeric, s.idproduto, s.data) = (0)::numeric)) THEN 3
                    WHEN ((s.estoque = (0)::numeric) AND (public.getcompra_transito_periodo_filial((s.filial)::numeric, s.idproduto, s.data) <> (0)::numeric)) THEN 15
                    WHEN ((s.estoque > s.ppd) AND (s.estoque <= (ceil(s.emax) * n.peso))) THEN 45
                    WHEN ((s.estoque <= s.ppd) AND (public.getcompra_transito_periodo_filial((s.filial)::numeric, s.idproduto, s.data) = (0)::numeric)) THEN 7
                    WHEN ((s.estoque <= s.ppd) AND (public.getcompra_transito_periodo_filial((s.filial)::numeric, s.idproduto, s.data) <> (0)::numeric)) THEN 20
                    ELSE NULL::integer
                END AS peso_status,
            c.id AS id_comprador,
            c.nome_completo,
            ( SELECT max(c2.emissao) AS max
                   FROM public.consumos c2
                  WHERE ((c2.filial = s.filial) AND ((c2.idproduto)::text = (p.idproduto)::text))) AS ult_saida,
            ( SELECT (('now'::text)::date - max(c2.emissao))
                   FROM public.consumos c2
                  WHERE ((c2.filial = s.filial) AND ((c2.idproduto)::text = (p.idproduto)::text))) AS tempo_ult_venda,
            p.revenda,
            p.status,
            ( SELECT COALESCE((('now'::text)::date - min(em.data_entrada)), 0) AS "coalesce"
                   FROM public.entrada_mercadorias em
                  WHERE ((em.idfilial = p.filial) AND ((em.idproduto)::text = (p.idproduto)::text))) AS qtde_dias_entrada,
            p.tempo_medio_ressuprimento,
            p.idfamilia_produto
           FROM ((((((public.saldo_filiais s
             JOIN public.produtos_filial p ON (((p.filial = s.filial) AND ((p.idproduto)::text = (s.idproduto)::text))))
             JOIN public.nivel_servico n ON (((n.descricao_nivel_servico)::text = (p.nivel_servico)::text)))
             JOIN public.comprador c ON ((c.id = p.idcomprador)))
             JOIN public.fornecedor f ON ((p.idfornecedor = f.id)))
             JOIN public.familia_produtos ON ((p.idfamilia_produto = familia_produtos.idfamilia_produto)))
             JOIN public.grupo_filial gf ON ((gf.filial = s.filial)))
          WHERE ((s.data = (('now'::text)::date - 1)) AND (p.estoque > (0)::numeric))) a
  WITH NO DATA;


--
-- PostgreSQL database dump complete
--

\unrestrict ruShU9IIGMMhf3b5FeAlUIu0PBNVcXcpfdKaBn0pwgsT1CjbfHdaEAq1VGZm1is

