--
-- PostgreSQL database dump
--

\restrict Rc7QXFmhu0h8GTH0Tc56jehpffLWAtrD5RNSDsIt1Sd7jEXmCsziU7l0RwCCvRn

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
-- Name: analise_statistica_produtos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."analise_statistica_produtos" (
    "filial" bigint NOT NULL,
    "idproduto" character varying(25) NOT NULL,
    "q1" numeric(12,2),
    "q3" numeric(12,2),
    "iqr" numeric(12,2),
    "limite_inferior" numeric(12,2),
    "limite_superior" numeric(12,2)
);


--
-- Name: analise_statistica_produtos analise_statistica_produtos_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."analise_statistica_produtos"
    ADD CONSTRAINT "analise_statistica_produtos_pk" PRIMARY KEY ("filial", "idproduto");


--
-- PostgreSQL database dump complete
--

\unrestrict Rc7QXFmhu0h8GTH0Tc56jehpffLWAtrD5RNSDsIt1Sd7jEXmCsziU7l0RwCCvRn

