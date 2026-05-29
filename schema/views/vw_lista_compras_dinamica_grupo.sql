--
-- PostgreSQL database dump
--

\restrict 3b2WpObGuRn9QVGKqeYVmPjlv86k07skmZfsppAI2YJBD2iHiOXkpmhgpJoK5Bl

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
-- Name: vw_lista_compras_dinamica_grupo; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.vw_lista_compras_dinamica_grupo AS
 SELECT vgcp.id_grupo,
    vgcp.idfornecedor,
    vgcp.idcomprador,
    dpto.iddepartamento,
    dpto.descricao_departamento AS idfamilia_produto,
    'CP'::text AS tipo,
    vgcp.nivel_servico,
    "substring"(btrim(replace((vgcp.nivel_servico)::text, 'NIVEL'::text, ''::text)), 1, 1) AS status,
    vgcp.idproduto,
    vgcp.descricao_produto,
    vgcp.unidade_compra,
    vgcp.estoque,
    vgcp.lote_compras AS sugestao,
    'RESSUPRIR'::text AS status_suprimento_sku,
    vgcp.peso_compras,
    ( SELECT COALESCE((max(hgcg.data) - ('now'::text)::date), 0) AS tempo
           FROM public.hist_gatilho_compras_grupo hgcg
          WHERE ((hgcg.grupo = (vgcp.id_grupo)::numeric) AND ((hgcg.idproduto)::text = (vgcp.idproduto)::text) AND ((hgcg.tipo)::text = 'CP'::text) AND ((hgcg.status)::text = 'A'::text))) AS tempo_gatilho
   FROM (public.produtos_compras_grupo vgcp
     JOIN public.departamentos dpto ON ((dpto.iddepartamento = vgcp.idfamilia_produto)))
  WHERE ((vgcp.lote_compras > (0)::numeric) AND (vgcp.sob_encomenda = 0) AND ((vgcp.revenda)::text = 'S'::text) AND ((vgcp.revenda)::text <> 'FL'::text) AND ((dpto.descricao_departamento)::text !~~ '%FEIRAO%'::text) AND ((dpto.descricao_departamento)::text !~~ '%AVARIA%'::text))
UNION
 SELECT t.id_grupo,
    t.idfornecedor,
    t.idcomprador,
    t.iddepartamento,
    t.departamento AS idfamilia_produto,
    'TR'::text AS tipo,
    t.nivel_servico,
    "substring"(btrim(replace((t.nivel_servico)::text, 'NIVEL'::text, ''::text)), 1, 1) AS status,
    t.idproduto,
    t.descricao_produto,
    t.unidade_compra,
    t.estoque,
    t.lote_compras AS sugestao,
    t.status AS status_suprimento_sku,
    t.peso_compras,
    ( SELECT COALESCE((max(hgcg.data) - ('now'::text)::date), 0) AS tempo
           FROM public.hist_gatilho_compras_grupo hgcg
          WHERE ((hgcg.grupo = (t.id_grupo)::numeric) AND ((hgcg.idproduto)::text = (t.idproduto)::text) AND ((hgcg.tipo)::text = 'TR'::text) AND ((hgcg.status)::text = 'A'::text))) AS tempo_gatilho
   FROM public.produtos_transito t
  WHERE (t.lote_compras > (0)::double precision)
UNION
 SELECT t.id_grupo,
    t.idfornecedor,
    t.idcomprador,
    t.iddepartamento,
    t.departamento AS idfamilia_produto,
    'FC'::text AS tipo,
    t.nivel_servico,
    "substring"(btrim(replace((t.nivel_servico)::text, 'NIVEL'::text, ''::text)), 1, 1) AS status,
    t.idproduto,
    t.descricao_produto,
    t.unidade_compra,
    t.estoque,
    t.lote_compras AS sugestao,
    'OK'::text AS status_suprimento_sku,
    t.peso_compras,
    ( SELECT COALESCE((max(hgcg.data) - ('now'::text)::date), 0) AS tempo
           FROM public.hist_gatilho_compras_grupo hgcg
          WHERE ((hgcg.grupo = (t.id_grupo)::numeric) AND ((hgcg.idproduto)::text = (t.idproduto)::text) AND ((hgcg.tipo)::text = 'FC'::text) AND ((hgcg.status)::text = 'A'::text))) AS tempo_gatilho
   FROM public.produtos_forecast t;


--
-- PostgreSQL database dump complete
--

\unrestrict 3b2WpObGuRn9QVGKqeYVmPjlv86k07skmZfsppAI2YJBD2iHiOXkpmhgpJoK5Bl

