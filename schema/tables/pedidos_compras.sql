--
-- PostgreSQL database dump
--

\restrict hPclMz9MZjlJIy8RwZtUFrIn63iFMhhNCOoJUac48hHekIyZGpx9jheNAqI2PYp

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
-- Name: pedidos_compras; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."pedidos_compras" (
    "idpedido" integer NOT NULL,
    "data_emissao" "date",
    "idcomprador" bigint NOT NULL,
    "status" character varying(2) DEFAULT 'AB'::character varying NOT NULL,
    "data_final" "date",
    "idfornecedor" integer DEFAULT 0 NOT NULL,
    "inicio_cotacao" "date",
    "grupo" integer DEFAULT 0 NOT NULL,
    "filial_compra" integer DEFAULT 0 NOT NULL,
    "emb_master" character varying DEFAULT 'N'::character varying NOT NULL,
    "idfornecedor_pedido" integer DEFAULT 0,
    "pedido_cli" character varying(30) DEFAULT '0'::character varying NOT NULL,
    "cond_pagamento" bigint,
    "data_entrega" "date",
    "seq_itens" integer,
    "grupo_analise_fornecedor" boolean DEFAULT false,
    "filial_pedido_exportado" integer,
    "id_capa_lista" integer,
    "observacao" "text",
    "pedido_produtos_combinados" boolean DEFAULT false NOT NULL,
    "iddepartamento" integer DEFAULT 0 NOT NULL,
    "idsecao" integer DEFAULT 0 NOT NULL
);


--
-- Name: pedidos_compras_idpedido_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."pedidos_compras_idpedido_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pedidos_compras_idpedido_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."pedidos_compras_idpedido_seq" OWNED BY "public"."pedidos_compras"."idpedido";


--
-- Name: pedidos_compras idpedido; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."pedidos_compras" ALTER COLUMN "idpedido" SET DEFAULT "nextval"('"public"."pedidos_compras_idpedido_seq"'::"regclass");


--
-- Name: pedidos_compras pedido_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."pedidos_compras"
    ADD CONSTRAINT "pedido_pkey" PRIMARY KEY ("idpedido");


--
-- Name: pedidos_compras fk_pedidos_usuario; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."pedidos_compras"
    ADD CONSTRAINT "fk_pedidos_usuario" FOREIGN KEY ("idcomprador") REFERENCES "public"."users"("id");


--
-- PostgreSQL database dump complete
--

\unrestrict hPclMz9MZjlJIy8RwZtUFrIn63iFMhhNCOoJUac48hHekIyZGpx9jheNAqI2PYp

