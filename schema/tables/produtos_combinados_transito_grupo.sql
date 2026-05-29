--
-- PostgreSQL database dump
--

\restrict NXATeTmjXSBvUnnd1YJReruC8XIKHBgytEgS4eoAv4Ujn9ppOg7d9skncPDrOLy

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
-- Name: produtos_combinados_transito_grupo; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."produtos_combinados_transito_grupo" (
    "id_grupo" bigint NOT NULL,
    "id_produto_combinado" character varying(36) NOT NULL,
    "compra_transito" numeric,
    "consumo_transito" numeric,
    "saldo_futuro" numeric,
    "status" "text",
    "lote_compras" double precision,
    "data_ultima_requisicao" "date",
    "tempo_pedido" integer,
    "gatilho_transito" integer,
    "flag" character varying(1),
    "processamento" timestamp(0) without time zone
);


--
-- Name: produtos_combinados_transito_grupo produtos_combinados_transito_grupo_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."produtos_combinados_transito_grupo"
    ADD CONSTRAINT "produtos_combinados_transito_grupo_pk" PRIMARY KEY ("id_grupo", "id_produto_combinado");


--
-- PostgreSQL database dump complete
--

\unrestrict NXATeTmjXSBvUnnd1YJReruC8XIKHBgytEgS4eoAv4Ujn9ppOg7d9skncPDrOLy

