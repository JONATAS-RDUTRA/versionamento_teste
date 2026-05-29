--
-- PostgreSQL database dump
--

\restrict jwBeBOa7ZmXuLpBOHmzXPFnNgWbOni3aHNvn1QkFYaD3lUb6bltjHn8KBt3WyYU

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
-- Name: analise_rupturas_produtos_filial; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."analise_rupturas_produtos_filial" (
    "ano" integer NOT NULL,
    "mes" integer NOT NULL,
    "filial" integer NOT NULL,
    "idproduto" character varying NOT NULL,
    "qtde_dias_ruptura" bigint,
    "venda_diaria_calc" numeric,
    "valor_ruptura" numeric,
    "tipo_ruptura" "text",
    "nivel_servico" "text",
    "data_ruptura" "date",
    "media_mensal" numeric,
    "data_ultima_compra" "date",
    "data_ultima_venda" "date",
    "produto_eh_combinacao" boolean,
    "flag" character varying(1)
);


--
-- PostgreSQL database dump complete
--

\unrestrict jwBeBOa7ZmXuLpBOHmzXPFnNgWbOni3aHNvn1QkFYaD3lUb6bltjHn8KBt3WyYU

