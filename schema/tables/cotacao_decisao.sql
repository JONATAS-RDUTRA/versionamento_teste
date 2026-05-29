--
-- PostgreSQL database dump
--

\restrict nA0D7Mwk3UWMoEZw5ItxawAUahKdRjC2rMI9a6hdZDTw5JNywG9MVXpFRfZaXQK

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
-- Name: cotacao_decisao; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."cotacao_decisao" (
    "cotacao_decisao_id" integer NOT NULL,
    "nome_decisao" character varying(35) NOT NULL
);


--
-- Name: cotacao_decisao_cotacao_decisao_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."cotacao_decisao_cotacao_decisao_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cotacao_decisao_cotacao_decisao_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."cotacao_decisao_cotacao_decisao_id_seq" OWNED BY "public"."cotacao_decisao"."cotacao_decisao_id";


--
-- Name: cotacao_decisao cotacao_decisao_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cotacao_decisao" ALTER COLUMN "cotacao_decisao_id" SET DEFAULT "nextval"('"public"."cotacao_decisao_cotacao_decisao_id_seq"'::"regclass");


--
-- Name: cotacao_decisao cotacao_decisao_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cotacao_decisao"
    ADD CONSTRAINT "cotacao_decisao_pkey" PRIMARY KEY ("cotacao_decisao_id");


--
-- PostgreSQL database dump complete
--

\unrestrict nA0D7Mwk3UWMoEZw5ItxawAUahKdRjC2rMI9a6hdZDTw5JNywG9MVXpFRfZaXQK

