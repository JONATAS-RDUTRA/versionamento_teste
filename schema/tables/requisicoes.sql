--
-- PostgreSQL database dump
--

\restrict 9lmePPEGfE5ED538wnHHcAPAkVbefKfCwTh3SzKtsaxs878WRLS1ZSbgqHZXsPY

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
-- Name: requisicoes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."requisicoes" (
    "id_solicitacao" double precision DEFAULT 0 NOT NULL,
    "data_solicitacao" "date",
    "data_liberacao" "date",
    "item" double precision DEFAULT 0 NOT NULL,
    "idproduto" character varying(25) DEFAULT 0 NOT NULL,
    "descricao_produto" character varying(255),
    "qtde" double precision,
    "unidade_medida" character varying(255),
    "ordem_compra" double precision,
    "data_conferencia" timestamp without time zone,
    "idfilial" integer,
    "iddeposito" integer,
    "data_previsao" "date",
    "data_faturamento" "date",
    "data_entrega" "date",
    "qtde_entregue" double precision DEFAULT 0 NOT NULL,
    "qtde_pendente" double precision DEFAULT 0 NOT NULL,
    "pcompra" double precision DEFAULT 0,
    "pcompraant" double precision DEFAULT 0,
    "pliquido" double precision DEFAULT 0,
    "fator_conversao" numeric(12,4),
    "qtde_faturada" double precision,
    "entrada_bonificada" character varying(1) DEFAULT 'N'::character varying NOT NULL,
    "flag" character varying(1),
    "moeda" character varying(2) DEFAULT 'R'::character varying NOT NULL,
    "idfornecedor" integer DEFAULT 0 NOT NULL,
    "qtde_solicitada_original" double precision,
    "pcompra_total" double precision DEFAULT 0,
    "idmarca" character varying(25),
    "compra_programada" character varying(1) DEFAULT 'N'::character varying NOT NULL
);


--
-- Name: COLUMN "requisicoes"."id_solicitacao"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."requisicoes"."id_solicitacao" IS 'Número do pedido - Winthor';


--
-- Name: COLUMN "requisicoes"."data_solicitacao"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."requisicoes"."data_solicitacao" IS 'Data do pedido';


--
-- Name: COLUMN "requisicoes"."idproduto"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."requisicoes"."idproduto" IS 'Produto';


--
-- Name: COLUMN "requisicoes"."descricao_produto"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."requisicoes"."descricao_produto" IS 'Nome do produto';


--
-- Name: COLUMN "requisicoes"."unidade_medida"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."requisicoes"."unidade_medida" IS 'Embalagem';


--
-- Name: COLUMN "requisicoes"."ordem_compra"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."requisicoes"."ordem_compra" IS 'Número do pedido';


--
-- Name: COLUMN "requisicoes"."idfilial"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."requisicoes"."idfilial" IS 'Filial do Pedido';


--
-- Name: COLUMN "requisicoes"."data_previsao"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."requisicoes"."data_previsao" IS 'Previsão de Faturamento/Entrada';


--
-- Name: COLUMN "requisicoes"."data_faturamento"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."requisicoes"."data_faturamento" IS 'Data de faturamento';


--
-- Name: COLUMN "requisicoes"."data_entrega"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."requisicoes"."data_entrega" IS 'Data da entrada';


--
-- Name: COLUMN "requisicoes"."qtde_entregue"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."requisicoes"."qtde_entregue" IS 'Quantidade entregue';


--
-- Name: COLUMN "requisicoes"."qtde_pendente"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."requisicoes"."qtde_pendente" IS 'Quantidade pendente para entregar';


--
-- Name: COLUMN "requisicoes"."pcompra"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."requisicoes"."pcompra" IS 'Preço do pedido';


--
-- Name: COLUMN "requisicoes"."pcompraant"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."requisicoes"."pcompraant" IS 'Preço de compra anterior';


--
-- Name: COLUMN "requisicoes"."entrada_bonificada"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."requisicoes"."entrada_bonificada" IS 'Quando for entrada bonificada';


--
-- Name: COLUMN "requisicoes"."moeda"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."requisicoes"."moeda" IS 'R - Real, D - Dolar, UE - Euro, ST - Sem Tabela';


--
-- Name: COLUMN "requisicoes"."idfornecedor"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."requisicoes"."idfornecedor" IS 'Fornecedor do Pedido';


--
-- Name: COLUMN "requisicoes"."pcompra_total"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."requisicoes"."pcompra_total" IS 'Preço total do pedido - Winthor';


--
-- Name: requisicoes requisicoes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."requisicoes"
    ADD CONSTRAINT "requisicoes_pkey" PRIMARY KEY ("id_solicitacao", "idproduto", "item");


--
-- Name: requisicoes_index01; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "requisicoes_index01" ON "public"."requisicoes" USING "btree" ("ordem_compra", "idproduto");


--
-- Name: requisicoes_index02; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "requisicoes_index02" ON "public"."requisicoes" USING "btree" ("idproduto", "data_solicitacao");


--
-- Name: requisicoes_index03; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "requisicoes_index03" ON "public"."requisicoes" USING "btree" ("idproduto", "data_solicitacao", "data_entrega");


--
-- Name: requisicoes requisicoes_trg; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER "requisicoes_trg" BEFORE INSERT OR UPDATE ON "public"."requisicoes" FOR EACH ROW EXECUTE FUNCTION "public"."trigger_requisicao_pendentes"();


--
-- PostgreSQL database dump complete
--

\unrestrict 9lmePPEGfE5ED538wnHHcAPAkVbefKfCwTh3SzKtsaxs878WRLS1ZSbgqHZXsPY

