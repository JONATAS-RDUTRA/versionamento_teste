--
-- PostgreSQL database dump
--

\restrict ZdDsdgbkakxwMwwfOSPgCcGHj8nXWhSDDd3dAOVPHJc1D8dh3OBSOdkdGq7G2xU

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
-- Name: log_pedidos_compras_itens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."log_pedidos_compras_itens" (
    "id" integer NOT NULL,
    "idpedido" integer NOT NULL,
    "idproduto" character varying(25) NOT NULL,
    "estoque" numeric(12,4) NOT NULL,
    "eseg" numeric(12,4) NOT NULL,
    "pp" numeric(12,4) NOT NULL,
    "emax" numeric(12,4) NOT NULL,
    "cmm" numeric(12,4) NOT NULL,
    "tr" numeric(12,4) NOT NULL,
    "sugerido" numeric(12,4) NOT NULL,
    "qtde_pedido" numeric(12,4) NOT NULL,
    "tipo_compra" character varying(2),
    "created_at" character varying(30) NOT NULL,
    "updated_at" character varying(30) NOT NULL,
    "deleted_at" character varying(30)
);


--
-- Name: log_pedidos_compras_itens_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."log_pedidos_compras_itens_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: log_pedidos_compras_itens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."log_pedidos_compras_itens_id_seq" OWNED BY "public"."log_pedidos_compras_itens"."id";


--
-- Name: log_pedidos_compras_itens id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."log_pedidos_compras_itens" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."log_pedidos_compras_itens_id_seq"'::"regclass");


--
-- Name: log_pedidos_compras_itens log_pedidos_compras_itens_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."log_pedidos_compras_itens"
    ADD CONSTRAINT "log_pedidos_compras_itens_pk" PRIMARY KEY ("id");


--
-- PostgreSQL database dump complete
--

\unrestrict ZdDsdgbkakxwMwwfOSPgCcGHj8nXWhSDDd3dAOVPHJc1D8dh3OBSOdkdGq7G2xU

