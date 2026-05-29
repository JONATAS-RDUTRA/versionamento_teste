--
-- PostgreSQL database dump
--

\restrict bgLrG0Xjw8CmWQfKsSslPye9Dk2kPotSe5ccpbyzln7wURhL5wWjfmz3ejBBpt0

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
-- Name: matriz_priorizacao; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."matriz_priorizacao" (
    "nivel_servico" integer NOT NULL,
    "nivel_ressuprimento" integer NOT NULL,
    "peso" integer
);


--
-- Name: matriz_priorizacao matriz_priorizacao_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."matriz_priorizacao"
    ADD CONSTRAINT "matriz_priorizacao_pkey" PRIMARY KEY ("nivel_servico", "nivel_ressuprimento");


--
-- PostgreSQL database dump complete
--

\unrestrict bgLrG0Xjw8CmWQfKsSslPye9Dk2kPotSe5ccpbyzln7wURhL5wWjfmz3ejBBpt0

