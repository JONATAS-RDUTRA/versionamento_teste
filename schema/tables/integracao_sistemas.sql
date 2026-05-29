--
-- PostgreSQL database dump
--

\restrict 1L9tXfXhiuSCPQtRecdmTiBDR41uJ0b5DIHq5IVTlEVHmduZONakhhAqlhZe8he

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
-- Name: integracao_sistemas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."integracao_sistemas" (
    "id" integer NOT NULL,
    "descricao" character varying(60) NOT NULL,
    "sigla" character varying(15) NOT NULL,
    "parametros" "json"
);


--
-- Name: integracao_sistemas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."integracao_sistemas_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: integracao_sistemas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."integracao_sistemas_id_seq" OWNED BY "public"."integracao_sistemas"."id";


--
-- Name: integracao_sistemas id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."integracao_sistemas" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."integracao_sistemas_id_seq"'::"regclass");


--
-- Name: integracao_sistemas integracao_sistemas_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."integracao_sistemas"
    ADD CONSTRAINT "integracao_sistemas_pk" PRIMARY KEY ("id");


--
-- Name: integracao_sistemas_sigla_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "integracao_sistemas_sigla_idx" ON "public"."integracao_sistemas" USING "btree" ("sigla");


--
-- PostgreSQL database dump complete
--

\unrestrict 1L9tXfXhiuSCPQtRecdmTiBDR41uJ0b5DIHq5IVTlEVHmduZONakhhAqlhZe8he

