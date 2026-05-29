--
-- PostgreSQL database dump
--

\restrict pYdN2L6BR6OycisxQhy8pKo5GflmApRDkAMhg95NF29GcFIbZPg3zqp7kHclnu2

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
-- Name: produtos_margem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."produtos_margem" (
    "filial" bigint NOT NULL,
    "idproduto" character varying(25) DEFAULT ''::character varying NOT NULL,
    "ano" integer NOT NULL,
    "mes" integer NOT NULL,
    "valor_faturamento_bruto" numeric(12,4),
    "valor_custo" numeric(12,4),
    "valor_lucro_bruto" numeric(12,4)
);


--
-- Name: produtos_margem produtos_margem_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."produtos_margem"
    ADD CONSTRAINT "produtos_margem_pk" PRIMARY KEY ("filial", "idproduto", "ano", "mes");


--
-- PostgreSQL database dump complete
--

\unrestrict pYdN2L6BR6OycisxQhy8pKo5GflmApRDkAMhg95NF29GcFIbZPg3zqp7kHclnu2

