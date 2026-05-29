--
-- PostgreSQL database dump
--

\restrict f5arYxWbeSFIxLcFdz3GU20Q3jBCgqe97h6T2UyzeaUoA0cEyZkJn4lmNMpJMbl

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
-- Name: pedidos_compras_produto_fracionado; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."pedidos_compras_produto_fracionado" (
    "id" integer NOT NULL,
    "idpedido" bigint NOT NULL,
    "idproduto" character varying(25) NOT NULL,
    "qtde_solicitada" numeric(12,4) NOT NULL,
    "saldo_inicial" numeric(12,4) NOT NULL,
    "saldo_futuro" numeric(12,4) NOT NULL,
    "desvio_padrao" numeric(12,4),
    "consumo_medio_mensal" numeric(12,4) NOT NULL,
    "estoque_seguranca" numeric(12,4) NOT NULL,
    "ponto_pedido" numeric(12,4) NOT NULL,
    "estoque_maximo" numeric(12,4) NOT NULL,
    "cob" numeric(12,4) NOT NULL,
    "data_emissao" timestamp without time zone,
    "data_chegada" timestamp without time zone,
    "created_at" timestamp without time zone,
    "updated_at" timestamp without time zone,
    "deleted_at" timestamp without time zone,
    "parcela" character varying(3),
    "diautil" character varying(30)
);


--
-- Name: pedidos_compras_fracionada_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."pedidos_compras_fracionada_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pedidos_compras_fracionada_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."pedidos_compras_fracionada_id_seq" OWNED BY "public"."pedidos_compras_produto_fracionado"."id";


--
-- Name: pedidos_compras_produto_fracionado id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."pedidos_compras_produto_fracionado" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."pedidos_compras_fracionada_id_seq"'::"regclass");


--
-- Name: pedidos_compras_produto_fracionado pc_fracionada_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."pedidos_compras_produto_fracionado"
    ADD CONSTRAINT "pc_fracionada_pk" PRIMARY KEY ("id");


--
-- Name: pedidos_compras_fracionada_idpedido_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "pedidos_compras_fracionada_idpedido_idx" ON "public"."pedidos_compras_produto_fracionado" USING "btree" ("idpedido", "idproduto");


--
-- PostgreSQL database dump complete
--

\unrestrict f5arYxWbeSFIxLcFdz3GU20Q3jBCgqe97h6T2UyzeaUoA0cEyZkJn4lmNMpJMbl

