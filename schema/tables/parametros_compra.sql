--
-- PostgreSQL database dump
--

\restrict VpdKIyorsApYYGSlDytVfuF0og79FRTersCNOmJ7cJVZWEDq1dtUXFqd0kjDUpF

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
-- Name: parametros_compra; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."parametros_compra" (
    "idparametro_compra" integer DEFAULT "nextval"('"public"."parametros_compra_idparametro_compra_seq"'::"regclass") NOT NULL,
    "complexibilidade_compra" integer,
    "descricao" character varying(45),
    "range_inicial" double precision,
    "range_final" double precision,
    "parametros_compra" integer,
    "observacao" "text"
);


--
-- Name: parametros_compra parametros_compra_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."parametros_compra"
    ADD CONSTRAINT "parametros_compra_pkey" PRIMARY KEY ("idparametro_compra");


--
-- Name: complexibilidade_compra_UNIQUE; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "complexibilidade_compra_UNIQUE" ON "public"."parametros_compra" USING "btree" ("complexibilidade_compra");


--
-- PostgreSQL database dump complete
--

\unrestrict VpdKIyorsApYYGSlDytVfuF0og79FRTersCNOmJ7cJVZWEDq1dtUXFqd0kjDUpF

