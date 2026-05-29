--
-- PostgreSQL database dump
--

\restrict 0Xdb97xwfXLPXQpQGuZKxQJsKuE6udiZWx5WozNLen2VfTWdmqy1sqte4rdhYJ9

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
-- Name: solicitacoes_compras; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."solicitacoes_compras" (
    "idsolicitacao_compra" integer DEFAULT "nextval"('"public"."solicitacoes_compras_idsolicitacao_compra_seq"'::"regclass") NOT NULL,
    "data_solicitacao" "date",
    "data_aprovacao" "date",
    "ordem" integer,
    "quantidade_solicitada" integer,
    "numero_pedido_compra" character varying(45),
    "data_pedido_compra" "date",
    "id_solicitante" integer NOT NULL,
    "idtipo_solicitacao" integer NOT NULL,
    "cruzamento_matricial" integer
);


--
-- Name: solicitacoes_compras solicitacoes_compras_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."solicitacoes_compras"
    ADD CONSTRAINT "solicitacoes_compras_pkey" PRIMARY KEY ("idsolicitacao_compra");


--
-- Name: fk_solicitacoes_compras_colaboradores1_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "fk_solicitacoes_compras_colaboradores1_idx" ON "public"."solicitacoes_compras" USING "btree" ("id_solicitante");


--
-- Name: fk_solicitacoes_compras_tipo_solicitacoes1_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "fk_solicitacoes_compras_tipo_solicitacoes1_idx" ON "public"."solicitacoes_compras" USING "btree" ("idtipo_solicitacao");


--
-- Name: solicitacoes_compras fk_solicitacoes_compras_colaboradores1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."solicitacoes_compras"
    ADD CONSTRAINT "fk_solicitacoes_compras_colaboradores1" FOREIGN KEY ("id_solicitante") REFERENCES "public"."colaboradores"("idcolaborador");


--
-- Name: solicitacoes_compras fk_solicitacoes_compras_tipo_solicitacoes1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."solicitacoes_compras"
    ADD CONSTRAINT "fk_solicitacoes_compras_tipo_solicitacoes1" FOREIGN KEY ("idtipo_solicitacao") REFERENCES "public"."tipo_solicitacoes"("idtipo_solicitacao");


--
-- PostgreSQL database dump complete
--

\unrestrict 0Xdb97xwfXLPXQpQGuZKxQJsKuE6udiZWx5WozNLen2VfTWdmqy1sqte4rdhYJ9

