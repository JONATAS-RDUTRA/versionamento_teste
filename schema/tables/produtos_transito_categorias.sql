--
-- PostgreSQL database dump
--

\restrict EaFAJJNfVBqUwAdhWZvFC5UURvvc90vB3NWZgN6Pwjc6KkgBvKZWo8R88yDfPzY

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
-- Name: produtos_transito_categorias; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."produtos_transito_categorias" (
    "id_grupo" bigint,
    "iddepartamento" character varying(25),
    "idsecao" character varying(25),
    "idcategoria" character varying(25),
    "tempo_medio_ressuprimento" numeric,
    "descricao_categoria" character varying(60),
    "consumo_medio_mensal" numeric,
    "desvio_padrao_consumo" numeric,
    "estoque" numeric,
    "ponto_pedido" numeric,
    "estoque_maximo" numeric,
    "compra_transito" numeric,
    "lote_compras" numeric,
    "lote_minimo" numeric,
    "nivel_servico" character varying,
    "status" "text",
    "flag" "text",
    "peso_compras" numeric,
    "processamento" timestamp with time zone
);


--
-- PostgreSQL database dump complete
--

\unrestrict EaFAJJNfVBqUwAdhWZvFC5UURvvc90vB3NWZgN6Pwjc6KkgBvKZWo8R88yDfPzY

