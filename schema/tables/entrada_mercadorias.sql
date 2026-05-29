--
-- PostgreSQL database dump
--

\restrict B6ZCSmtAeNZGcaYBDWpHCbaRqpWdKDpVCsu4eGgPVDngJ6hakT7ikdNOLg6LJTQ

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
-- Name: entrada_mercadorias; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."entrada_mercadorias" (
    "ordem_compra" double precision DEFAULT 0 NOT NULL,
    "data_entrada" "date",
    "nro_nfe" character varying(255) NOT NULL,
    "item" double precision DEFAULT 0 NOT NULL,
    "idproduto" character varying(25) DEFAULT 0 NOT NULL,
    "descricao_produto" character varying(255),
    "qtde" double precision,
    "unidade_medida" character varying(255),
    "idfilial" integer,
    "montante" double precision,
    "custo_unit" numeric(12,4) DEFAULT 0 NOT NULL,
    "fator_conversao" numeric(12,4),
    "flag" character varying(1),
    "idfornecedor" integer
);


--
-- Name: COLUMN "entrada_mercadorias"."ordem_compra"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."entrada_mercadorias"."ordem_compra" IS 'Número da Entrada';


--
-- Name: COLUMN "entrada_mercadorias"."data_entrada"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."entrada_mercadorias"."data_entrada" IS 'Data da entrada';


--
-- Name: COLUMN "entrada_mercadorias"."nro_nfe"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."entrada_mercadorias"."nro_nfe" IS 'Número da Nota';


--
-- Name: COLUMN "entrada_mercadorias"."idproduto"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."entrada_mercadorias"."idproduto" IS 'Produto';


--
-- Name: COLUMN "entrada_mercadorias"."descricao_produto"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."entrada_mercadorias"."descricao_produto" IS 'Nome do Porduto';


--
-- Name: COLUMN "entrada_mercadorias"."qtde"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."entrada_mercadorias"."qtde" IS 'Quantidade';


--
-- Name: COLUMN "entrada_mercadorias"."unidade_medida"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."entrada_mercadorias"."unidade_medida" IS 'Embalagem';


--
-- Name: COLUMN "entrada_mercadorias"."idfilial"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."entrada_mercadorias"."idfilial" IS 'Filial da Entrada';


--
-- Name: COLUMN "entrada_mercadorias"."montante"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."entrada_mercadorias"."montante" IS 'Valor total da nota';


--
-- Name: entrada_mercadorias entrada_mercadorias_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."entrada_mercadorias"
    ADD CONSTRAINT "entrada_mercadorias_pkey" PRIMARY KEY ("ordem_compra", "item", "idproduto", "nro_nfe");


--
-- Name: entrada_mercadorias_index01; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "entrada_mercadorias_index01" ON "public"."entrada_mercadorias" USING "btree" ("ordem_compra", "idproduto");


--
-- Name: entrada_mercadorias_index02; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "entrada_mercadorias_index02" ON "public"."entrada_mercadorias" USING "btree" ("idproduto", "data_entrada");


--
-- PostgreSQL database dump complete
--

\unrestrict B6ZCSmtAeNZGcaYBDWpHCbaRqpWdKDpVCsu4eGgPVDngJ6hakT7ikdNOLg6LJTQ

