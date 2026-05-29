--
-- PostgreSQL database dump
--

\restrict UbL98TOgip3bGCyiIK6Wfw04tuqwhF3cP55mbGdIdu3WUZabc6bffrH7JBC8803

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
-- Name: produtos_separacao_tmp; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."produtos_separacao_tmp" (
    "filial_origem" bigint DEFAULT 0 NOT NULL,
    "filial_destino" bigint DEFAULT 0 NOT NULL,
    "pedido" bigint DEFAULT 0 NOT NULL,
    "emissao" "date" NOT NULL,
    "item" bigint NOT NULL,
    "idproduto" character varying(25) NOT NULL,
    "qtde_item" numeric(12,4) DEFAULT 0,
    "preco_sep" numeric(12,4) DEFAULT 0,
    "preco_custo_financ" numeric(12,4) DEFAULT 0,
    "flag" character varying(1)
);


--
-- Name: produtos_separacao_tmp produtos_sep_tmp_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."produtos_separacao_tmp"
    ADD CONSTRAINT "produtos_sep_tmp_pkey" PRIMARY KEY ("filial_origem", "filial_destino", "pedido", "item", "idproduto");


--
-- PostgreSQL database dump complete
--

\unrestrict UbL98TOgip3bGCyiIK6Wfw04tuqwhF3cP55mbGdIdu3WUZabc6bffrH7JBC8803

