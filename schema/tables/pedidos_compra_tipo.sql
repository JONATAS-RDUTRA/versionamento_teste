--
-- PostgreSQL database dump
--

\restrict N17mFcL6bqSK0eRaW3kWHWXBHf2veNi2XE9uRoE1Rv9J1lgbNf27QgwwJteFNLG

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
-- Name: pedidos_compra_tipo; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."pedidos_compra_tipo" (
    "id" integer NOT NULL,
    "grupo" integer NOT NULL,
    "filial" integer NOT NULL,
    "status" character varying(2) DEFAULT 'AB'::character varying NOT NULL,
    "embalagem_master" boolean DEFAULT false NOT NULL,
    "id_tipo" character(1) NOT NULL,
    "id_pedido_exportado" character varying(15),
    "data_cotacao" character varying(30),
    "data_fechamento" character varying(30),
    "created_at" character varying(30),
    "updated_at" character varying(30),
    "deleted_at" character varying(30),
    "usuario" integer
);


--
-- Name: pedidos_compra_tipo_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."pedidos_compra_tipo_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pedidos_compra_tipo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."pedidos_compra_tipo_id_seq" OWNED BY "public"."pedidos_compra_tipo"."id";


--
-- Name: pedidos_compra_tipo id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."pedidos_compra_tipo" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."pedidos_compra_tipo_id_seq"'::"regclass");


--
-- Name: pedidos_compra_tipo pk_pedidos_compra_tipo; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."pedidos_compra_tipo"
    ADD CONSTRAINT "pk_pedidos_compra_tipo" PRIMARY KEY ("id");


--
-- Name: pedidos_compra_tipo fk_tipos_pedidos_compras; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."pedidos_compra_tipo"
    ADD CONSTRAINT "fk_tipos_pedidos_compras" FOREIGN KEY ("id_tipo") REFERENCES "public"."tipos_pedidos_compras"("id");


--
-- PostgreSQL database dump complete
--

\unrestrict N17mFcL6bqSK0eRaW3kWHWXBHf2veNi2XE9uRoE1Rv9J1lgbNf27QgwwJteFNLG

