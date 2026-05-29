--
-- PostgreSQL database dump
--

\restrict FjMZ8eCc18kVs69n3jaTbHPQubl1Xofz20LYH3cQU5m2WvqUv20X6sKgWVbCADL

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
-- Name: drp_grupo_separacao; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."drp_grupo_separacao" (
    "id" integer NOT NULL,
    "descricao" character varying(60) NOT NULL,
    "data_cadastro" "date" DEFAULT ('now'::"text")::"date" NOT NULL,
    "sigla" character varying(4),
    "color" character varying(9) NOT NULL
);


--
-- Name: drp_grupo_separacao_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."drp_grupo_separacao_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: drp_grupo_separacao_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."drp_grupo_separacao_id_seq" OWNED BY "public"."drp_grupo_separacao"."id";


--
-- Name: drp_grupo_separacao id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."drp_grupo_separacao" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."drp_grupo_separacao_id_seq"'::"regclass");


--
-- Name: drp_grupo_separacao grupo_sep_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."drp_grupo_separacao"
    ADD CONSTRAINT "grupo_sep_pk" PRIMARY KEY ("id");


--
-- PostgreSQL database dump complete
--

\unrestrict FjMZ8eCc18kVs69n3jaTbHPQubl1Xofz20LYH3cQU5m2WvqUv20X6sKgWVbCADL

