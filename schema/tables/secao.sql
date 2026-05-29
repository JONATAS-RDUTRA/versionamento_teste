--
-- PostgreSQL database dump
--

\restrict tvzv6o1UAwnwdMZV7DKjbIRj5kL3dfDXj5fO2N8xitHlqbf3HNKyU9BMi9qg2QI

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
-- Name: secao; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."secao" (
    "idsecao" integer NOT NULL,
    "descricao_secao" character varying(45),
    "iddepartamento" bigint,
    "idcomprador" bigint
);


--
-- Name: secao_idsecao_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."secao_idsecao_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: secao_idsecao_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."secao_idsecao_seq" OWNED BY "public"."secao"."idsecao";


--
-- Name: secao idsecao; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."secao" ALTER COLUMN "idsecao" SET DEFAULT "nextval"('"public"."secao_idsecao_seq"'::"regclass");


--
-- Name: secao secao_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."secao"
    ADD CONSTRAINT "secao_pkey" PRIMARY KEY ("idsecao");


--
-- PostgreSQL database dump complete
--

\unrestrict tvzv6o1UAwnwdMZV7DKjbIRj5kL3dfDXj5fO2N8xitHlqbf3HNKyU9BMi9qg2QI

