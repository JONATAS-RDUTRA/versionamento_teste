--
-- PostgreSQL database dump
--

\restrict e9ByegnA2YelcGwSKUArdZXT3Gx9hcsi9vYSbEIxM4RHHuOn8cN1GcP63VLgEnU

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
-- Name: sys_tipo_projecao_media_sazonal_produtos_filial; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."sys_tipo_projecao_media_sazonal_produtos_filial" (
    "filial" integer NOT NULL,
    "idproduto" character varying(25) NOT NULL,
    "data_inicial_vendas" "date" NOT NULL,
    "data_final_vendas" "date" NOT NULL,
    "data_inicial_aplicacao" "date" NOT NULL,
    "data_final_aplicacao" "date" NOT NULL,
    "desconsiderar_vendas_acontecidas_durante_aplicacao" boolean DEFAULT true NOT NULL,
    "tipo_influencia" character varying(7),
    "percentual_influencia" integer,
    CONSTRAINT "check_tipo_influencia_permitidos" CHECK ((("tipo_influencia")::"text" = ANY (ARRAY[('AUMENTO'::character varying)::"text", ('REDUCAO'::character varying)::"text"])))
);


--
-- Name: sys_tipo_projecao_media_sazonal_produtos_filial sys_tipo_projecao_media_sazonal_produtos_filial_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."sys_tipo_projecao_media_sazonal_produtos_filial"
    ADD CONSTRAINT "sys_tipo_projecao_media_sazonal_produtos_filial_pkey" PRIMARY KEY ("filial", "idproduto", "data_inicial_aplicacao", "data_final_aplicacao");


--
-- PostgreSQL database dump complete
--

\unrestrict e9ByegnA2YelcGwSKUArdZXT3Gx9hcsi9vYSbEIxM4RHHuOn8cN1GcP63VLgEnU

