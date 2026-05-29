--
-- PostgreSQL database dump
--

\restrict mOkjzgJ6btrw6a6j3nN9PVCNcb8ALQeE2dBskvtqChMFlfegGfFeG4j3VKj0Ew3

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
-- Name: produtos_pedidos_compra_tipo; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."produtos_pedidos_compra_tipo" (
    "id" bigint NOT NULL,
    "id_pedido" bigint NOT NULL,
    "idproduto" character varying(25) NOT NULL,
    "sequencia" integer NOT NULL,
    "quantidade" numeric(12,4) NOT NULL,
    "sugerido" numeric(12,4) NOT NULL,
    "preco_custo" numeric(12,4) NOT NULL,
    "preco_custo_base" numeric(12,4) NOT NULL,
    "tipo_compra" character varying(3),
    "exportado" character varying(1) DEFAULT 'N'::character varying NOT NULL,
    "created_at" character varying(30),
    "updated_at" character varying(30)
);


--
-- Name: produtos_pedidos_compra_tipo_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."produtos_pedidos_compra_tipo_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: produtos_pedidos_compra_tipo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."produtos_pedidos_compra_tipo_id_seq" OWNED BY "public"."produtos_pedidos_compra_tipo"."id";


--
-- Name: produtos_pedidos_compra_tipo id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."produtos_pedidos_compra_tipo" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."produtos_pedidos_compra_tipo_id_seq"'::"regclass");


--
-- Name: produtos_pedidos_compra_tipo pk_produtos_pedidos_compra; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."produtos_pedidos_compra_tipo"
    ADD CONSTRAINT "pk_produtos_pedidos_compra" PRIMARY KEY ("id");


--
-- Name: produtos_pedidos_compra_tipo_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "produtos_pedidos_compra_tipo_index" ON "public"."produtos_pedidos_compra_tipo" USING "btree" ("id_pedido", "idproduto");


--
-- Name: produtos_pedidos_compra_tipo fk_pedidos_compra_tipo; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."produtos_pedidos_compra_tipo"
    ADD CONSTRAINT "fk_pedidos_compra_tipo" FOREIGN KEY ("id_pedido") REFERENCES "public"."pedidos_compra_tipo"("id");


--
-- PostgreSQL database dump complete
--

\unrestrict mOkjzgJ6btrw6a6j3nN9PVCNcb8ALQeE2dBskvtqChMFlfegGfFeG4j3VKj0Ew3

