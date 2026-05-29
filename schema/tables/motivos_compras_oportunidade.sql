--
-- PostgreSQL database dump
--

\restrict Bgw4cIT1i100dmaNxJdx58HkxIppRsUaDO7ijHVr8k5Do3FihLBdrUjQnwktg53

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
-- Name: motivos_compras_oportunidade; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."motivos_compras_oportunidade" (
    "id" integer NOT NULL,
    "descricao" character varying(200) NOT NULL
);


--
-- Name: motivos_compras_oportunidade_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."motivos_compras_oportunidade_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: motivos_compras_oportunidade_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."motivos_compras_oportunidade_id_seq" OWNED BY "public"."motivos_compras_oportunidade"."id";


--
-- Name: motivos_compras_oportunidade id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."motivos_compras_oportunidade" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."motivos_compras_oportunidade_id_seq"'::"regclass");


--
-- Name: motivos_compras_oportunidade pk_motivos_compras_oportunidade; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."motivos_compras_oportunidade"
    ADD CONSTRAINT "pk_motivos_compras_oportunidade" PRIMARY KEY ("id");


--
-- PostgreSQL database dump complete
--

\unrestrict Bgw4cIT1i100dmaNxJdx58HkxIppRsUaDO7ijHVr8k5Do3FihLBdrUjQnwktg53

