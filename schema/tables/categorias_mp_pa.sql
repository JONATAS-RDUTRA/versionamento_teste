--
-- PostgreSQL database dump
--

\restrict loyC9iD9nC08bfPAbDRUX2YPh89B36I5UKdOMc7CTRsiggOrMbosSWBmmrh5SWP

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
-- Name: categorias_mp_pa; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."categorias_mp_pa" (
    "id" integer NOT NULL,
    "nome" character varying(100) NOT NULL,
    "tempo_ressuprimento" numeric(12,4) DEFAULT 1.17 NOT NULL,
    "tempo_medio_ressuprimento" integer DEFAULT 35 NOT NULL,
    "lote_minimo" integer DEFAULT 1 NOT NULL,
    "desvio_padrao_ressuprimento" integer DEFAULT 0 NOT NULL,
    "cobertura_manual_categoria" integer DEFAULT 0 NOT NULL,
    "tempo_forecast" integer DEFAULT 15
);


--
-- Name: categorias_mp_pa_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."categorias_mp_pa_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categorias_mp_pa_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."categorias_mp_pa_id_seq" OWNED BY "public"."categorias_mp_pa"."id";


--
-- Name: categorias_mp_pa id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."categorias_mp_pa" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."categorias_mp_pa_id_seq"'::"regclass");


--
-- Name: categorias_mp_pa capa_categorias_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."categorias_mp_pa"
    ADD CONSTRAINT "capa_categorias_pkey" PRIMARY KEY ("id");


--
-- PostgreSQL database dump complete
--

\unrestrict loyC9iD9nC08bfPAbDRUX2YPh89B36I5UKdOMc7CTRsiggOrMbosSWBmmrh5SWP

