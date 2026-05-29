--
-- PostgreSQL database dump
--

\restrict ahXUIud28qXTERQoT6f2YabpJxb0V779lpTEmmJ3jJZ4RRId5JoarATQNTbEldc

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
-- Name: sys_justificativas_distribuicao_drp; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."sys_justificativas_distribuicao_drp" (
    "id" bigint NOT NULL,
    "idusuario" integer NOT NULL,
    "idpedido" integer NOT NULL,
    "escopo" character varying(50) NOT NULL,
    "tipo_justificativa" character varying(50) NOT NULL,
    "justificativa" "text" NOT NULL,
    "created_at" timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: sys_justificativas_distribuicao_drp_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."sys_justificativas_distribuicao_drp_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sys_justificativas_distribuicao_drp_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."sys_justificativas_distribuicao_drp_id_seq" OWNED BY "public"."sys_justificativas_distribuicao_drp"."id";


--
-- Name: sys_justificativas_distribuicao_drp id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."sys_justificativas_distribuicao_drp" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."sys_justificativas_distribuicao_drp_id_seq"'::"regclass");


--
-- Name: sys_justificativas_distribuicao_drp sys_justificativas_distribuicao_drp_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."sys_justificativas_distribuicao_drp"
    ADD CONSTRAINT "sys_justificativas_distribuicao_drp_pkey" PRIMARY KEY ("id");


--
-- PostgreSQL database dump complete
--

\unrestrict ahXUIud28qXTERQoT6f2YabpJxb0V779lpTEmmJ3jJZ4RRId5JoarATQNTbEldc

