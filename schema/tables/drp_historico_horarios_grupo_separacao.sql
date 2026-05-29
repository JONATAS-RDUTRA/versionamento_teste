--
-- PostgreSQL database dump
--

\restrict 0z7eMwMDa5c1DQTCHBXolKq3uFjKc2VTCy59rnwCggL2aSkGkocRolJdNeC0Pal

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
-- Name: drp_historico_horarios_grupo_separacao; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."drp_historico_horarios_grupo_separacao" (
    "id" integer NOT NULL,
    "id_grupo_separacao" integer NOT NULL,
    "horario" time without time zone NOT NULL,
    "data" "date" NOT NULL,
    "horario_inicio" time without time zone,
    "horario_final" time without time zone
);


--
-- Name: drp_historico_horarios_grupo_separacao_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."drp_historico_horarios_grupo_separacao_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: drp_historico_horarios_grupo_separacao_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."drp_historico_horarios_grupo_separacao_id_seq" OWNED BY "public"."drp_historico_horarios_grupo_separacao"."id";


--
-- Name: drp_historico_horarios_grupo_separacao id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."drp_historico_horarios_grupo_separacao" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."drp_historico_horarios_grupo_separacao_id_seq"'::"regclass");


--
-- Name: drp_historico_horarios_grupo_separacao drp_historico_horarios_grupo_separacao_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."drp_historico_horarios_grupo_separacao"
    ADD CONSTRAINT "drp_historico_horarios_grupo_separacao_pk" PRIMARY KEY ("id");


--
-- PostgreSQL database dump complete
--

\unrestrict 0z7eMwMDa5c1DQTCHBXolKq3uFjKc2VTCy59rnwCggL2aSkGkocRolJdNeC0Pal

