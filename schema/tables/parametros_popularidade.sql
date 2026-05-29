--
-- PostgreSQL database dump
--

\restrict w3XzD8Npr2bwqCNGXTyNsl7wyCTZYXCL54IsP0gyXeiLf9K6b1imu5sQkfjQHLZ

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
-- Name: parametros_popularidade; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."parametros_popularidade" (
    "idparametros_popularidade" integer DEFAULT "nextval"('"public"."parametros_popularidade_idparametros_popularidade_seq"'::"regclass") NOT NULL,
    "tempo_medio_apanhe" character varying(1),
    "descricao" character varying(45),
    "range_inicial" double precision,
    "range_final" double precision,
    "observacao" "text"
);


--
-- Name: parametros_popularidade parametros_popularidade_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."parametros_popularidade"
    ADD CONSTRAINT "parametros_popularidade_pkey" PRIMARY KEY ("idparametros_popularidade");


--
-- Name: tempo_medio_apanhe_UNIQUE; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "tempo_medio_apanhe_UNIQUE" ON "public"."parametros_popularidade" USING "btree" ("tempo_medio_apanhe");


--
-- PostgreSQL database dump complete
--

\unrestrict w3XzD8Npr2bwqCNGXTyNsl7wyCTZYXCL54IsP0gyXeiLf9K6b1imu5sQkfjQHLZ

