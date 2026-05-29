--
-- PostgreSQL database dump
--

\restrict ia7Wp26lckygRTD4JokW9TiM5aiBuvhcerZtjjDhqiWg14p7jRj1ktzNf4pRoxS

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
-- Name: produtos_impostos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."produtos_impostos" (
    "filial" bigint NOT NULL,
    "idproduto" character varying(25) NOT NULL,
    "idfornecedor" bigint NOT NULL,
    "preco_atacado" numeric(12,2),
    "preco_varejo" numeric(12,2),
    "perc_suframa" numeric(12,2),
    "perc_iva" numeric(12,2),
    "perc_aliqint" numeric(12,2),
    "perc_aliqext" numeric(12,2),
    "perc_pis" numeric(12,2),
    "perc_cofins" numeric(12,2),
    "perc_icm" numeric(12,2),
    "cod_icm" numeric(12,2)
);


--
-- Name: produtos_impostos produtos_impostos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."produtos_impostos"
    ADD CONSTRAINT "produtos_impostos_pkey" PRIMARY KEY ("filial", "idproduto", "idfornecedor");


--
-- PostgreSQL database dump complete
--

\unrestrict ia7Wp26lckygRTD4JokW9TiM5aiBuvhcerZtjjDhqiWg14p7jRj1ktzNf4pRoxS

