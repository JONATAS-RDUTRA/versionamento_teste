--
-- PostgreSQL database dump
--

\restrict QtDSvRRV4QIurvDK6ZmaNRf75dLbnGr6zsFPRdnsPfr7UnZg5kTTApPy2oHNo42

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
-- Name: temp_analise_balanceamento; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."temp_analise_balanceamento" (
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
    "arvore_decisao" character varying(4),
    "descricao_produto" character varying(60),
    "custo_unitario" numeric(12,4),
    "valor_unitario" double precision,
    "idcomprador" bigint,
    "comprador" character varying(100),
    "idfornecedor" bigint,
    "fornecedor" character varying(100),
    "consumo_medio" numeric(12,4),
    "estoque_seguranca" numeric(12,4),
    "estoque_maximo" numeric(12,4),
    "ponto_pedido" numeric(12,4),
    "sugestao" numeric(12,4),
    "total_projetado" numeric,
    "total_real" numeric,
    "total_diferenca_proj_real" numeric,
    "idfamilia_produto" integer,
    "descricao_familia_produto" character varying(60)
);


--
-- PostgreSQL database dump complete
--

\unrestrict QtDSvRRV4QIurvDK6ZmaNRf75dLbnGr6zsFPRdnsPfr7UnZg5kTTApPy2oHNo42

