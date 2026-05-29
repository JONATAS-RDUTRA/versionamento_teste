--
-- PostgreSQL database dump
--

\restrict DgVDSeRxNIDjDevIe4MsxAmnheAhaVmjHfvSGgVT1sMd6BfWfC9dTmHQR9u5vb3

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
-- Name: analise_balanceamento; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."analise_balanceamento" (
    "idproduto" character varying(25),
    "data" "date",
    "ano" integer,
    "mes" integer,
    "trimestre" integer,
    "cod_trimestre" integer,
    "entradas" numeric(12,4),
    "saidas" numeric(12,4),
    "estoque" numeric(12,4),
    "media_trimestre" numeric(12,4),
    "media_diaria_trimestre" numeric(12,4),
    "desvio_padrao_trimestre" numeric(12,4),
    "media_trimestre_ant" numeric(12,4),
    "media_diaria_trimestre_ant" numeric(12,4),
    "desvio_padrao_trimestre_ant" numeric(12,4),
    "media_anual_corrida" numeric(12,4),
    "media_diaria_anual" numeric(12,4),
    "desvio_padrao_anual" numeric(12,4),
    "processamento" timestamp without time zone,
    "coeficiente_variacao" numeric(12,4),
    "prismas" character varying,
    "valor_unitario" double precision,
    "custo_unitario" numeric(12,4),
    "fator_conversao" numeric(12,6),
    "eseg" numeric,
    "ppd" numeric,
    "emax" numeric,
    "cmm" numeric,
    "susgestao" numeric,
    "total_real" numeric(12,4) DEFAULT 0 NOT NULL,
    "total_projetado" numeric(12,4) DEFAULT 0 NOT NULL
);


--
-- PostgreSQL database dump complete
--

\unrestrict DgVDSeRxNIDjDevIe4MsxAmnheAhaVmjHfvSGgVT1sMd6BfWfC9dTmHQR9u5vb3

