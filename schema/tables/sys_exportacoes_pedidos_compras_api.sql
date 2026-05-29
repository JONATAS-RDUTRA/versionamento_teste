--
-- PostgreSQL database dump
--

\restrict 5rlxcUpf1cxELavsXEuIJJJRFfX5FvxNve38f8LjHOevdorMlA4snnHZhS10iDY

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
-- Name: sys_exportacoes_pedidos_compras_api; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."sys_exportacoes_pedidos_compras_api" (
    "id" integer NOT NULL,
    "idpedido" integer NOT NULL,
    "filial" bigint NOT NULL,
    "idcomprador" bigint NOT NULL,
    "idfornecedor" bigint NOT NULL,
    "id_usuario" bigint NOT NULL,
    "created_at" character varying(30) DEFAULT "now"() NOT NULL,
    "updated_at" character varying(30) DEFAULT "now"() NOT NULL,
    "condicao_pagamento" character varying(25)
);


--
-- Name: sys_exportacoes_pedidos_compras_api_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."sys_exportacoes_pedidos_compras_api_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sys_exportacoes_pedidos_compras_api_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."sys_exportacoes_pedidos_compras_api_id_seq" OWNED BY "public"."sys_exportacoes_pedidos_compras_api"."id";


--
-- Name: sys_exportacoes_pedidos_compras_api id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."sys_exportacoes_pedidos_compras_api" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."sys_exportacoes_pedidos_compras_api_id_seq"'::"regclass");


--
-- Name: sys_exportacoes_pedidos_compras_api sys_exportacoes_pedidos_compras_api_idpedido_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."sys_exportacoes_pedidos_compras_api"
    ADD CONSTRAINT "sys_exportacoes_pedidos_compras_api_idpedido_key" UNIQUE ("idpedido");


--
-- Name: sys_exportacoes_pedidos_compras_api sys_exportacoes_pedidos_compras_api_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."sys_exportacoes_pedidos_compras_api"
    ADD CONSTRAINT "sys_exportacoes_pedidos_compras_api_pkey" PRIMARY KEY ("id");


--
-- Name: sys_exportacoes_pedidos_compras_api_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "sys_exportacoes_pedidos_compras_api_idx" ON "public"."sys_exportacoes_pedidos_compras_api" USING "btree" ("idpedido");


--
-- PostgreSQL database dump complete
--

\unrestrict 5rlxcUpf1cxELavsXEuIJJJRFfX5FvxNve38f8LjHOevdorMlA4snnHZhS10iDY

