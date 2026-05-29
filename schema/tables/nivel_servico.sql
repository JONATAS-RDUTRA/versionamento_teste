--
-- PostgreSQL database dump
--

\restrict 9pMvaBGFgLESsDQKFQy039aHtcxu8OBjq7pNA7CFUxqjwTf2f442qkSRb99l2Ua

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
-- Name: nivel_servico; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."nivel_servico" (
    "idnivel_servico" integer DEFAULT "nextval"('"public"."nivel_servico_idnivel_servico_seq"'::"regclass") NOT NULL,
    "descricao_nivel_servico" character varying(45),
    "percentual_nivel_seguranca" double precision,
    "fes" double precision,
    "peso" numeric(12,4) DEFAULT 0 NOT NULL,
    "indice" smallint DEFAULT 0 NOT NULL
);


--
-- Name: nivel_servico nivel_servico_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."nivel_servico"
    ADD CONSTRAINT "nivel_servico_pkey" PRIMARY KEY ("idnivel_servico");


--
-- PostgreSQL database dump complete
--

\unrestrict 9pMvaBGFgLESsDQKFQy039aHtcxu8OBjq7pNA7CFUxqjwTf2f442qkSRb99l2Ua

