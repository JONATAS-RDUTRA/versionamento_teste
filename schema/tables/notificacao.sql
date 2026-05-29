--
-- PostgreSQL database dump
--

\restrict kxbr4xtHyrrRrh5hrlJLIYaEhi8U2E3HKCCfH6wTf4MaVhT4zWhxokncHU61j4u

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
-- Name: notificacao; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."notificacao" (
    "id" integer NOT NULL,
    "autorizacao_id" bigint,
    "from_id" bigint,
    "to_id" bigint,
    "titulo" character varying(80) NOT NULL,
    "descricao" character varying(355) NOT NULL,
    "meta" "text",
    "status" integer,
    "lida_at" timestamp(0) without time zone,
    "arquivada_at" timestamp(0) without time zone,
    "deleted_at" timestamp without time zone,
    "created_at" timestamp without time zone,
    "updated_at" timestamp without time zone
);


--
-- Name: notificacao_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."notificacao_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notificacao_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."notificacao_id_seq" OWNED BY "public"."notificacao"."id";


--
-- Name: notificacao id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."notificacao" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."notificacao_id_seq"'::"regclass");


--
-- Name: notificacao notificacao_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."notificacao"
    ADD CONSTRAINT "notificacao_pk" PRIMARY KEY ("id");


--
-- PostgreSQL database dump complete
--

\unrestrict kxbr4xtHyrrRrh5hrlJLIYaEhi8U2E3HKCCfH6wTf4MaVhT4zWhxokncHU61j4u

