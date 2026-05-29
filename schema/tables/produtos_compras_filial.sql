--
-- PostgreSQL database dump
--

\restrict IG4DKhJKjMWgOhRSOTMaOaAK0PCZhYpRf3Au8EiGDb1JLJBZYSYqTrrBaWAGfcA

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
-- Name: produtos_compras_filial; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."produtos_compras_filial" (
    "id_grupo" bigint NOT NULL,
    "filial" integer NOT NULL,
    "idproduto" character varying(25) NOT NULL,
    "descricao_produto" character varying(60),
    "idcomprador" bigint,
    "idfornecedor" bigint,
    "idfamilia_produto" integer,
    "revenda" character varying(1),
    "status" character varying(2),
    "estoque" numeric,
    "cobertura_estoque" numeric(12,4),
    "estoque_seguranca" numeric,
    "ponto_pedido" numeric,
    "estoque_maximo" numeric,
    "consumo_medio_mensal" numeric,
    "desvio_padrao_consumo" numeric,
    "tempo_medio_ressuprimento" numeric(12,4),
    "tempo_ressuprimento" numeric(12,4),
    "desvio_padrao_ressuprimento" numeric(12,4),
    "coeficiente_variacao" "text",
    "compra_transito" numeric,
    "lote_minimo" numeric,
    "lote_compras_bruto" numeric,
    "arvore_decisao" character varying(20),
    "nivel_servico" character varying(20),
    "peso_compras" integer,
    "unidade_compra" character varying(20),
    "lote_embalagem" numeric,
    "sob_encomenda" integer,
    "lote_compras" numeric,
    "preco_compra" numeric(12,4),
    "custo_unitario" numeric(12,4),
    "valor_unitario" numeric(12,4),
    "estoque_bloqueado" numeric,
    "perfil_demanda" "text",
    "tempo_medio_apanhe" numeric(12,4),
    "embalagem" character varying(20),
    "idunidade_medida" character varying(3),
    "ressuprimento_manual" character varying(1),
    "ressuprimento_manual_dias" numeric,
    "cod_produto" character varying(30),
    "codigo_barras" character varying(25),
    "fator_atuacao" numeric(12,4),
    "estoque_avaria" numeric(12,4),
    "estoque_reservado" numeric(12,4),
    "multiplo_compra" numeric(12,6),
    "unidade_master" character varying(20),
    "processamento" timestamp without time zone,
    "peso" numeric(12,4) DEFAULT 0,
    "altura" numeric(12,4) DEFAULT 0,
    "largura" numeric(12,4) DEFAULT 0,
    "comprimento" numeric(12,4) DEFAULT 0,
    "data_ultima_requisicao" "date",
    "tipo_fator_conversao" character(1) DEFAULT 'D'::"bpchar" NOT NULL,
    "detalhamento_tecnico" "text",
    "estoque_minimo" numeric(12,4) DEFAULT 0 NOT NULL,
    "iddepartamento" character varying(25),
    "idsecao" character varying(25),
    "idcategoria" character varying(25),
    "flag" character varying(1),
    "compra_transito_entregue" numeric(12,4) DEFAULT 0 NOT NULL,
    "litragem" numeric(12,4),
    "idlinhaprod" bigint,
    "classificacao_rentabilidade" character(1),
    "estoque_seguranca_estetico" numeric(12,4) DEFAULT 0,
    "ponto_pedido_estetico" numeric(12,4) DEFAULT 0,
    "estoque_maximo_estetico" numeric(12,4) DEFAULT 0,
    "estoque_pendente" numeric(12,4),
    "valor_liquido" numeric(12,4) DEFAULT 0 NOT NULL,
    "ponto_pedido_analise_lote" numeric(12,4),
    "numero_original" character varying(50),
    "baixa_movimentacao" boolean DEFAULT false NOT NULL
);


--
-- Name: COLUMN "produtos_compras_filial"."estoque_pendente"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."produtos_compras_filial"."estoque_pendente" IS 'Saldo de venda futura';


--
-- Name: produtos_compras_filial produtos_compras_filial_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."produtos_compras_filial"
    ADD CONSTRAINT "produtos_compras_filial_pk" PRIMARY KEY ("id_grupo", "filial", "idproduto");


--
-- Name: produtos_compras_filial_idproduto_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "produtos_compras_filial_idproduto_idx" ON "public"."produtos_compras_filial" USING "btree" ("idproduto");


--
-- Name: produtos_compras_filial_lote_compras_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "produtos_compras_filial_lote_compras_idx" ON "public"."produtos_compras_filial" USING "btree" ("lote_compras", "sob_encomenda", "revenda", "status");


--
-- PostgreSQL database dump complete
--

\unrestrict IG4DKhJKjMWgOhRSOTMaOaAK0PCZhYpRf3Au8EiGDb1JLJBZYSYqTrrBaWAGfcA

