--
-- PostgreSQL database dump
--

\restrict ltWKTyWPL64eA8cdLkJGK6maSJT7rsXPcJADaw2HccaRWsjnNSdRme5fRI1iZ96

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
-- Name: analise_status_mensal_filial_analitica; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."analise_status_mensal_filial_analitica" (
    "id_grupo" bigint NOT NULL,
    "ano" integer NOT NULL,
    "mes" integer NOT NULL,
    "descricao_produto" character varying(60),
    "custo_unitario" numeric,
    "valor_unitario" numeric,
    "estoque" numeric(12,4),
    "filial" bigint NOT NULL,
    "idproduto" character varying(25) NOT NULL,
    "data_solicitacao" "date",
    "arvore_decisao" character varying(4),
    "estoque_seguranca" numeric(12,4),
    "ponto_pedido" numeric(12,4),
    "estoque_maximo" numeric(12,4),
    "estoque_maximo_elast" numeric,
    "consumo_medio" numeric(12,4),
    "sugestao" numeric(12,4),
    "processamento" timestamp without time zone,
    "compra_transito_grupo" numeric,
    "necessidade" numeric,
    "tempo_medio_apanhe" numeric(12,4),
    "tempo_vida_produto" integer,
    "status" character varying(2),
    "revenda" character varying(1)
)
WITH ("autovacuum_vacuum_scale_factor"='0.41936');


--
-- Name: analise_status_mensal_filial_analitica analise_status_mensal_filial_analitica_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."analise_status_mensal_filial_analitica"
    ADD CONSTRAINT "analise_status_mensal_filial_analitica_pk" PRIMARY KEY ("id_grupo", "filial", "ano", "mes", "idproduto");


--
-- PostgreSQL database dump complete
--

\unrestrict ltWKTyWPL64eA8cdLkJGK6maSJT7rsXPcJADaw2HccaRWsjnNSdRme5fRI1iZ96

