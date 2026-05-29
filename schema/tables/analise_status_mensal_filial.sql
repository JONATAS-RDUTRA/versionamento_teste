--
-- PostgreSQL database dump
--

\restrict B453wbLAi23NgbdZr4HWd383uxWZ2EcvSAPsU4qlBH4LgHCwSpcvs3VTFenl6JW

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
-- Name: analise_status_mensal_filial; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."analise_status_mensal_filial" (
    "grupo" integer DEFAULT 0 NOT NULL,
    "filial" integer DEFAULT 0 NOT NULL,
    "ano" integer DEFAULT 0 NOT NULL,
    "mes" integer DEFAULT 0 NOT NULL,
    "total_estoque_real" numeric(12,4) NOT NULL,
    "qtde_itens_real" numeric(12,4) NOT NULL,
    "total_estoque_residual" numeric(12,4) NOT NULL,
    "qtde_itens_residual" numeric(12,4) NOT NULL,
    "perc_estoque_residual" numeric(12,4) NOT NULL,
    "total_estoque_excesso" numeric(12,4) NOT NULL,
    "qtde_itens_excesso" numeric(12,4) NOT NULL,
    "perc_estoque_excesso" numeric(12,4) NOT NULL,
    "total_estoque_necessidade" numeric(12,4) NOT NULL,
    "qtde_itens_necessidade" numeric(12,4) NOT NULL,
    "perc_estoque_necessidade" numeric(12,4) NOT NULL,
    "total_estoque_ideal" numeric(12,4) NOT NULL,
    "qtde_itens_ideal" numeric(12,4) NOT NULL,
    "perc_estoque_ideal" numeric(12,4) NOT NULL,
    "processamento" timestamp without time zone DEFAULT "now"() NOT NULL,
    "total_estoque_novo" numeric(12,4),
    "qtde_itens_novo" numeric(12,4),
    "perc_estoque_novo" numeric(12,4)
);


--
-- Name: analise_status_mensal_filial pk_analise_status_mensal_filial; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."analise_status_mensal_filial"
    ADD CONSTRAINT "pk_analise_status_mensal_filial" PRIMARY KEY ("grupo", "filial", "ano", "mes");


--
-- PostgreSQL database dump complete
--

\unrestrict B453wbLAi23NgbdZr4HWd383uxWZ2EcvSAPsU4qlBH4LgHCwSpcvs3VTFenl6JW

