--
-- PostgreSQL database dump
--

\restrict a0nKCcmiHOVzn32s5fT5r9yxNFjhFZl2TtGZ2LXdlR8QdaGfgdw4GLNMmcMN851

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
-- Name: analise_financeira_grupo; Type: MATERIALIZED VIEW; Schema: public; Owner: -
--

CREATE MATERIALIZED VIEW public.analise_financeira_grupo AS
 SELECT id_grupo,
    idfornecedor,
    razao_social,
    idproduto,
    descricao_produto,
    idfamilia_produto,
    descricao_familia_produto,
    idcomprador,
    nome_completo,
    custo_unitario,
    valor_unitario,
    estoque,
    arvore_decisao,
    estoque_seguranca,
    ponto_pedido,
    estoque_maximo,
    nivel_servico,
    peso_nivel_servico,
    ult_saida,
    tempo_ult_venda,
    qtde_dias_entrada,
    data_cadastro,
    consumo_medio_mensal,
        CASE
            WHEN ((estoque > (0)::numeric) AND (tempo_ult_venda >= 0) AND (tempo_ult_venda <= 30)) THEN 1
            WHEN ((estoque > (0)::numeric) AND (tempo_ult_venda > 30) AND (tempo_ult_venda <= 60)) THEN 2
            WHEN ((estoque > (0)::numeric) AND (tempo_ult_venda > 60) AND (tempo_ult_venda <= 90)) THEN 3
            WHEN ((estoque > (0)::numeric) AND (tempo_ult_venda > 90) AND (tempo_ult_venda <= 180)) THEN 4
            WHEN ((estoque > (0)::numeric) AND (tempo_ult_venda > 180) AND (tempo_ult_venda <= 270)) THEN 5
            WHEN ((estoque > (0)::numeric) AND (tempo_ult_venda > 270) AND (tempo_ult_venda <= 365)) THEN 6
            WHEN ((estoque > (0)::numeric) AND (tempo_ult_venda > 365)) THEN 7
            WHEN ((estoque > (0)::numeric) AND (COALESCE(tempo_ult_venda, '-1'::integer) = '-1'::integer) AND (COALESCE((('now'::text)::date - data_cadastro), qtde_dias_entrada) < 90) AND ((revenda)::text = 'S'::text) AND ((status)::text <> 'FL'::text)) THEN 9
            WHEN ((estoque > (0)::numeric) AND (COALESCE(tempo_ult_venda, '-1'::integer) = '-1'::integer)) THEN 8
            ELSE NULL::integer
        END AS grupo_venda,
        CASE
            WHEN (estoque > (ceil(estoque_maximo) * peso_nivel_servico)) THEN 'EXCESSO'::text
            WHEN (estoque = (0)::numeric) THEN 'RUPTURA'::text
            WHEN ((estoque > ponto_pedido) AND (estoque <= (ceil(estoque_maximo) * peso_nivel_servico))) THEN 'ADEQUADO'::text
            WHEN (estoque <= ponto_pedido) THEN 'EXPOSTO'::text
            ELSE NULL::text
        END AS status_produto,
    status,
    revenda,
    tempo_medio_ressuprimento
   FROM ( SELECT p.id_grupo,
            p.idfornecedor,
            f.razao_social,
            p.idproduto,
            p.descricao_produto,
            p.idfamilia_produto,
            familia_produtos.descricao_familia_produto,
            p.idcomprador,
            c.nome_completo,
            p.custo_unitario,
            p.valor_unitario,
            p.estoque,
            p.arvore_decisao,
            p.estoque_seguranca,
            p.ponto_pedido,
            p.estoque_maximo,
            p.nivel_servico,
            n.peso AS peso_nivel_servico,
            ( SELECT max(c2.emissao) AS max
                   FROM public.consumos c2
                  WHERE ((c2.filial IN ( SELECT gf.filial
                           FROM public.grupo_filial gf
                          WHERE (gf.id_grupo = p.id_grupo))) AND ((c2.idproduto)::text = (p.idproduto)::text))) AS ult_saida,
            ( SELECT (('now'::text)::date - max(c2.emissao))
                   FROM public.consumos c2
                  WHERE ((c2.filial IN ( SELECT gf.filial
                           FROM public.grupo_filial gf
                          WHERE (gf.id_grupo = p.id_grupo))) AND ((c2.idproduto)::text = (p.idproduto)::text))) AS tempo_ult_venda,
            ( SELECT max(pf.data_cadastro) AS max
                   FROM public.produtos_filial pf
                  WHERE ((pf.filial IN ( SELECT gf.filial
                           FROM public.grupo_filial gf
                          WHERE (gf.id_grupo = p.id_grupo))) AND ((pf.idproduto)::text = (p.idproduto)::text))) AS data_cadastro,
            p.consumo_medio_mensal,
            p.status,
            p.revenda,
            ( SELECT COALESCE((('now'::text)::date - min(em.data_entrada)), 0) AS "coalesce"
                   FROM public.entrada_mercadorias em
                  WHERE ((em.idfilial IN ( SELECT gf.filial
                           FROM public.grupo_filial gf
                          WHERE (gf.id_grupo = p.id_grupo))) AND ((em.idproduto)::text = (p.idproduto)::text))) AS qtde_dias_entrada,
            p.tempo_medio_ressuprimento
           FROM ((((public.vw_grupo_compras_produtos p
             JOIN public.nivel_servico n ON (((n.descricao_nivel_servico)::text = (p.nivel_servico)::text)))
             JOIN public.fornecedor f ON ((p.idfornecedor = f.id)))
             JOIN public.familia_produtos ON ((p.idfamilia_produto = familia_produtos.idfamilia_produto)))
             JOIN public.comprador c ON ((c.id = p.idcomprador)))
          WHERE (p.estoque > (0)::numeric)) a
  WITH NO DATA;


--
-- PostgreSQL database dump complete
--

\unrestrict a0nKCcmiHOVzn32s5fT5r9yxNFjhFZl2TtGZ2LXdlR8QdaGfgdw4GLNMmcMN851

