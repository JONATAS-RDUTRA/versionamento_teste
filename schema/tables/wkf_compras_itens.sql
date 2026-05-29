--
-- PostgreSQL database dump
--

\restrict UPezos32ov3le3b58VT4ZP4DszNJbv27X3OICfYPlaTcY96vnfC9fr5CA47dn65

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
-- Name: wkf_compras_itens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."wkf_compras_itens" (
    "id" integer NOT NULL,
    "descricao" character varying(100) NOT NULL,
    "tipo" integer NOT NULL,
    "grupo" integer DEFAULT 2 NOT NULL,
    "regra" integer,
    "tabela_referencia" character varying(50),
    "coluna_referencia" character varying(50)
);


--
-- Name: COLUMN "wkf_compras_itens"."tipo"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."wkf_compras_itens"."tipo" IS '1- Campo Descritivo (S,N)
2- Campo Quantitativo (Valores)';


--
-- Name: COLUMN "wkf_compras_itens"."regra"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."wkf_compras_itens"."regra" IS '1-ativa(A regra será aplicada no momento da ação) 2-reativa(A regra será enviado para workflow de aprovação)';


--
-- Name: wkf_compras_itens_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."wkf_compras_itens_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: wkf_compras_itens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."wkf_compras_itens_id_seq" OWNED BY "public"."wkf_compras_itens"."id";


--
-- Name: wkf_compras_itens id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."wkf_compras_itens" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."wkf_compras_itens_id_seq"'::"regclass");


--
-- Name: wkf_compras_itens wkf_compras_itens_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."wkf_compras_itens"
    ADD CONSTRAINT "wkf_compras_itens_pk" PRIMARY KEY ("id");


--
-- PostgreSQL database dump complete
--

\unrestrict UPezos32ov3le3b58VT4ZP4DszNJbv27X3OICfYPlaTcY96vnfC9fr5CA47dn65

