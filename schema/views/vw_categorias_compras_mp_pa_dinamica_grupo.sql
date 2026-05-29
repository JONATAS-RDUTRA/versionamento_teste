--
-- PostgreSQL database dump
--

\restrict z9MGW0lJ8G7Sx4WJQFZkk1gf3KPbbnXRUVoTUSirBVwstRF5YgTFpTOyQJDwc7v

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
-- Name: vw_categorias_compras_mp_pa_dinamica_grupo; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.vw_categorias_compras_mp_pa_dinamica_grupo AS
 SELECT v.id_grupo,
    v.id_categoria,
    v.descricao_categoria,
    v.idcomprador,
    'CP'::text AS tipo_compra,
    'RESSUPRIR'::text AS status_suprimento_sku,
    v.cmm_peso,
    v.cmm_pa,
    v.cmm_pa_peso,
    v.estoque_peso,
    v.estoque_mp_peso,
    v.estoque_pa,
    v.estoque_pa_peso,
    v.estoque_transito_peso,
    v.estoque_seguranca,
    v.ponto_pedido,
    v.estoque_maximo,
    v.lote_minimo,
    v.nivel_servico,
    v.lote_compras_bruto,
    v.lote_compras,
    v.processamento
   FROM public.produtos_compras_categorias_mp_pa v
  WHERE (v.lote_compras > (0)::numeric)
UNION
 SELECT v.id_grupo,
    v.id_categoria,
    v.descricao_categoria,
    v.idcomprador,
    'FC'::text AS tipo_compra,
    'OK'::text AS status_suprimento_sku,
    v.cmm_peso,
    v.cmm_pa,
    v.cmm_pa_peso,
    v.estoque_peso,
    v.estoque_mp_peso,
    v.estoque_pa,
    v.estoque_pa_peso,
    0 AS estoque_transito_peso,
    v.estoque_seguranca,
    v.ponto_pedido,
    v.estoque_maximo,
    v.lote_minimo,
    v.nivel_servico,
    v.lote_compras_bruto,
    v.lote_compras,
    v.processamento
   FROM public.produtos_forecast_categorias_mp_pa v
  WHERE (v.lote_compras > (0)::numeric);


--
-- PostgreSQL database dump complete
--

\unrestrict z9MGW0lJ8G7Sx4WJQFZkk1gf3KPbbnXRUVoTUSirBVwstRF5YgTFpTOyQJDwc7v

