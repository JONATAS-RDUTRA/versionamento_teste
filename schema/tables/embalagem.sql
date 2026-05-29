--
-- PostgreSQL database dump
--

\restrict ES3X4KtmosFEUY7Gd5miXPdFIt8XpRvS1RwMRvJ9Q4r0uxPvrrMGwnryT6Pc7bD

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
-- Name: embalagem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."embalagem" (
    "codauxiliar" numeric(20,0) NOT NULL,
    "filial" integer NOT NULL,
    "idproduto" character varying(25) NOT NULL,
    "qtunit" numeric(12,7) NOT NULL,
    "unidade" character varying(10),
    "embalagem" character varying(25),
    "emb_padrao" character varying(2),
    "log_user" integer,
    "log_data" timestamp without time zone
);


--
-- Name: embalagem embalagem_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."embalagem"
    ADD CONSTRAINT "embalagem_pk" PRIMARY KEY ("codauxiliar", "filial");


--
-- PostgreSQL database dump complete
--

\unrestrict ES3X4KtmosFEUY7Gd5miXPdFIt8XpRvS1RwMRvJ9Q4r0uxPvrrMGwnryT6Pc7bD

