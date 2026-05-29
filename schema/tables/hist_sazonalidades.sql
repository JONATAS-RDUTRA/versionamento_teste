--
-- PostgreSQL database dump
--

\restrict 8ubnRgjHwFtQaId2IYc4FLYaivkwyPtPYNhQxT4F8y4mgycRBsbJgharNthVsS6

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
-- Name: hist_sazonalidades; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."hist_sazonalidades" (
    "id" integer NOT NULL,
    "id_grupo" character varying(5) DEFAULT 0 NOT NULL,
    "filial" integer,
    "idproduto" character varying(10) NOT NULL,
    "idfornecedor" character varying(10) DEFAULT 0 NOT NULL,
    "dia_mes_inicial" "text",
    "dia_mes_final" "text",
    "porcentagem" numeric(12,2) DEFAULT 0 NOT NULL,
    "porcentagem_filial" numeric(12,2) DEFAULT 0,
    "status" character varying(1) DEFAULT 1 NOT NULL,
    "ano" character varying(9) NOT NULL,
    "recorrencia" character varying(1) DEFAULT 0 NOT NULL,
    "tipo_ajuste" character varying(1) DEFAULT 1 NOT NULL,
    "aplicado" character varying(1) DEFAULT 0,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


--
-- Name: hist_sazonalidades_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."hist_sazonalidades_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hist_sazonalidades_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."hist_sazonalidades_id_seq" OWNED BY "public"."hist_sazonalidades"."id";


--
-- Name: hist_sazonalidades id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."hist_sazonalidades" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."hist_sazonalidades_id_seq"'::"regclass");


--
-- Name: hist_sazonalidades hist_sazonalidade_id_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."hist_sazonalidades"
    ADD CONSTRAINT "hist_sazonalidade_id_pk" PRIMARY KEY ("id");


--
-- PostgreSQL database dump complete
--

\unrestrict 8ubnRgjHwFtQaId2IYc4FLYaivkwyPtPYNhQxT4F8y4mgycRBsbJgharNthVsS6

