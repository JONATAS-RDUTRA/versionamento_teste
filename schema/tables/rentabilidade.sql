--
-- PostgreSQL database dump
--

\restrict nv5jOkIpOfqExhFpNIlgOyP0DrmbDOMY8iNQkOjdKYi47SBsw313exRXOHEf8GL

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
-- Name: rentabilidade; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."rentabilidade" (
    "filial" bigint NOT NULL,
    "idproduto" character varying(25) NOT NULL,
    "idfornecedor" bigint NOT NULL,
    "amostra" bigint NOT NULL,
    "total_venda" numeric(12,2),
    "total_venda_custo" numeric(12,2),
    "lucro_bruto" numeric(12,2),
    "valor_medio" numeric(12,2),
    "qtde_itens" numeric(12,4),
    "markup" numeric(12,2),
    "curva_r" character varying(2),
    "perc_volume" numeric(12,4),
    "perc_vendas" numeric(12,4),
    "perc_lucro" numeric(12,4),
    "status" character varying(1),
    "processamento" timestamp without time zone
);


--
-- Name: rentabilidade rentabilidade_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."rentabilidade"
    ADD CONSTRAINT "rentabilidade_pk" PRIMARY KEY ("filial", "idproduto");


--
-- Name: rentabilidade_idfornecedor_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "rentabilidade_idfornecedor_idx" ON "public"."rentabilidade" USING "btree" ("idfornecedor");


--
-- Name: rentabilidade_status_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "rentabilidade_status_idx" ON "public"."rentabilidade" USING "btree" ("status");


--
-- PostgreSQL database dump complete
--

\unrestrict nv5jOkIpOfqExhFpNIlgOyP0DrmbDOMY8iNQkOjdKYi47SBsw313exRXOHEf8GL

