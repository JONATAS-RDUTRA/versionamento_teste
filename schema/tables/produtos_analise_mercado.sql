--
-- PostgreSQL database dump
--

\restrict ZJdweJZAJxPLvsbvXL2JluIQ4CGrv5f2jVdrlhcIIDo0Zp9r3QysygVBgvU78l1

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
-- Name: produtos_analise_mercado; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."produtos_analise_mercado" (
    "id" integer NOT NULL,
    "mes" integer NOT NULL,
    "ano" integer NOT NULL,
    "id_grupo" integer NOT NULL,
    "cod_barras" character varying NOT NULL,
    "id_produto" character varying,
    "id_fornecedor" character varying,
    "data_envio" "date" DEFAULT "now"(),
    "mes_1" numeric(12,4),
    "mes_2" numeric(12,4),
    "mes_3" numeric(12,4),
    "mes_4" numeric(12,4),
    "mes_5" numeric(12,4),
    "mes_6" numeric(12,4),
    "mes_7" numeric(12,4),
    "mes_8" numeric(12,4),
    "mes_9" numeric(12,4),
    "mes_10" numeric(12,4),
    "mes_11" numeric(12,4),
    "mes_12" numeric(12,4)
);


--
-- Name: produtos_analise_mercado_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."produtos_analise_mercado_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: produtos_analise_mercado_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."produtos_analise_mercado_id_seq" OWNED BY "public"."produtos_analise_mercado"."id";


--
-- Name: produtos_analise_mercado id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."produtos_analise_mercado" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."produtos_analise_mercado_id_seq"'::"regclass");


--
-- Name: produtos_analise_mercado produtos_analise_mercado_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."produtos_analise_mercado"
    ADD CONSTRAINT "produtos_analise_mercado_pk" PRIMARY KEY ("id");


--
-- PostgreSQL database dump complete
--

\unrestrict ZJdweJZAJxPLvsbvXL2JluIQ4CGrv5f2jVdrlhcIIDo0Zp9r3QysygVBgvU78l1

