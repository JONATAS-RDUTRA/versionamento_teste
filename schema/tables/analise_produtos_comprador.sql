--
-- PostgreSQL database dump
--

\restrict 0nZSvIdY5ABq94pBCla8cnSmsWREN63Il6p4NdlUAbQA2CHB5K43IThM5dwbLmH

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
-- Name: analise_produtos_comprador; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."analise_produtos_comprador" (
    "data_referencia" "date",
    "ano" integer,
    "mes" integer,
    "id_grupo" bigint,
    "filial" integer,
    "idfornecedor" numeric,
    "idcomprador" numeric,
    "qtde_total_produto" numeric,
    "qtde_produtos_excesso" numeric,
    "valor_excesso" numeric,
    "excesso_toleravel" numeric,
    "diferenca_dinheiro" numeric,
    "excesso_realizado" numeric,
    "qtde_produtos_adequado" numeric,
    "qtde_produtos_a_comprar" numeric,
    "qtde_produtos_transito" numeric,
    "qtde_produtos_zerados" numeric,
    "compra_prevista" numeric,
    "total_estoque_periodo" numeric
);


--
-- PostgreSQL database dump complete
--

\unrestrict 0nZSvIdY5ABq94pBCla8cnSmsWREN63Il6p4NdlUAbQA2CHB5K43IThM5dwbLmH

