--
-- PostgreSQL database dump
--

\restrict 8e51hHXykgJgHbZhR5Ch6u0k6gbNXu2sxNPr8qRSBsyhwbaCWisYtJdoaOodRKb

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
-- Name: tipos_pedidos_compras; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."tipos_pedidos_compras" (
    "id" character(1) NOT NULL,
    "descricao_tipo" character varying(50) NOT NULL,
    "created_at" character varying(30)
);


--
-- Name: tipos_pedidos_compras tipos_pedidos_compras_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."tipos_pedidos_compras"
    ADD CONSTRAINT "tipos_pedidos_compras_pkey" PRIMARY KEY ("id");


--
-- PostgreSQL database dump complete
--

\unrestrict 8e51hHXykgJgHbZhR5Ch6u0k6gbNXu2sxNPr8qRSBsyhwbaCWisYtJdoaOodRKb

