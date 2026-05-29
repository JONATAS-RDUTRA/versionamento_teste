--
-- PostgreSQL database dump
--

\restrict j4pr3D8lqiJMBOTFUXDpJChnB6pypocSRGdHmBtTeJg8p3NWwVM0k14St1saYcj

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
-- Name: produtos_forecast; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."produtos_forecast" (
    "id_grupo" bigint NOT NULL,
    "idfornecedor" bigint,
    "fornecedor" character varying(100),
    "idcomprador" bigint,
    "comprador" character varying(100),
    "idproduto" character varying(25) NOT NULL,
    "descricao_produto" character varying(60),
    "iddepartamento" integer,
    "departamento" character varying(45),
    "ponto_pedido" double precision,
    "estoque_futuro" double precision,
    "estoque_maximo" double precision,
    "estoque" double precision,
    "tempo_ressuprimento" numeric,
    "desvio_padrao_ressuprimento" numeric,
    "consumo_medio_mensal" double precision,
    "lote_compras" numeric,
    "lote_compras_bruto" numeric,
    "fator_conversao" integer,
    "unidade_compra" character varying(20),
    "lote_minimo" numeric,
    "nivel_servico" character varying,
    "peso_compras" numeric,
    "flag" character varying(1),
    "processamento" timestamp(0) without time zone
);


--
-- Name: produtos_forecast produtos_forecast_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."produtos_forecast"
    ADD CONSTRAINT "produtos_forecast_pk" PRIMARY KEY ("id_grupo", "idproduto");


--
-- Name: produtos_forecast_flag_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "produtos_forecast_flag_idx" ON "public"."produtos_forecast" USING "btree" ("flag");


--
-- Name: produtos_forecast_id_grupo_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "produtos_forecast_id_grupo_idx" ON "public"."produtos_forecast" USING "btree" ("id_grupo", "idfornecedor");


--
-- PostgreSQL database dump complete
--

\unrestrict j4pr3D8lqiJMBOTFUXDpJChnB6pypocSRGdHmBtTeJg8p3NWwVM0k14St1saYcj

