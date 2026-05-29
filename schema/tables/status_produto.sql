--
-- PostgreSQL database dump
--

\restrict NKni6Gf8NNEJGFay9WYW0jrIOe8gyOImM3an7zkm7Bu9wM32GjoJAfdgLzmfXzK

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
-- Name: status_produto; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."status_produto" (
    "id_grupo" bigint NOT NULL,
    "filial" integer NOT NULL,
    "ano" integer NOT NULL,
    "mes" integer NOT NULL,
    "descricao_produto" character varying(60),
    "descricao_familia_produto" character varying(60),
    "custo_unitario" numeric,
    "valor_unitario" numeric,
    "estoque" numeric(12,4),
    "estoque_transito" numeric,
    "status_compra" "text",
    "idproduto" character varying(25) NOT NULL,
    "data_solicitacao" "date",
    "arvore_decisao" character varying(4),
    "estoque_seguranca" numeric(12,4),
    "ponto_pedido" numeric(12,4),
    "estoque_maximo" numeric(12,4),
    "consumo_medio" numeric(12,4),
    "sugestao" numeric(12,4),
    "necessidade" numeric,
    "processamento" timestamp without time zone,
    "indice_nivel" smallint,
    "nivel_servico" character varying(20),
    "peso_nivel_servico" numeric(12,4),
    "status_produto" "text",
    "status_exposicao" "text",
    "peso_status" integer,
    "revenda" character varying(1),
    "fora_linha" character varying(2),
    "nome_completo" character varying(100),
    "ultima_entrada" "date",
    "ultima_solicitacao" "date",
    "id_solicitacao" double precision,
    "estoque_solicitacao" numeric(12,4),
    "status_percepcao" "text",
    "id" bigint NOT NULL,
    "razao_social" character varying(100),
    "qtde_dias_ruptura" bigint,
    "data_cadastro" "date",
    "media_mensal" numeric,
    "ult_saida" "date",
    "tempo_ult_venda" integer,
    "analise_qualitativa" numeric,
    "media_mensal_diaria" numeric,
    "venda_diaria_calc" numeric,
    "ruptura_calc" numeric,
    "preco_medio_venda" numeric,
    "data_referencia" "date",
    "flag" character varying(1),
    "tempo_ressuprimento" numeric,
    "desvio_padrao_ressuprimento" numeric,
    "data_ruptura" "date"
)
WITH ("autovacuum_vacuum_scale_factor"='0.35342');


--
-- Name: status_produto status_produto_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."status_produto"
    ADD CONSTRAINT "status_produto_pk" PRIMARY KEY ("id_grupo", "filial", "ano", "mes", "id", "idproduto");


--
-- Name: status_produto_ano_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "status_produto_ano_idx" ON "public"."status_produto" USING "btree" ("ano", "mes", "flag");


--
-- Name: status_produto_data_referencia_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "status_produto_data_referencia_idx" ON "public"."status_produto" USING "btree" ("data_referencia");


--
-- Name: status_produto_grupo_forn_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "status_produto_grupo_forn_idx" ON "public"."status_produto" USING "btree" ("id_grupo", "id", "data_referencia");


--
-- Name: status_produto_grupo_status_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "status_produto_grupo_status_idx" ON "public"."status_produto" USING "btree" ("id_grupo", "status_produto");


--
-- Name: status_produto status_produto_trg; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER "status_produto_trg" BEFORE INSERT OR UPDATE ON "public"."status_produto" FOR EACH ROW EXECUTE FUNCTION "public"."trigger_preco_medio_venda"();


--
-- PostgreSQL database dump complete
--

\unrestrict NKni6Gf8NNEJGFay9WYW0jrIOe8gyOImM3an7zkm7Bu9wM32GjoJAfdgLzmfXzK

