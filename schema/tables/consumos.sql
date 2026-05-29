--
-- PostgreSQL database dump
--

\restrict 4umCCZqp4UsXWkdiOp6fcLV0DUYZw7Nh60tSrKxGeQYsIvhwiMzffZPpylSkElC

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
-- Name: consumos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."consumos" (
    "idconsumo" bigint NOT NULL,
    "emissao" "date" NOT NULL,
    "horariomov" character varying(8) DEFAULT '00:00:00'::character varying NOT NULL,
    "idproduto" character varying(25) DEFAULT ''::character varying NOT NULL,
    "qtde" double precision,
    "status" character varying(45) NOT NULL,
    "valor_unit" numeric(12,4) DEFAULT 0 NOT NULL,
    "filial" bigint DEFAULT 1 NOT NULL,
    "item" integer DEFAULT 0 NOT NULL,
    "fator_conversao" numeric(12,4),
    "unidade_medida" character varying(3),
    "valor_cmv" numeric(12,4),
    "cod_vendedor" character varying(10),
    "nome_vendedor" character varying(100),
    "cod_cliente" character varying(10),
    "nome_cliente" character varying(100),
    "flag" character varying(1),
    "perc_lucro" numeric,
    "vlr_lucro" numeric,
    "numtrans" bigint NOT NULL,
    "filial_retira" bigint
)
WITH ("autovacuum_vacuum_scale_factor"='0.48357');


--
-- Name: COLUMN "consumos"."idconsumo"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."consumos"."idconsumo" IS 'Número da venda';


--
-- Name: COLUMN "consumos"."emissao"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."consumos"."emissao" IS 'Emissão da venda';


--
-- Name: COLUMN "consumos"."horariomov"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."consumos"."horariomov" IS 'Horário da venda';


--
-- Name: COLUMN "consumos"."idproduto"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."consumos"."idproduto" IS 'Produto';


--
-- Name: COLUMN "consumos"."qtde"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."consumos"."qtde" IS 'Quantidade';


--
-- Name: COLUMN "consumos"."status"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."consumos"."status" IS 'Verifica se está fora de linha ou ativo';


--
-- Name: COLUMN "consumos"."valor_unit"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."consumos"."valor_unit" IS 'Valor da venda';


--
-- Name: COLUMN "consumos"."filial"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."consumos"."filial" IS 'Filial da venda';


--
-- Name: COLUMN "consumos"."unidade_medida"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."consumos"."unidade_medida" IS 'Embalagem';


--
-- Name: COLUMN "consumos"."cod_vendedor"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."consumos"."cod_vendedor" IS 'Código do vendedor';


--
-- Name: COLUMN "consumos"."nome_vendedor"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."consumos"."nome_vendedor" IS 'Nome do vendedor';


--
-- Name: COLUMN "consumos"."cod_cliente"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."consumos"."cod_cliente" IS 'Código do Cliente';


--
-- Name: COLUMN "consumos"."nome_cliente"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."consumos"."nome_cliente" IS 'Nome do cliente';


--
-- Name: COLUMN "consumos"."perc_lucro"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."consumos"."perc_lucro" IS 'Percentual de Lucro';


--
-- Name: COLUMN "consumos"."vlr_lucro"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."consumos"."vlr_lucro" IS 'Valor do Lucro';


--
-- Name: consumos pk_consumo; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."consumos"
    ADD CONSTRAINT "pk_consumo" PRIMARY KEY ("filial", "idconsumo", "emissao", "idproduto", "item", "status", "horariomov", "numtrans");


--
-- Name: consumos_index01; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "consumos_index01" ON "public"."consumos" USING "btree" ("idproduto");


--
-- Name: consumos_index02; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "consumos_index02" ON "public"."consumos" USING "btree" ("idproduto", "emissao");


--
-- Name: consumos_index03; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "consumos_index03" ON "public"."consumos" USING "btree" ("filial", "idproduto", "emissao");


--
-- Name: consumos_index04; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "consumos_index04" ON "public"."consumos" USING "btree" ("filial", "idproduto");


--
-- Name: idx_consumos_cte_vendas_min; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "idx_consumos_cte_vendas_min" ON "public"."consumos" USING "btree" ("emissao", "filial", "idproduto", "cod_cliente") WHERE (("cod_cliente" IS NOT NULL) AND ("qtde" > (0)::double precision));


--
-- Name: consumos before_insert_or_update_zerar_quantidade; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER "before_insert_or_update_zerar_quantidade" BEFORE INSERT OR UPDATE ON "public"."consumos" FOR EACH ROW EXECUTE FUNCTION "public"."trg_zerar_quantidade_consumos"();


--
-- PostgreSQL database dump complete
--

\unrestrict 4umCCZqp4UsXWkdiOp6fcLV0DUYZw7Nh60tSrKxGeQYsIvhwiMzffZPpylSkElC

