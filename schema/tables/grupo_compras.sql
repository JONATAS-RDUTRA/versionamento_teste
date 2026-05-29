--
-- PostgreSQL database dump
--

\restrict U1TrDRF4kSFSZ85MjG8QuN1A5gRUSn9kgPbncR1fRpVQecwEj2iNng8ay95zJdp

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
-- Name: grupo_compras; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."grupo_compras" (
    "id" integer NOT NULL,
    "descricao" character varying(60) NOT NULL,
    "data_cadastro" "date" DEFAULT ('now'::"text")::"date" NOT NULL,
    "sigla" character varying(3),
    "visao_dashboard" integer DEFAULT 1 NOT NULL,
    "ativar_drp" character varying(1) DEFAULT 'S'::character varying,
    "grupo_agrega" character varying(1) DEFAULT 'N'::character varying,
    "ativar_compra" character(1) DEFAULT 'S'::"bpchar" NOT NULL,
    "id_usuario" integer,
    "oculto_na_opcao_todos_grupos" boolean DEFAULT false NOT NULL
);


--
-- Name: grupo_compras_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."grupo_compras_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: grupo_compras_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."grupo_compras_id_seq" OWNED BY "public"."grupo_compras"."id";


--
-- Name: grupo_compras id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."grupo_compras" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."grupo_compras_id_seq"'::"regclass");


--
-- Name: grupo_compras grupo_compras_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."grupo_compras"
    ADD CONSTRAINT "grupo_compras_pk" PRIMARY KEY ("id");


--
-- PostgreSQL database dump complete
--

\unrestrict U1TrDRF4kSFSZ85MjG8QuN1A5gRUSn9kgPbncR1fRpVQecwEj2iNng8ay95zJdp

