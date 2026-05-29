--
-- PostgreSQL database dump
--

\restrict yaf3inmqRDuCg5IKBi09RIrOq1zA3IIvCnRtmtQxLdOcwblhnccx9xU2rl8F20S

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
-- Name: cotacao_fornecedores_participantes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."cotacao_fornecedores_participantes" (
    "cotacao_fornecedores_participantes_id" integer NOT NULL,
    "identificador_geral" "uuid" NOT NULL,
    "cnpj" character varying(20) NOT NULL,
    "razao_social" character varying(100) NOT NULL,
    "cotacao_produtos_id" integer NOT NULL,
    "qtd_ofertada" numeric(12,4),
    "um_ofertada" character varying(100),
    "preco_unitario" numeric(12,4),
    "prazo_entrega" integer,
    "condicao_pagamento" character varying(100),
    "atendo_produto" boolean DEFAULT false NOT NULL,
    "created_at" timestamp(0) without time zone,
    "updated_at" timestamp(0) without time zone,
    "cotacao_participacao_fornecedor_id" integer,
    "ganhador" boolean DEFAULT false NOT NULL,
    "tipo_frete" character varying(100),
    "prazo_faturamento" integer
);


--
-- Name: cotacao_fornecedores_particip_cotacao_fornecedores_particip_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."cotacao_fornecedores_particip_cotacao_fornecedores_particip_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cotacao_fornecedores_particip_cotacao_fornecedores_particip_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."cotacao_fornecedores_particip_cotacao_fornecedores_particip_seq" OWNED BY "public"."cotacao_fornecedores_participantes"."cotacao_fornecedores_participantes_id";


--
-- Name: cotacao_fornecedores_participantes cotacao_fornecedores_participantes_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cotacao_fornecedores_participantes" ALTER COLUMN "cotacao_fornecedores_participantes_id" SET DEFAULT "nextval"('"public"."cotacao_fornecedores_particip_cotacao_fornecedores_particip_seq"'::"regclass");


--
-- Name: cotacao_fornecedores_participantes cotacao_fornecedores_participantes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cotacao_fornecedores_participantes"
    ADD CONSTRAINT "cotacao_fornecedores_participantes_pkey" PRIMARY KEY ("cotacao_fornecedores_participantes_id");


--
-- Name: cotacao_fornecedores_participantes_identificador_geral_cotacao_; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "cotacao_fornecedores_participantes_identificador_geral_cotacao_" ON "public"."cotacao_fornecedores_participantes" USING "btree" ("identificador_geral", "cotacao_produtos_id");


--
-- Name: cotacao_fornecedores_participantes cotacao_fornecedores_participantes_cotacao_participacao_fornece; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cotacao_fornecedores_participantes"
    ADD CONSTRAINT "cotacao_fornecedores_participantes_cotacao_participacao_fornece" FOREIGN KEY ("cotacao_participacao_fornecedor_id") REFERENCES "public"."cotacao_participacao_fornecedor"("cotacao_participacao_fornecedor_id") ON UPDATE CASCADE ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

\unrestrict yaf3inmqRDuCg5IKBi09RIrOq1zA3IIvCnRtmtQxLdOcwblhnccx9xU2rl8F20S

