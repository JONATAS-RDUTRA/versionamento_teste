--
-- PostgreSQL database dump
--

\restrict 5rpoTR47C6gZmznHSyE8Ks5F4KKI69crjLa1PU2L54gaJcCCXKjEMAyJWz8tYCt

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
-- Name: drp_mapa_separacao_automatica; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."drp_mapa_separacao_automatica" (
    "id_grupo_separacao" bigint NOT NULL,
    "filial_destino" bigint NOT NULL,
    "filial_origem" bigint NOT NULL,
    "cobertura_drp" bigint DEFAULT 30 NOT NULL,
    "tempo_ressuprimento_drp" bigint DEFAULT 5 NOT NULL
);


--
-- Name: drp_mapa_separacao_automatica drp_mapa_separacao_automatica_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."drp_mapa_separacao_automatica"
    ADD CONSTRAINT "drp_mapa_separacao_automatica_pkey" PRIMARY KEY ("id_grupo_separacao", "filial_origem", "filial_destino");


--
-- PostgreSQL database dump complete
--

\unrestrict 5rpoTR47C6gZmznHSyE8Ks5F4KKI69crjLa1PU2L54gaJcCCXKjEMAyJWz8tYCt

