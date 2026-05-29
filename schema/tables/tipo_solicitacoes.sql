--
-- PostgreSQL database dump
--

\restrict dzOCIxc8SaRrIHcKUdn7pac0xmnZNSgbZHCkGlCbHTJrwlQMy6hOvfE7Cx2mZpf

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
-- Name: tipo_solicitacoes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."tipo_solicitacoes" (
    "idtipo_solicitacao" integer DEFAULT "nextval"('"public"."tipo_solicitacoes_idtipo_solicitacao_seq"'::"regclass") NOT NULL,
    "descricao_tipo_solicitacao" character varying(45)
);


--
-- Name: tipo_solicitacoes tipo_solicitacoes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."tipo_solicitacoes"
    ADD CONSTRAINT "tipo_solicitacoes_pkey" PRIMARY KEY ("idtipo_solicitacao");


--
-- PostgreSQL database dump complete
--

\unrestrict dzOCIxc8SaRrIHcKUdn7pac0xmnZNSgbZHCkGlCbHTJrwlQMy6hOvfE7Cx2mZpf

