--
-- PostgreSQL database dump
--

\restrict vOg5HvPazI8rA3qiNLG3lFasvDbq4zZEjFPqu2Z2voVu1nnhKSXHpT6WSAX9YY1

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
-- Name: produtos_combinados_forecast_grupo; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."produtos_combinados_forecast_grupo" (
    "id_grupo" bigint NOT NULL,
    "id_produto_combinado" character varying(36) NOT NULL,
    "estoque_futuro" double precision,
    "lote_compras" numeric,
    "lote_compras_bruto" numeric,
    "flag" character varying(1)
);


--
-- Name: produtos_combinados_forecast_grupo produtos_combinados_forecast_grupo_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."produtos_combinados_forecast_grupo"
    ADD CONSTRAINT "produtos_combinados_forecast_grupo_pkey" PRIMARY KEY ("id_grupo", "id_produto_combinado");


--
-- PostgreSQL database dump complete
--

\unrestrict vOg5HvPazI8rA3qiNLG3lFasvDbq4zZEjFPqu2Z2voVu1nnhKSXHpT6WSAX9YY1

