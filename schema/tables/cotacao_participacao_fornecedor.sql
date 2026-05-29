--
-- PostgreSQL database dump
--

\restrict 8bMEtldnTNTSXAY1YUzLmeT750j9JTSa9Pnkcs8bx8HEcLb77TbvnStQdyuuYLb

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
-- Name: cotacao_participacao_fornecedor; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."cotacao_participacao_fornecedor" (
    "cotacao_participacao_fornecedor_id" integer NOT NULL,
    "status_participacao_fornecedor" character varying(35) NOT NULL
);


--
-- Name: cotacao_participacao_forneced_cotacao_participacao_forneced_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."cotacao_participacao_forneced_cotacao_participacao_forneced_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cotacao_participacao_forneced_cotacao_participacao_forneced_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."cotacao_participacao_forneced_cotacao_participacao_forneced_seq" OWNED BY "public"."cotacao_participacao_fornecedor"."cotacao_participacao_fornecedor_id";


--
-- Name: cotacao_participacao_fornecedor cotacao_participacao_fornecedor_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cotacao_participacao_fornecedor" ALTER COLUMN "cotacao_participacao_fornecedor_id" SET DEFAULT "nextval"('"public"."cotacao_participacao_forneced_cotacao_participacao_forneced_seq"'::"regclass");


--
-- Name: cotacao_participacao_fornecedor cotacao_participacao_fornecedor_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cotacao_participacao_fornecedor"
    ADD CONSTRAINT "cotacao_participacao_fornecedor_pkey" PRIMARY KEY ("cotacao_participacao_fornecedor_id");


--
-- PostgreSQL database dump complete
--

\unrestrict 8bMEtldnTNTSXAY1YUzLmeT750j9JTSa9Pnkcs8bx8HEcLb77TbvnStQdyuuYLb

