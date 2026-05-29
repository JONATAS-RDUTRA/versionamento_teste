--
-- PostgreSQL database dump
--

\restrict 1C5LFJse8GAwcYBCP7t4IxTx6x3IOeAmwazP0g9peyv5xdJ9fDBFXRwkvbC7p3i

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
-- Name: drp_grupo_separacao_filial; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."drp_grupo_separacao_filial" (
    "id_grupo_sep" bigint NOT NULL,
    "filial" bigint NOT NULL,
    "data_cadastro" "date" DEFAULT ('now'::"text")::"date" NOT NULL
);


--
-- Name: drp_grupo_separacao_filial grupo_sep_filial_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."drp_grupo_separacao_filial"
    ADD CONSTRAINT "grupo_sep_filial_pk" PRIMARY KEY ("id_grupo_sep", "filial");


--
-- PostgreSQL database dump complete
--

\unrestrict 1C5LFJse8GAwcYBCP7t4IxTx6x3IOeAmwazP0g9peyv5xdJ9fDBFXRwkvbC7p3i

