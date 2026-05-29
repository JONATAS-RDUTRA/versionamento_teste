--
-- PostgreSQL database dump
--

\restrict fo64fzvfUvSoFIg1FwzYLmBtlD53a2gtK3JLLXmLRZpgaQkCA0gvtO0YaMVODAK

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
-- Name: modulos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."modulos" (
    "idmodulo" integer DEFAULT "nextval"('"public"."modulos_idmodulo_seq"'::"regclass") NOT NULL,
    "descricao_modulo" character varying(60),
    "src_modulo" character varying(60),
    "prioridade" integer DEFAULT 0 NOT NULL
);


--
-- Name: modulos modulos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."modulos"
    ADD CONSTRAINT "modulos_pkey" PRIMARY KEY ("idmodulo");


--
-- PostgreSQL database dump complete
--

\unrestrict fo64fzvfUvSoFIg1FwzYLmBtlD53a2gtK3JLLXmLRZpgaQkCA0gvtO0YaMVODAK

