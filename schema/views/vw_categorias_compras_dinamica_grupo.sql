--
-- PostgreSQL database dump
--

\restrict ZOklyM3rpnNnqNMx7BWdY74wxZEePgkzF3x5nLoXhPKs7whcMIvg4e7yyMJx9I0

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
-- Name: vw_categorias_compras_dinamica_grupo; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.vw_categorias_compras_dinamica_grupo AS
 SELECT pcc.id_grupo,
    pcc.iddepartamento,
    pcc.idsecao,
    pcc.idcategoria,
    pcc.tempo_medio_ressuprimento,
    pcc.lote_compras,
    pcc.lote_minimo,
    pcc.nivel_servico,
    'CP'::text AS tipo,
    pcc.peso_compras
   FROM public.produtos_compras_categorias pcc
  WHERE (pcc.lote_compras > (0)::numeric)
UNION
 SELECT pfc.id_grupo,
    pfc.iddepartamento,
    pfc.idsecao,
    pfc.idcategoria,
    pfc.tempo_medio_ressuprimento,
    pfc.lote_compras,
    pfc.lote_minimo,
    pfc.nivel_servico,
    'FC'::text AS tipo,
    0 AS peso_compras
   FROM public.produtos_forecast_categorias pfc
  WHERE (pfc.lote_compras > (0)::numeric)
UNION
 SELECT ptc.id_grupo,
    ptc.iddepartamento,
    ptc.idsecao,
    ptc.idcategoria,
    ptc.tempo_medio_ressuprimento,
    ptc.lote_compras,
    ptc.lote_minimo,
    ptc.nivel_servico,
    'TR'::text AS tipo,
    0 AS peso_compras
   FROM public.produtos_transito_categorias ptc
  WHERE (ptc.lote_compras > (0)::numeric);


--
-- PostgreSQL database dump complete
--

\unrestrict ZOklyM3rpnNnqNMx7BWdY74wxZEePgkzF3x5nLoXhPKs7whcMIvg4e7yyMJx9I0

