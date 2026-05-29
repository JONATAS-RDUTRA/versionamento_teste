--
-- PostgreSQL database dump
--

\restrict tW7jVbYTWjcUYuue4mei3OMJrcKv5kdG5YvvXeIzOhUuIoQkbxjjO0c9k5c1za2

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
-- Name: prismas_filiais; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."prismas_filiais" (
    "filial" bigint NOT NULL,
    "idproduto" character varying(25) NOT NULL,
    "data_ref" "date" NOT NULL,
    "arvore_decisao" character varying(4),
    "classificacao_rentabilidade" character(1)
)
WITH ("autovacuum_vacuum_scale_factor"='1.07871');


--
-- Name: prismas_filiais prismas_filiais_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."prismas_filiais"
    ADD CONSTRAINT "prismas_filiais_pk" PRIMARY KEY ("filial", "idproduto", "data_ref");


--
-- PostgreSQL database dump complete
--

\unrestrict tW7jVbYTWjcUYuue4mei3OMJrcKv5kdG5YvvXeIzOhUuIoQkbxjjO0c9k5c1za2

