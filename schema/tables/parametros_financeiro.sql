--
-- PostgreSQL database dump
--

\restrict QWD9fSWuUH3hwftmp5H266Mmxm08w5gBCmsOY8eAINM7M9dJyVchK4fW4Cfh91i

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
-- Name: parametros_financeiro; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."parametros_financeiro" (
    "idparametros_financeiro" integer DEFAULT "nextval"('"public"."parametros_financeiro_idparametros_financeiro_seq"'::"regclass") NOT NULL,
    "classificacao" character varying(1),
    "descricao" character varying(45),
    "range_inicial" double precision,
    "range_final" double precision,
    "observacao" "text"
);


--
-- Name: parametros_financeiro parametros_financeiro_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."parametros_financeiro"
    ADD CONSTRAINT "parametros_financeiro_pkey" PRIMARY KEY ("idparametros_financeiro");


--
-- Name: classificacao_UNIQUE; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "classificacao_UNIQUE" ON "public"."parametros_financeiro" USING "btree" ("classificacao");


--
-- PostgreSQL database dump complete
--

\unrestrict QWD9fSWuUH3hwftmp5H266Mmxm08w5gBCmsOY8eAINM7M9dJyVchK4fW4Cfh91i

