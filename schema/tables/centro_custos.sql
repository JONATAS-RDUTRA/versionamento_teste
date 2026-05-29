--
-- PostgreSQL database dump
--

\restrict WNhWGhsLXgVEUmBsQORRByCh53CrmE3fRaggYgDLk2Ab2h0LIqg2jjdlBrgSK62

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
-- Name: centro_custos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."centro_custos" (
    "idcentro_custo" integer DEFAULT "nextval"('"public"."centro_custos_idcentro_custo_seq"'::"regclass") NOT NULL,
    "descricao_centro_custo" character varying(60),
    "responsavel" character varying(60),
    "iddepartamento" integer
);


--
-- Name: centro_custos centro_custos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."centro_custos"
    ADD CONSTRAINT "centro_custos_pkey" PRIMARY KEY ("idcentro_custo");


--
-- PostgreSQL database dump complete
--

\unrestrict WNhWGhsLXgVEUmBsQORRByCh53CrmE3fRaggYgDLk2Ab2h0LIqg2jjdlBrgSK62

