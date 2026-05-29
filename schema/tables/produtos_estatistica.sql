--
-- PostgreSQL database dump
--

\restrict PmGTjGhfuo36bnYXiGCSxTlQAjw1tbUVN6Brm8UhgEaPvL98m7N8n7N3KJB9kf8

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
-- Name: produtos_estatistica; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."produtos_estatistica" (
    "idproduto" double precision DEFAULT 0 NOT NULL,
    "descricao_produto" character varying(255),
    "unidade_medida" character varying(255),
    "ultimo_idsolicitacao" double precision,
    "ultima_solicitacao" "date",
    "ultima_entrada" "date",
    "tempo_ressuprimento" double precision,
    "desvio_padrao" double precision,
    "atraso" integer,
    "favorito" character varying(1) DEFAULT 'N'::character varying
);


--
-- Name: produtos_estatistica produtos_estatistica_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."produtos_estatistica"
    ADD CONSTRAINT "produtos_estatistica_pkey" PRIMARY KEY ("idproduto");


--
-- PostgreSQL database dump complete
--

\unrestrict PmGTjGhfuo36bnYXiGCSxTlQAjw1tbUVN6Brm8UhgEaPvL98m7N8n7N3KJB9kf8

