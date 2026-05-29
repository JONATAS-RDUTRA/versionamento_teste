--
-- PostgreSQL database dump
--

\restrict 25RMNbuV7B5tcROdouFQmulJstCwnfYHwiKPrtJoJu7GcBbBIPyGSXy4nnQKBXH

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
-- Name: sys_produtos_analise_por_lotes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."sys_produtos_analise_por_lotes" (
    "filial" integer NOT NULL,
    "idproduto" character varying(25) NOT NULL,
    "tipo_ponto_pedido" boolean DEFAULT false NOT NULL,
    "ponto_pedido_fixo" numeric(12,4) NOT NULL,
    "ponto_pedido_percentual_influencia" numeric(4,2) NOT NULL,
    "cobertura_estoque" integer NOT NULL,
    "ponta_estoque_percentual" numeric(4,2) NOT NULL,
    "id_usuario" integer NOT NULL,
    "created_at" timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updated_at" timestamp without time zone
);


--
-- Name: sys_produtos_analise_por_lotes sys_produtos_analise_por_lotes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."sys_produtos_analise_por_lotes"
    ADD CONSTRAINT "sys_produtos_analise_por_lotes_pkey" PRIMARY KEY ("filial", "idproduto");


--
-- PostgreSQL database dump complete
--

\unrestrict 25RMNbuV7B5tcROdouFQmulJstCwnfYHwiKPrtJoJu7GcBbBIPyGSXy4nnQKBXH

