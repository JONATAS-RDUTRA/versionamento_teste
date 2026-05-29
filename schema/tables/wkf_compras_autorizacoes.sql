--
-- PostgreSQL database dump
--

\restrict DZEa1HW749kGwegR2cbuVfOucfzuq0vL0pqjKnQ3TWxNsGLT0BF9qgcriUqd5O8

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
-- Name: wkf_compras_autorizacoes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."wkf_compras_autorizacoes" (
    "id" integer NOT NULL,
    "referencia" "json" NOT NULL,
    "id_solicitante" integer NOT NULL,
    "data_solicitacao" "date" NOT NULL,
    "id_wkf_item" integer NOT NULL,
    "id_autorizador" integer,
    "data_analise" timestamp without time zone,
    "status_auto" character varying(1),
    "observacao" character varying(500)
);


--
-- Name: COLUMN "wkf_compras_autorizacoes"."status_auto"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."wkf_compras_autorizacoes"."status_auto" IS 'A - Autorizado
R - Reprovado';


--
-- Name: wkf_compras_autorizacoes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."wkf_compras_autorizacoes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: wkf_compras_autorizacoes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."wkf_compras_autorizacoes_id_seq" OWNED BY "public"."wkf_compras_autorizacoes"."id";


--
-- Name: wkf_compras_autorizacoes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."wkf_compras_autorizacoes" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."wkf_compras_autorizacoes_id_seq"'::"regclass");


--
-- Name: wkf_compras_autorizacoes wkf_compras_auto_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."wkf_compras_autorizacoes"
    ADD CONSTRAINT "wkf_compras_auto_pk" PRIMARY KEY ("id");


--
-- PostgreSQL database dump complete
--

\unrestrict DZEa1HW749kGwegR2cbuVfOucfzuq0vL0pqjKnQ3TWxNsGLT0BF9qgcriUqd5O8

