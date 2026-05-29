--
-- PostgreSQL database dump
--

\restrict r9sCbaqthYqTqFRlv83GTRflyvUPAwoHg1cqOVjIrw7jVUiGcicZp0M1gl9IAGU

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
-- Name: cfgsystem_atualizacoes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."cfgsystem_atualizacoes" (
    "id" integer NOT NULL,
    "id_arquivo" character varying(15),
    "versao_bd" character varying(15),
    "descricao_atualizacao" "text",
    "comando" "text",
    "id_user_exec" integer,
    "log_exec" timestamp without time zone,
    "executado" character varying(1)
);


--
-- Name: cfgsystem_atualizacoes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."cfgsystem_atualizacoes_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cfgsystem_atualizacoes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."cfgsystem_atualizacoes_id_seq" OWNED BY "public"."cfgsystem_atualizacoes"."id";


--
-- Name: cfgsystem_atualizacoes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cfgsystem_atualizacoes" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."cfgsystem_atualizacoes_id_seq"'::"regclass");


--
-- Name: cfgsystem_atualizacoes cfgsystem_atualizacoes_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cfgsystem_atualizacoes"
    ADD CONSTRAINT "cfgsystem_atualizacoes_pk" PRIMARY KEY ("id");


--
-- PostgreSQL database dump complete
--

\unrestrict r9sCbaqthYqTqFRlv83GTRflyvUPAwoHg1cqOVjIrw7jVUiGcicZp0M1gl9IAGU

