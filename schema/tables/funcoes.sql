--
-- PostgreSQL database dump
--

\restrict 7sXMJcDeZx0RxrW94q012bWr035GLoyULK884EGSbXteh97aBpDplkY2OdXF7LZ

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
-- Name: funcoes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."funcoes" (
    "idfuncao" integer DEFAULT "nextval"('"public"."funcoes_idfuncao_seq"'::"regclass") NOT NULL,
    "descricao_funcao" character varying(60)
);


--
-- Name: funcoes funcoes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."funcoes"
    ADD CONSTRAINT "funcoes_pkey" PRIMARY KEY ("idfuncao");


--
-- PostgreSQL database dump complete
--

\unrestrict 7sXMJcDeZx0RxrW94q012bWr035GLoyULK884EGSbXteh97aBpDplkY2OdXF7LZ

