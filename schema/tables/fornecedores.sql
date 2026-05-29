--
-- PostgreSQL database dump
--

\restrict wJvB6GvcD23uFDyYSweIBWCWfhoSWpingDQIuQgYWic6x6RHI24wJrOH1bO2xok

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
-- Name: fornecedores; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."fornecedores" (
    "idfornecedor" integer DEFAULT "nextval"('"public"."fornecedores_idfornecedor_seq"'::"regclass") NOT NULL,
    "razao_social" character varying(60),
    "nome_fantasia" character varying(60),
    "cep" character varying(9),
    "endereco" character varying(100),
    "cidade" character varying(45),
    "estado" character varying(2),
    "inscricao_estadual" character varying(15),
    "cnpj" character varying(15),
    "email" character varying(60),
    "contato" character varying(60),
    "telefone_contato" character varying(15)
);


--
-- Name: fornecedores fornecedores_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."fornecedores"
    ADD CONSTRAINT "fornecedores_pkey" PRIMARY KEY ("idfornecedor");


--
-- PostgreSQL database dump complete
--

\unrestrict wJvB6GvcD23uFDyYSweIBWCWfhoSWpingDQIuQgYWic6x6RHI24wJrOH1bO2xok

