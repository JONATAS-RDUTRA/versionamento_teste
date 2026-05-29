--
-- PostgreSQL database dump
--

\restrict ImiQDet56wTFEcrhfF9uNOO83sOeV4x7hwrmBqK18y9Wc4cIGk1KLxSHU5ug6LC

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
-- Name: hist_analise_compras_grupo; Type: MATERIALIZED VIEW; Schema: public; Owner: -
--

CREATE MATERIALIZED VIEW public.hist_analise_compras_grupo AS
 SELECT gf.id_grupo,
    hacf.idproduto,
    hacf.data_solicitacao,
    sum(hacf.estoque_seguranca) AS estoque_seguranca,
    sum(hacf.ponto_pedido) AS ponto_pedido,
    sum(hacf.estoque_maximo) AS estoque_maximo,
    sum(hacf.consumo_medio) AS consumo_medio,
    sum(hacf.sugestao) AS sugestao,
    sum(hacf.estoque) AS estoque
   FROM (public.hist_analise_compras_filial hacf
     JOIN public.grupo_filial gf ON ((gf.filial = hacf.filial)))
  WHERE (hacf.data_solicitacao IN ( SELECT public.last_day((day.day)::date) AS last_day
           FROM generate_series(((('now'::text)::date - 365))::timestamp with time zone, (('now'::text)::date)::timestamp with time zone, '1 mon'::interval) day(day)
        UNION
         SELECT (('now'::text)::date - 1)))
  GROUP BY gf.id_grupo, hacf.idproduto, hacf.data_solicitacao
  WITH NO DATA;


--
-- Name: hist_analise_compras_grupo_id_grupo_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX hist_analise_compras_grupo_id_grupo_idx ON public.hist_analise_compras_grupo USING btree (id_grupo, idproduto, data_solicitacao);


--
-- PostgreSQL database dump complete
--

\unrestrict ImiQDet56wTFEcrhfF9uNOO83sOeV4x7hwrmBqK18y9Wc4cIGk1KLxSHU5ug6LC

