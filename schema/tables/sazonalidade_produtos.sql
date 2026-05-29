--
-- PostgreSQL database dump
--

\restrict kgisoWC3zRL93yCsdH8ewbNYMjXMyhEL7edUMelqPA53PcyBQs3kgqvLQ2eseJ5

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
-- Name: sazonalidade_produtos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."sazonalidade_produtos" (
    "id_grupo" bigint NOT NULL,
    "trimestre" integer NOT NULL,
    "idproduto" character varying(25) NOT NULL,
    "ano_referencia" integer,
    "sd_ano_1" numeric(12,4) DEFAULT 0,
    "sd_ano_2" numeric(12,4) DEFAULT 0,
    "sd_ano_3" numeric(12,4) DEFAULT 0,
    "sd_ano_4" numeric(12,4) DEFAULT 0,
    "total_ano_1" numeric(12,4) DEFAULT 0,
    "total_ano_2" numeric(12,4) DEFAULT 0,
    "total_ano_3" numeric(12,4) DEFAULT 0,
    "total_ano_4" numeric(12,4) DEFAULT 0,
    "media_ano_1" numeric(12,4) DEFAULT 0,
    "media_ano_2" numeric(12,4) DEFAULT 0,
    "media_ano_3" numeric(12,4) DEFAULT 0,
    "media_ano_4" numeric(12,4) DEFAULT 0,
    "coef_ano_1" numeric(12,4) DEFAULT 0,
    "coef_ano_2" numeric(12,4) DEFAULT 0,
    "coef_ano_3" numeric(12,4) DEFAULT 0,
    "coef_ano_4" numeric(12,4) DEFAULT 0,
    "coef_medio" numeric(12,4) DEFAULT 0,
    "mca" numeric(12,4) DEFAULT 0,
    "taxa_crescimento" numeric(12,4) DEFAULT 0,
    "prev_cresc_trim" numeric(12,4) DEFAULT 0
);


--
-- Name: sazonalidade_produtos sazonalidade_produtos_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."sazonalidade_produtos"
    ADD CONSTRAINT "sazonalidade_produtos_pk" PRIMARY KEY ("id_grupo", "trimestre", "idproduto");


--
-- PostgreSQL database dump complete
--

\unrestrict kgisoWC3zRL93yCsdH8ewbNYMjXMyhEL7edUMelqPA53PcyBQs3kgqvLQ2eseJ5

