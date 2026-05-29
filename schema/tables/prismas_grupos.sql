--
-- PostgreSQL database dump
--

\restrict DkJc93VDGT8TkPWZU1GUMK7Um7D0i4AZX0AvaCRjQyW6FKNNg4GkksWFd4UGTIa

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
-- Name: prismas_grupos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."prismas_grupos" (
    "id_grupo" bigint NOT NULL,
    "idproduto" character varying(25) NOT NULL,
    "data_ref" "date" NOT NULL,
    "arvore_decisao" character varying(4),
    "fes" numeric(12,4),
    "nivel_servico" character varying(25) NOT NULL
)
WITH ("autovacuum_vacuum_scale_factor"='2.96159');


--
-- Name: prismas_grupos prismas_grupos_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."prismas_grupos"
    ADD CONSTRAINT "prismas_grupos_pk" PRIMARY KEY ("id_grupo", "idproduto", "data_ref");


--
-- PostgreSQL database dump complete
--

\unrestrict DkJc93VDGT8TkPWZU1GUMK7Um7D0i4AZX0AvaCRjQyW6FKNNg4GkksWFd4UGTIa

