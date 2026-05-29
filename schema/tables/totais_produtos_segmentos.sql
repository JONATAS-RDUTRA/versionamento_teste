--
-- PostgreSQL database dump
--

\restrict d2I87ORthW3OmP7pDUYN6rlo9aaNcLpUFy4EbyCV02yh29tmBoEMXOarvaajC2C

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
-- Name: totais_produtos_segmentos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."totais_produtos_segmentos" (
    "idgrupo" bigint NOT NULL,
    "idfamilia_produto" integer NOT NULL,
    "qtde_fornecedores" bigint,
    "qtde_geral_itens" bigint,
    "qtde_itens_excesso" bigint,
    "qtde_itens_ok" bigint,
    "qtde_itens_ressuprir" bigint,
    "qtde_itens_transito" bigint,
    "total_estoque" numeric(12,2),
    "status" character varying(1),
    "total_ressuprir" numeric(12,2),
    "total_estoque_venda" numeric(12,2),
    "markup_medio" numeric(12,2),
    "nivel_estoque" numeric(12,2),
    "projecao_venda_mensal" numeric(12,2),
    "projecao_rentabilidade_mensal" numeric(12,2),
    "media_venda_trimestre_anterior" numeric(12,2)
);


--
-- Name: totais_produtos_segmentos totais_produtos_segmentos_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."totais_produtos_segmentos"
    ADD CONSTRAINT "totais_produtos_segmentos_pk" PRIMARY KEY ("idgrupo", "idfamilia_produto");


--
-- Name: totais_produtos_segmentos_status_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "totais_produtos_segmentos_status_idx" ON "public"."totais_produtos_segmentos" USING "btree" ("status");


--
-- PostgreSQL database dump complete
--

\unrestrict d2I87ORthW3OmP7pDUYN6rlo9aaNcLpUFy4EbyCV02yh29tmBoEMXOarvaajC2C

