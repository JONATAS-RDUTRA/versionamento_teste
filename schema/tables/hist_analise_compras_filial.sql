--
-- PostgreSQL database dump
--

\restrict gtQmAyZM4tTdEJuFygFXexn6UlT0kgezbLRXsvd7yPPxTMl7lXh0FENFhjH5mHj

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

SET default_table_access_method = "heap";

--
-- Name: hist_analise_compras_filial; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."hist_analise_compras_filial" (
    "filial" bigint DEFAULT 0 NOT NULL,
    "idproduto" character varying(25) NOT NULL,
    "data_solicitacao" "date" NOT NULL,
    "arvore_decisao" character varying(4) NOT NULL,
    "estoque_seguranca" numeric(12,4) DEFAULT 0 NOT NULL,
    "ponto_pedido" numeric(12,4) DEFAULT 0 NOT NULL,
    "estoque_maximo" numeric(12,4) DEFAULT 0 NOT NULL,
    "consumo_medio" numeric(12,4) DEFAULT 0 NOT NULL,
    "sugestao" numeric(12,4) DEFAULT 0 NOT NULL,
    "estoque" numeric(12,4) DEFAULT 0 NOT NULL,
    "processamento" timestamp without time zone DEFAULT "now"() NOT NULL
)
WITH ("autovacuum_vacuum_scale_factor"='0.04406');


--
-- Name: hist_analise_compras_filial pk_hist_analise_comp_fil; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."hist_analise_compras_filial"
    ADD CONSTRAINT "pk_hist_analise_comp_fil" PRIMARY KEY ("filial", "idproduto", "data_solicitacao");


--
-- Name: hist_analise_compras_filial_data_solicitacao_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "hist_analise_compras_filial_data_solicitacao_idx" ON "public"."hist_analise_compras_filial" USING "btree" ("data_solicitacao");


--
-- PostgreSQL database dump complete
--

\unrestrict gtQmAyZM4tTdEJuFygFXexn6UlT0kgezbLRXsvd7yPPxTMl7lXh0FENFhjH5mHj

