--
-- PostgreSQL database dump
--

\restrict 53LWRg1NI96OtEms5yNz3QYpoo3qDK1p1iSQ10ZHTKazqMoGzp6UhJQiXhuHRJH

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
-- Name: tmp_total_vendas_semestral; Type: MATERIALIZED VIEW; Schema: public; Owner: -
--

CREATE MATERIALIZED VIEW public.tmp_total_vendas_semestral
WITH (autovacuum_vacuum_scale_factor='3.07766') AS
 SELECT gf.id_grupo,
    sf.filial,
    sf.ano,
    sf.mes,
    sf.idproduto,
    sum(sf.saidas) AS total
   FROM (public.saldo_filiais sf
     JOIN public.grupo_filial gf ON ((gf.filial = sf.filial)))
  WHERE ((sf.data >= (date_trunc('month'::text, (((date_trunc('month'::text, (('now'::text)::date)::timestamp with time zone))::date - 180))::timestamp with time zone))::date) AND (sf.data <= ('now'::text)::date))
  GROUP BY gf.id_grupo, sf.filial, sf.ano, sf.mes, sf.idproduto
  WITH NO DATA;


--
-- Name: tmp_total_vendas_semestral_filial_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tmp_total_vendas_semestral_filial_idx ON public.tmp_total_vendas_semestral USING btree (filial, idproduto);


--
-- Name: tmp_total_vendas_semestral_filial_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX tmp_total_vendas_semestral_filial_pk ON public.tmp_total_vendas_semestral USING btree (id_grupo, filial, ano, mes, idproduto);


--
-- Name: tmp_total_vendas_semestral_grupo_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tmp_total_vendas_semestral_grupo_idx ON public.tmp_total_vendas_semestral USING btree (id_grupo, idproduto);


--
-- PostgreSQL database dump complete
--

\unrestrict 53LWRg1NI96OtEms5yNz3QYpoo3qDK1p1iSQ10ZHTKazqMoGzp6UhJQiXhuHRJH

