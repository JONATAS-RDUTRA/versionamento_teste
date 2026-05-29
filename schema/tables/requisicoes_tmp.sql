--
-- PostgreSQL database dump
--

\restrict DkF5VdwIshnJcx0nSG88FhQDB38jzt7efwuKU1I4z3ElLXpMhm9ONLOLrx3PhpQ

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
-- Name: requisicoes_tmp; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."requisicoes_tmp" (
    "id_solicitacao" double precision DEFAULT 0 NOT NULL,
    "data_solicitacao" "date",
    "data_liberacao" "date",
    "item" double precision DEFAULT 0 NOT NULL,
    "idproduto" character varying(25) DEFAULT 0 NOT NULL,
    "descricao_produto" character varying(255),
    "qtde" double precision,
    "unidade_medida" character varying(255),
    "ordem_compra" double precision,
    "data_conferencia" timestamp without time zone,
    "idfilial" integer,
    "iddeposito" integer,
    "data_previsao" "date",
    "data_faturamento" "date",
    "data_entrega" "date",
    "qtde_entregue" double precision DEFAULT 0 NOT NULL,
    "qtde_pendente" double precision DEFAULT 0 NOT NULL,
    "pcompra" double precision DEFAULT 0,
    "pcompraant" double precision DEFAULT 0,
    "pliquido" double precision DEFAULT 0,
    "fator_conversao" numeric(12,4),
    "qtde_faturada" double precision,
    "entrada_bonificada" character varying(1) DEFAULT 'N'::character varying NOT NULL,
    "moeda" character varying(2) DEFAULT 'R'::character varying NOT NULL,
    "idfornecedor" integer DEFAULT 0 NOT NULL,
    "qtde_solicitada_original" double precision,
    "idmarca" character varying(25),
    "compra_programada" character varying(1) DEFAULT 'N'::character varying NOT NULL,
    "flag_teste" character varying(1)
);


--
-- Name: COLUMN "requisicoes_tmp"."moeda"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."requisicoes_tmp"."moeda" IS 'R - Real, D - Dolar, UE - Euro, ST - Sem Tabela';


--
-- Name: requisicoes_tmp requisicoes_tmp_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."requisicoes_tmp"
    ADD CONSTRAINT "requisicoes_tmp_pkey" PRIMARY KEY ("id_solicitacao", "idproduto", "item");


--
-- PostgreSQL database dump complete
--

\unrestrict DkF5VdwIshnJcx0nSG88FhQDB38jzt7efwuKU1I4z3ElLXpMhm9ONLOLrx3PhpQ

