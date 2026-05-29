--
-- PostgreSQL database dump
--

\restrict V9IDQj0mnPlipFIg9KaYO7BGicQ3qYGRCd3H8Oi2x2kcPjGg63Mh6lbcVnsXzHF

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
-- Name: produtos_separacao; Type: MATERIALIZED VIEW; Schema: public; Owner: -
--

CREATE MATERIALIZED VIEW public.produtos_separacao AS
 SELECT filial_origem,
    filial_destino,
    pedido,
    emissao,
    item,
    idproduto,
    qtde_item,
    preco_sep,
    preco_custo_financ
   FROM public.produtos_separacao_tmp
  WITH NO DATA;


--
-- Name: produtos_separacao_filial_destino_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX produtos_separacao_filial_destino_idx ON public.produtos_separacao USING btree (filial_destino, idproduto);


--
-- Name: produtos_separacao_filial_origem_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX produtos_separacao_filial_origem_idx ON public.produtos_separacao USING btree (filial_origem, filial_destino, pedido, emissao, item, idproduto);


--
-- PostgreSQL database dump complete
--

\unrestrict V9IDQj0mnPlipFIg9KaYO7BGicQ3qYGRCd3H8Oi2x2kcPjGg63Mh6lbcVnsXzHF

