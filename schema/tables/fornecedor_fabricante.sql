--
-- PostgreSQL database dump
--

\restrict EZQKV2sz6QPUFZ5tz038s7oOuBojeU4sEyGrfMQn6r1xFc9tT4gt6LjTJOP1ZFE

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
-- Name: fornecedor_fabricante; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."fornecedor_fabricante" (
    "idfornecedor" bigint NOT NULL,
    "razao_social" character varying(100),
    "cnpj" character varying(15),
    "idfabricante" bigint NOT NULL,
    "loja" character varying(2),
    "padrao" boolean DEFAULT false,
    "quantidade_parcelas" integer,
    "quantidade_dias_entre_parcelas" integer
);


--
-- Name: fornecedor_fabricante fornecedor_fabricante_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."fornecedor_fabricante"
    ADD CONSTRAINT "fornecedor_fabricante_pkey" PRIMARY KEY ("idfornecedor", "idfabricante");


--
-- PostgreSQL database dump complete
--

\unrestrict EZQKV2sz6QPUFZ5tz038s7oOuBojeU4sEyGrfMQn6r1xFc9tT4gt6LjTJOP1ZFE

