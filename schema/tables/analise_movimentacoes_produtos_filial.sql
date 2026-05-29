--
-- PostgreSQL database dump
--

\restrict NeF3fTKCmmUiksb1hSoDnSdY53zQl5bFRWNx7MtApvrFIv5ubT9HmbQkmHH5QXo

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
-- Name: analise_movimentacoes_produtos_filial; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."analise_movimentacoes_produtos_filial" (
    "ano" integer NOT NULL,
    "mes" integer NOT NULL,
    "filial" integer NOT NULL,
    "idproduto" character varying NOT NULL,
    "qtde_saidas" numeric,
    "valor_saidas" numeric,
    "qtde_compras" numeric,
    "valor_compras" numeric,
    "qtde_entradas" numeric,
    "valor_entradas" numeric,
    "estoque_medio_filial" numeric
);


--
-- Name: analise_movimentacoes_produtos_filial analise_movimentacoes_produtos_filial_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."analise_movimentacoes_produtos_filial"
    ADD CONSTRAINT "analise_movimentacoes_produtos_filial_pkey" PRIMARY KEY ("ano", "mes", "filial", "idproduto");


--
-- Name: analise_movimentacoes_produtos_filial_filial_idproduto; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "analise_movimentacoes_produtos_filial_filial_idproduto" ON "public"."analise_movimentacoes_produtos_filial" USING "btree" ("filial", "idproduto");


--
-- PostgreSQL database dump complete
--

\unrestrict NeF3fTKCmmUiksb1hSoDnSdY53zQl5bFRWNx7MtApvrFIv5ubT9HmbQkmHH5QXo

