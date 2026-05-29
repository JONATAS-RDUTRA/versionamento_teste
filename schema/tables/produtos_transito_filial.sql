--
-- PostgreSQL database dump
--

\restrict Yyz1ajq3CHFeHJWe0AmP2xtFOqo81h3u1OzO8szq4xiUbbPMEOxPnbcQU32bs4i

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
-- Name: produtos_transito_filial; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."produtos_transito_filial" (
    "id_grupo" bigint NOT NULL,
    "idfornecedor" bigint,
    "fornecedor" character varying(100),
    "idcomprador" bigint,
    "comprador" character varying(100),
    "filial" integer NOT NULL,
    "idproduto" character varying(25) NOT NULL,
    "descricao_produto" character varying(60),
    "iddepartamento" integer,
    "departamento" character varying(45),
    "compra_transito" numeric,
    "consumo_transito" numeric,
    "saldo_futuro" numeric,
    "estoque_maximo" double precision,
    "ponto_pedido" double precision,
    "consumo_medio_mensal" double precision,
    "tempo_ressuprimento" numeric(12,4),
    "desvio_padrao_ressuprimento" numeric(12,4),
    "estoque" double precision,
    "status" "text",
    "lote_compras" double precision,
    "fator_conversao" numeric(12,6),
    "unidade_compra" character varying(20),
    "data_ultima_riquisicao" "date",
    "tempo_pedido" integer,
    "nivel_servico" character varying(20),
    "peso_compras" integer,
    "gatilho_transito" integer,
    "flag" character varying(1),
    "processamento" timestamp(0) without time zone
);


--
-- Name: produtos_transito_filial produtos_transito_filial_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."produtos_transito_filial"
    ADD CONSTRAINT "produtos_transito_filial_pk" PRIMARY KEY ("id_grupo", "filial", "idproduto");


--
-- Name: produtos_transito_filial_flag_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "produtos_transito_filial_flag_idx" ON "public"."produtos_transito_filial" USING "btree" ("flag");


--
-- Name: produtos_transito_filial_id_grupo_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "produtos_transito_filial_id_grupo_idx" ON "public"."produtos_transito_filial" USING "btree" ("id_grupo", "filial", "idfornecedor");


--
-- PostgreSQL database dump complete
--

\unrestrict Yyz1ajq3CHFeHJWe0AmP2xtFOqo81h3u1OzO8szq4xiUbbPMEOxPnbcQU32bs4i

