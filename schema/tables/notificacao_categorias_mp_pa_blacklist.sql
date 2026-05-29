--
-- PostgreSQL database dump
--

\restrict zxG4ChjLdZgNgPlxMxmWs3t2BShb9dsQYKa6bPUNTZW1utQ52aHGNAmppiDu45M

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
-- Name: notificacao_categorias_mp_pa_blacklist; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."notificacao_categorias_mp_pa_blacklist" (
    "id" integer NOT NULL,
    "grupo" bigint NOT NULL,
    "filial" bigint NOT NULL,
    "idcategoria" integer NOT NULL,
    "data_limite" "date" NOT NULL,
    "id_usuario_criacao" bigint NOT NULL,
    "id_usuario_exclusao" bigint,
    "created_at" timestamp(0) without time zone,
    "updated_at" timestamp(0) without time zone,
    "deleted_at" timestamp(0) without time zone
);


--
-- Name: notificacao_categorias_mp_pa_blacklist_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."notificacao_categorias_mp_pa_blacklist_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notificacao_categorias_mp_pa_blacklist_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."notificacao_categorias_mp_pa_blacklist_id_seq" OWNED BY "public"."notificacao_categorias_mp_pa_blacklist"."id";


--
-- Name: notificacao_categorias_mp_pa_blacklist id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."notificacao_categorias_mp_pa_blacklist" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."notificacao_categorias_mp_pa_blacklist_id_seq"'::"regclass");


--
-- Name: notificacao_categorias_mp_pa_blacklist pk_notificacao_categorias_mp_pa_blacklist; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."notificacao_categorias_mp_pa_blacklist"
    ADD CONSTRAINT "pk_notificacao_categorias_mp_pa_blacklist" PRIMARY KEY ("id");


--
-- PostgreSQL database dump complete
--

\unrestrict zxG4ChjLdZgNgPlxMxmWs3t2BShb9dsQYKa6bPUNTZW1utQ52aHGNAmppiDu45M

