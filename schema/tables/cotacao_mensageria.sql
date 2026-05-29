--
-- PostgreSQL database dump
--

\restrict WuHx9phcWt2ex9SNauYyTWldCxOYN3r8TY2RzTDom3Vmt7ktRxYr7h6cUOAHhCy

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
-- Name: cotacao_mensageria; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."cotacao_mensageria" (
    "cotacao_mensageria_id" integer NOT NULL,
    "template_id" character varying(255),
    "tipo_mensageria" character varying(100),
    "descricao_mensageria" character varying(255)
);


--
-- Name: cotacao_mensageria_cotacao_mensageria_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."cotacao_mensageria_cotacao_mensageria_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cotacao_mensageria_cotacao_mensageria_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."cotacao_mensageria_cotacao_mensageria_id_seq" OWNED BY "public"."cotacao_mensageria"."cotacao_mensageria_id";


--
-- Name: cotacao_mensageria cotacao_mensageria_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cotacao_mensageria" ALTER COLUMN "cotacao_mensageria_id" SET DEFAULT "nextval"('"public"."cotacao_mensageria_cotacao_mensageria_id_seq"'::"regclass");


--
-- Name: cotacao_mensageria cotacao_mensageria_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cotacao_mensageria"
    ADD CONSTRAINT "cotacao_mensageria_pkey" PRIMARY KEY ("cotacao_mensageria_id");


--
-- PostgreSQL database dump complete
--

\unrestrict WuHx9phcWt2ex9SNauYyTWldCxOYN3r8TY2RzTDom3Vmt7ktRxYr7h6cUOAHhCy

