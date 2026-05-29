--
-- PostgreSQL database dump
--

\restrict QjgF0X9XeDB5zpqng9gRWJEvvKkRSwRObnkykfK5MFy2kf9uaE67xFoxtCYIaIn

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
-- Name: hist_analise_compras; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."hist_analise_compras" (
    "filial" bigint DEFAULT 0 NOT NULL,
    "idproduto" character varying(25) NOT NULL,
    "data_solicitacao" "date" NOT NULL,
    "arvore_decisao" character varying(4) NOT NULL,
    "estoque_seguranca" numeric(12,4) DEFAULT 0 NOT NULL,
    "ponto_pedido" numeric(12,4) DEFAULT 0 NOT NULL,
    "estoque_maximo" numeric(12,4) DEFAULT 0 NOT NULL,
    "consumo_medio" numeric(12,4) DEFAULT 0 NOT NULL,
    "sugestao" numeric(12,4) DEFAULT 0 NOT NULL,
    "processamento" timestamp without time zone DEFAULT "now"() NOT NULL,
    "estoque" numeric(12,4) DEFAULT 0 NOT NULL
);


--
-- Name: hist_analise_compras pk_hist_analise_comp; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."hist_analise_compras"
    ADD CONSTRAINT "pk_hist_analise_comp" PRIMARY KEY ("filial", "idproduto", "data_solicitacao");


--
-- Name: hist_analise_comp_index00; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "hist_analise_comp_index00" ON "public"."hist_analise_compras" USING "btree" ("idproduto", "data_solicitacao");


--
-- PostgreSQL database dump complete
--

\unrestrict QjgF0X9XeDB5zpqng9gRWJEvvKkRSwRObnkykfK5MFy2kf9uaE67xFoxtCYIaIn

