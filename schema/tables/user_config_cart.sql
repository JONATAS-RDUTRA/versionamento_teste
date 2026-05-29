--
-- PostgreSQL database dump
--

\restrict d3J8F5bcSbk7f3lPYJbKdNIYrHTpMXxdJv5EWCCZ2UokjObtxXb7SzvqBXugqTX

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
-- Name: user_config_cart; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."user_config_cart" (
    "iduser" bigint NOT NULL,
    "peso" boolean DEFAULT false NOT NULL,
    "cubagem" boolean DEFAULT false NOT NULL,
    "cobertura_estoque_futura" boolean DEFAULT false NOT NULL,
    "preco_liquido_total" boolean DEFAULT false NOT NULL,
    "classificacao_rentabilidade" boolean DEFAULT false,
    "classificacao_criticidade" boolean DEFAULT false,
    "estoque" boolean DEFAULT false NOT NULL,
    "codigo_barras" boolean DEFAULT false NOT NULL,
    "lastro_palete" boolean DEFAULT false,
    "altura_palete" boolean DEFAULT false,
    "qt_total_palete" boolean DEFAULT false,
    "data_ultima_entrada" boolean DEFAULT false,
    "compra_em_palete" boolean DEFAULT false
);


--
-- Name: user_config_cart pk_user_config_cart; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."user_config_cart"
    ADD CONSTRAINT "pk_user_config_cart" PRIMARY KEY ("iduser");


--
-- PostgreSQL database dump complete
--

\unrestrict d3J8F5bcSbk7f3lPYJbKdNIYrHTpMXxdJv5EWCCZ2UokjObtxXb7SzvqBXugqTX

