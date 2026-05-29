--
-- PostgreSQL database dump
--

\restrict Z2bi5DOqEzWncnKNGhfNGxH42SJlCXj5AaMqmgf4CPEfJUbfB6y3Gb4ASaFYSOg

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
-- Name: ressuprimentos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."ressuprimentos" (
    "idproduto" character varying(25) NOT NULL,
    "lote_compras" real,
    "pedido_compras" integer DEFAULT 0 NOT NULL,
    "lote_minino" real,
    "data_pedido" "date",
    "processamento" timestamp without time zone DEFAULT "now"()
);


--
-- Name: ressuprimentos ressuprimentos_pk_; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."ressuprimentos"
    ADD CONSTRAINT "ressuprimentos_pk_" PRIMARY KEY ("idproduto", "pedido_compras");


--
-- PostgreSQL database dump complete
--

\unrestrict Z2bi5DOqEzWncnKNGhfNGxH42SJlCXj5AaMqmgf4CPEfJUbfB6y3Gb4ASaFYSOg

