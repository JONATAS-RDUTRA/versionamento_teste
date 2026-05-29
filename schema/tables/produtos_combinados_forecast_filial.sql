--
-- PostgreSQL database dump
--

\restrict U3OwHutEjucdSv2E6tUUIUcHAPs8Mjwdq9eFEf4aatwoXEalqctYfmkCWncQqHG

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
-- Name: produtos_combinados_forecast_filial; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."produtos_combinados_forecast_filial" (
    "id_grupo" bigint NOT NULL,
    "filial" bigint NOT NULL,
    "id_produto_combinado" character varying(36) NOT NULL,
    "estoque_futuro" double precision,
    "lote_compras" numeric,
    "lote_compras_bruto" numeric,
    "flag" character varying(1)
);


--
-- Name: produtos_combinados_forecast_filial produtos_combinados_forecast_filial_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."produtos_combinados_forecast_filial"
    ADD CONSTRAINT "produtos_combinados_forecast_filial_pkey" PRIMARY KEY ("id_grupo", "filial", "id_produto_combinado");


--
-- PostgreSQL database dump complete
--

\unrestrict U3OwHutEjucdSv2E6tUUIUcHAPs8Mjwdq9eFEf4aatwoXEalqctYfmkCWncQqHG

