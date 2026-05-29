--
-- PostgreSQL database dump
--

\restrict imKxSF7un7oKjw2wzhVSJ19DxscD97Zo3n9oDmlFe9abHTxsa3KJcPKrjImkVQQ

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
-- Name: pedidos_compras_itens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."pedidos_compras_itens" (
    "idpedido" bigint NOT NULL,
    "idproduto" character varying(25) DEFAULT ''::character varying NOT NULL,
    "qtde_pedido" numeric(12,4) NOT NULL,
    "preco_custo" numeric(12,4) NOT NULL,
    "total" numeric(12,4) NOT NULL,
    "log" character varying(25) DEFAULT ''::character varying NOT NULL,
    "log_data" timestamp without time zone,
    "sugerido" numeric(12,4),
    "tipo_compra" character varying(3),
    "oc_num" bigint,
    "oc_data" "date",
    "oc_qtde" numeric(12,4),
    "preco_custo_base" numeric(12,4),
    "pedido_compra_fracionada_id" bigint,
    "item" integer,
    "exportado" character varying(1) DEFAULT 'N'::character varying NOT NULL
);


--
-- Name: pedidos_compras_itens pedido_itens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."pedidos_compras_itens"
    ADD CONSTRAINT "pedido_itens_pkey" PRIMARY KEY ("idpedido", "idproduto");


--
-- Name: pedidos_compras_itens_idproduto_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "pedidos_compras_itens_idproduto_idx" ON "public"."pedidos_compras_itens" USING "btree" ("idproduto");


--
-- Name: pedidos_compras_itens pedidos_compras_itens_trg; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER "pedidos_compras_itens_trg" BEFORE INSERT ON "public"."pedidos_compras_itens" FOR EACH ROW EXECUTE FUNCTION "public"."trigger_seq_itens_pedido_compra"();


--
-- Name: pedidos_compras_itens trigger_log_pedidos_compras_itens; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER "trigger_log_pedidos_compras_itens" AFTER INSERT OR DELETE OR UPDATE ON "public"."pedidos_compras_itens" FOR EACH ROW EXECUTE FUNCTION "public"."trigger_log_pedidos_compras_itens"();


--
-- Name: pedidos_compras_itens fk_pedidos; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."pedidos_compras_itens"
    ADD CONSTRAINT "fk_pedidos" FOREIGN KEY ("idpedido") REFERENCES "public"."pedidos_compras"("idpedido");


--
-- PostgreSQL database dump complete
--

\unrestrict imKxSF7un7oKjw2wzhVSJ19DxscD97Zo3n9oDmlFe9abHTxsa3KJcPKrjImkVQQ

