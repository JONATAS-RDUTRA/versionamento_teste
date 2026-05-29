--
-- PostgreSQL database dump
--

\restrict rc2gzrE7pbXitBJkH0qNkG0FKzR57qhVOOh8pD1NULNRCM299AXtZsD9rajcKlQ

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
-- Name: filial; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."filial" (
    "idfilial" integer DEFAULT "nextval"('"public"."filial_idfilial_seq"'::"regclass") NOT NULL,
    "codigo_filial_cliente" character varying(45),
    "razao_social" character varying(60),
    "nome_fantasia" character varying(60),
    "endereco" character varying(60),
    "cidade" character varying(25),
    "estado" character varying(2),
    "inscricao_estadual" character varying(15),
    "cnpj" character varying(25),
    "cep" character varying(15),
    "suframa" character varying(15),
    "idclifor" integer
);


--
-- Name: COLUMN "filial"."idclifor"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."filial"."idclifor" IS 'ID DO CLIENTE FORNECEDOR DA FILIAL';


--
-- Name: filial filial_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."filial"
    ADD CONSTRAINT "filial_pkey" PRIMARY KEY ("idfilial");


--
-- PostgreSQL database dump complete
--

\unrestrict rc2gzrE7pbXitBJkH0qNkG0FKzR57qhVOOh8pD1NULNRCM299AXtZsD9rajcKlQ

