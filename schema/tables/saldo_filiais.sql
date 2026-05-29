--
-- PostgreSQL database dump
--

\restrict 3aLYzrriiAtO4aS1XTL8pZ3kzUNBbJy8zaOu8Jk2bXfFhoeWZXzuasNTexv2XTz

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
-- Name: saldo_filiais; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."saldo_filiais" (
    "filial" integer DEFAULT 0 NOT NULL,
    "idproduto" character varying(25) NOT NULL,
    "data" "date" NOT NULL,
    "ano" integer DEFAULT 0 NOT NULL,
    "mes" integer DEFAULT 0 NOT NULL,
    "trimestre" integer DEFAULT 0 NOT NULL,
    "cod_trimestre" integer DEFAULT 0 NOT NULL,
    "entradas" numeric(12,4) DEFAULT 0 NOT NULL,
    "saidas" numeric(12,4) DEFAULT 0 NOT NULL,
    "estoque" numeric(12,4) DEFAULT 0 NOT NULL,
    "media_trimestre" numeric(12,4) DEFAULT 0 NOT NULL,
    "media_diaria_trimestre" numeric(12,4) DEFAULT 0 NOT NULL,
    "desvio_padrao_trimestre" numeric(12,4) DEFAULT 0 NOT NULL,
    "processamento" timestamp without time zone,
    "coeficiente_variacao" numeric(12,4) DEFAULT 0 NOT NULL,
    "arvore_decisao" character varying(4),
    "tempo_ressuprimento" numeric(12,4),
    "desvio_padrao_ressuprimento" numeric(12,4),
    "devolucoes" numeric(12,4) DEFAULT 0 NOT NULL,
    "preco_custo" numeric(12,4),
    "esseg" numeric(12,4),
    "ppd" numeric(12,4),
    "emax" numeric(12,4),
    "saldo_estoque" numeric(12,4),
    "cmm" numeric(12,4),
    "cmm_std" numeric(12,4),
    "fes" numeric(12,4),
    "nivel_servico" character varying(30),
    "sugestao_compras" numeric(12,4)
)
WITH ("autovacuum_vacuum_scale_factor"='0.01753');


--
-- Name: saldo_filiais saldo_filiais_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."saldo_filiais"
    ADD CONSTRAINT "saldo_filiais_pk" PRIMARY KEY ("filial", "idproduto", "data");


--
-- Name: saldo_filiais_data_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "saldo_filiais_data_idx" ON "public"."saldo_filiais" USING "btree" ("data");


--
-- Name: saldo_filiais_idproduto_ano_mes_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "saldo_filiais_idproduto_ano_mes_idx" ON "public"."saldo_filiais" USING "btree" ("idproduto", "ano", "mes");


--
-- Name: saldo_filiais saldo_filiais_trg; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER "saldo_filiais_trg" BEFORE INSERT OR UPDATE ON "public"."saldo_filiais" FOR EACH ROW EXECUTE FUNCTION "public"."trigger_media_vendas"();


--
-- PostgreSQL database dump complete
--

\unrestrict 3aLYzrriiAtO4aS1XTL8pZ3kzUNBbJy8zaOu8Jk2bXfFhoeWZXzuasNTexv2XTz

