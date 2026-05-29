--
-- PostgreSQL database dump
--

\restrict 37XOLSbThBgD70rMRDVMZdqYaHyIKlYHztEte6y6ST48vNV7trjJRPI16EXadXE

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
-- Name: inventario; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."inventario" (
    "ano" character varying(4) NOT NULL,
    "mes" character varying(2) NOT NULL,
    "data_processamento" "date",
    "estoque" numeric,
    "total" numeric
);


--
-- Name: inventario pk_inventario; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."inventario"
    ADD CONSTRAINT "pk_inventario" PRIMARY KEY ("ano", "mes");


--
-- PostgreSQL database dump complete
--

\unrestrict 37XOLSbThBgD70rMRDVMZdqYaHyIKlYHztEte6y6ST48vNV7trjJRPI16EXadXE

