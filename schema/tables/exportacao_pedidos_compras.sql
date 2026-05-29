--
-- PostgreSQL database dump
--

\restrict gnujrNtc6wHPbeiEL2lOFJnjMkGPX8fItTRbcXYYLB7Lm6Xqvtzn1hkf1I1w8t4

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
-- Name: exportacao_pedidos_compras; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."exportacao_pedidos_compras" (
    "idpedido" bigint NOT NULL,
    "exportacao" "json" NOT NULL,
    "data_exportacao" "date" DEFAULT CURRENT_DATE NOT NULL,
    "extra" "json"
);


--
-- Name: exportacao_pedidos_compras pk_exportacao_pedidos_compras; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."exportacao_pedidos_compras"
    ADD CONSTRAINT "pk_exportacao_pedidos_compras" PRIMARY KEY ("idpedido");


--
-- PostgreSQL database dump complete
--

\unrestrict gnujrNtc6wHPbeiEL2lOFJnjMkGPX8fItTRbcXYYLB7Lm6Xqvtzn1hkf1I1w8t4

