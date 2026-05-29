--
-- PostgreSQL database dump
--

\restrict ndixmbevdeYy3Ky5Xua7M1tJuh3h8SN4nyOVZjcmDiisahQSPSE4jZL4VDT5ecs

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
-- Name: departamentos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."departamentos" (
    "iddepartamento" integer DEFAULT "nextval"('"public"."departamentos_iddepartamento_seq"'::"regclass") NOT NULL,
    "descricao_departamento" character varying(45),
    "tempo_forecast" integer DEFAULT 15 NOT NULL,
    "flag_cobertura_manual" character varying(1) DEFAULT 'N'::character varying NOT NULL,
    "cobertura_est_manual" integer DEFAULT 0 NOT NULL,
    "idcomprador" bigint
);


--
-- Name: departamentos departamentos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."departamentos"
    ADD CONSTRAINT "departamentos_pkey" PRIMARY KEY ("iddepartamento");


--
-- PostgreSQL database dump complete
--

\unrestrict ndixmbevdeYy3Ky5Xua7M1tJuh3h8SN4nyOVZjcmDiisahQSPSE4jZL4VDT5ecs

