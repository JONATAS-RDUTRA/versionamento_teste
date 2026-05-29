--
-- PostgreSQL database dump
--

\restrict vIXnjlHlOL1vhZHYA922HuKmmVe06gjYAyvEcIaDoTLZ8EZPxRXi1qN7GjB9wCl

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
-- Name: tmp_total_saldo_estoque_semestral; Type: MATERIALIZED VIEW; Schema: public; Owner: -
--

CREATE MATERIALIZED VIEW public.tmp_total_saldo_estoque_semestral
WITH (autovacuum_vacuum_scale_factor='3.07175') AS
 SELECT gf.id_grupo,
    sf.filial,
    sf.ano,
    sf.mes,
    sf.idproduto,
    sf.estoque
   FROM (public.saldo_filiais sf
     JOIN public.grupo_filial gf ON ((gf.filial = sf.filial)))
  WHERE (sf.data IN ( SELECT public.last_day((day.day)::date) AS last_day
           FROM generate_series(((public.first_day(('now'::text)::date) - 180))::timestamp with time zone, (('now'::text)::date)::timestamp with time zone, '1 mon'::interval) day(day)
        UNION
         SELECT ('now'::text)::date AS date))
  WITH NO DATA;


--
-- Name: tmp_total_saldo_estoque_semestral_filial_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tmp_total_saldo_estoque_semestral_filial_idx ON public.tmp_total_saldo_estoque_semestral USING btree (filial, idproduto);


--
-- Name: tmp_total_saldo_estoque_semestral_filial_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX tmp_total_saldo_estoque_semestral_filial_pk ON public.tmp_total_saldo_estoque_semestral USING btree (id_grupo, filial, ano, mes, idproduto);


--
-- Name: tmp_total_saldo_estoque_semestral_grupo_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX tmp_total_saldo_estoque_semestral_grupo_idx ON public.tmp_total_saldo_estoque_semestral USING btree (id_grupo, idproduto);


--
-- PostgreSQL database dump complete
--

\unrestrict vIXnjlHlOL1vhZHYA922HuKmmVe06gjYAyvEcIaDoTLZ8EZPxRXi1qN7GjB9wCl

