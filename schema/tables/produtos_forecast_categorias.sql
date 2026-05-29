--
-- PostgreSQL database dump
--

\restrict VeL9kAWeCyVmY6jbqwGLdtKjweaeasM4mCyKkbel8jLASpMzlHc5KhqkHv7aRVU

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
-- Name: produtos_forecast_categorias; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."produtos_forecast_categorias" (
    "id_grupo" bigint NOT NULL,
    "iddepartamento" character varying(25) NOT NULL,
    "idsecao" character varying(25) NOT NULL,
    "idcategoria" character varying(25) NOT NULL,
    "descricao_categoria" character varying(60),
    "consumo_medio_mensal" numeric,
    "desvio_padrao_consumo" numeric,
    "tempo_medio_ressuprimento" numeric DEFAULT 35,
    "tempo_ressuprimento" numeric DEFAULT 1.17,
    "estoque" numeric,
    "ponto_pedido" numeric,
    "estoque_maximo" numeric,
    "saldo_futuro" numeric,
    "processamento" timestamp without time zone,
    "lote_minimo" numeric DEFAULT 1,
    "lote_compras" numeric,
    "nivel_servico" character varying,
    "flag" character varying(1)
);


--
-- Name: produtos_forecast_categorias produtos_forecast_categorias_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."produtos_forecast_categorias"
    ADD CONSTRAINT "produtos_forecast_categorias_pk" PRIMARY KEY ("id_grupo", "idcategoria");


--
-- PostgreSQL database dump complete
--

\unrestrict VeL9kAWeCyVmY6jbqwGLdtKjweaeasM4mCyKkbel8jLASpMzlHc5KhqkHv7aRVU

