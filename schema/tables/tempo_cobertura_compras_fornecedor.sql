--
-- PostgreSQL database dump
--

\restrict E21iVpK3ULDvbexeTE9TbDg5ca1OZR3xSeY7mVE0Hn9q365ckjm9j4gvCgcJbBb

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
-- Name: tempo_cobertura_compras_fornecedor; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."tempo_cobertura_compras_fornecedor" (
    "id" integer NOT NULL,
    "idfornecedor" bigint NOT NULL,
    "id_user" integer NOT NULL,
    "tempo_cobertura" bigint,
    "created_at" timestamp(0) without time zone,
    "updated_at" timestamp(0) without time zone,
    "deleted_at" timestamp(0) without time zone,
    "tempo_cobertura_esseg" integer DEFAULT 0,
    "cobertura_estoque_curva_a" bigint DEFAULT 0 NOT NULL,
    "cobertura_estoque_curva_b" bigint DEFAULT 0 NOT NULL,
    "cobertura_estoque_curva_c" bigint DEFAULT 0 NOT NULL
);


--
-- Name: COLUMN "tempo_cobertura_compras_fornecedor"."tempo_cobertura_esseg"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."tempo_cobertura_compras_fornecedor"."tempo_cobertura_esseg" IS '1 - CURVAS 2 - DEPARTAMENTO/SEGMENTO 3 - FORNECEDOR 4 - PRODUTO';


--
-- Name: COLUMN "tempo_cobertura_compras_fornecedor"."cobertura_estoque_curva_a"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."tempo_cobertura_compras_fornecedor"."cobertura_estoque_curva_a" IS 'COBERTURA DE ESTOQUE ITENS CURVA A';


--
-- Name: COLUMN "tempo_cobertura_compras_fornecedor"."cobertura_estoque_curva_b"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."tempo_cobertura_compras_fornecedor"."cobertura_estoque_curva_b" IS 'COBERTURA DE ESTOQUE ITENS CURVA B';


--
-- Name: COLUMN "tempo_cobertura_compras_fornecedor"."cobertura_estoque_curva_c"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."tempo_cobertura_compras_fornecedor"."cobertura_estoque_curva_c" IS 'COBERTURA DE ESTOQUE ITENS CURVA C';


--
-- Name: tempo_cobertura_compras_fornecedor_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."tempo_cobertura_compras_fornecedor_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tempo_cobertura_compras_fornecedor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."tempo_cobertura_compras_fornecedor_id_seq" OWNED BY "public"."tempo_cobertura_compras_fornecedor"."id";


--
-- Name: tempo_cobertura_compras_fornecedor id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."tempo_cobertura_compras_fornecedor" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."tempo_cobertura_compras_fornecedor_id_seq"'::"regclass");


--
-- Name: tempo_cobertura_compras_fornecedor tempo_cobertura_compras_fornecedor_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."tempo_cobertura_compras_fornecedor"
    ADD CONSTRAINT "tempo_cobertura_compras_fornecedor_pk" PRIMARY KEY ("id");


--
-- Name: tempo_cobertura_compras_fornecedor_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "tempo_cobertura_compras_fornecedor_idx" ON "public"."tempo_cobertura_compras_fornecedor" USING "btree" ("idfornecedor");


--
-- PostgreSQL database dump complete
--

\unrestrict E21iVpK3ULDvbexeTE9TbDg5ca1OZR3xSeY7mVE0Hn9q365ckjm9j4gvCgcJbBb

