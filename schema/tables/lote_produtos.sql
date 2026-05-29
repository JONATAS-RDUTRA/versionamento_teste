--
-- PostgreSQL database dump
--

\restrict PJrXDETaBsha7FJIwD8yVB4LIdjNMs45qdyF8w8BzInm3Xbt1FTliS1pVDAzFgD

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
-- Name: lote_produtos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."lote_produtos" (
    "numlote" character varying(30) NOT NULL,
    "filial" integer NOT NULL,
    "idproduto" character varying(25) NOT NULL,
    "numlotefab" character varying(30),
    "numlotefornec" character varying(30),
    "qtde" numeric(12,4) NOT NULL,
    "dtvalidade" "date",
    "dtultmovsai" "date",
    "dtultmovent" "date"
);


--
-- Name: lote_produtos lote_produtos_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."lote_produtos"
    ADD CONSTRAINT "lote_produtos_pk" PRIMARY KEY ("numlote", "filial", "idproduto");


--
-- PostgreSQL database dump complete
--

\unrestrict PJrXDETaBsha7FJIwD8yVB4LIdjNMs45qdyF8w8BzInm3Xbt1FTliS1pVDAzFgD

