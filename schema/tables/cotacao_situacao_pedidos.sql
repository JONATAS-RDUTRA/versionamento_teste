--
-- PostgreSQL database dump
--

\restrict 1IvbjnRRyuOsNDqW8foYaMiLpj1csAMOMmaQoC0CW7h5jGSGv0o8esQ1kAD19bW

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
-- Name: cotacao_situacao_pedidos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."cotacao_situacao_pedidos" (
    "cotacao_situacao_pedidos_id" integer NOT NULL,
    "nome_situacao_pedidos" character varying(35) NOT NULL
);


--
-- Name: cotacao_situacao_pedidos_cotacao_situacao_pedidos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."cotacao_situacao_pedidos_cotacao_situacao_pedidos_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cotacao_situacao_pedidos_cotacao_situacao_pedidos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."cotacao_situacao_pedidos_cotacao_situacao_pedidos_id_seq" OWNED BY "public"."cotacao_situacao_pedidos"."cotacao_situacao_pedidos_id";


--
-- Name: cotacao_situacao_pedidos cotacao_situacao_pedidos_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cotacao_situacao_pedidos" ALTER COLUMN "cotacao_situacao_pedidos_id" SET DEFAULT "nextval"('"public"."cotacao_situacao_pedidos_cotacao_situacao_pedidos_id_seq"'::"regclass");


--
-- Name: cotacao_situacao_pedidos cotacao_situacao_pedidos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cotacao_situacao_pedidos"
    ADD CONSTRAINT "cotacao_situacao_pedidos_pkey" PRIMARY KEY ("cotacao_situacao_pedidos_id");


--
-- PostgreSQL database dump complete
--

\unrestrict 1IvbjnRRyuOsNDqW8foYaMiLpj1csAMOMmaQoC0CW7h5jGSGv0o8esQ1kAD19bW

