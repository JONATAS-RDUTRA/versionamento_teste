--
-- PostgreSQL database dump
--

\restrict xaN6zT28QruBwwvh03ufb99gjwhkjs6ahxDCpLcSgbktxkgdGfEdrAAA9ht2LC5

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
-- Name: cotacao_produtos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."cotacao_produtos" (
    "cotacao_produtos_id" integer NOT NULL,
    "cotacao_transacao_id" integer NOT NULL,
    "codigo_barras" character varying(25),
    "idproduto" character varying(25) DEFAULT ''::character varying NOT NULL,
    "descricao_produto" character varying(60) NOT NULL,
    "qtd_minima_aceita_emb" numeric(12,4) NOT NULL,
    "qtd_pedida" numeric(12,4) NOT NULL,
    "qtd_maxima_aceita_emb" numeric(12,4) NOT NULL,
    "idunidade_medida" character varying(100) NOT NULL,
    "multiplo_compra" numeric(12,4) NOT NULL,
    "unidade_master" character varying(20),
    "fator_conversao" numeric(12,6) NOT NULL,
    "cod_produto" character varying(30),
    "preco_custo" numeric(12,4) DEFAULT 0.0000 NOT NULL
);


--
-- Name: cotacao_produtos_cotacao_produtos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."cotacao_produtos_cotacao_produtos_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cotacao_produtos_cotacao_produtos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."cotacao_produtos_cotacao_produtos_id_seq" OWNED BY "public"."cotacao_produtos"."cotacao_produtos_id";


--
-- Name: cotacao_produtos cotacao_produtos_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cotacao_produtos" ALTER COLUMN "cotacao_produtos_id" SET DEFAULT "nextval"('"public"."cotacao_produtos_cotacao_produtos_id_seq"'::"regclass");


--
-- Name: cotacao_produtos cotacao_produtos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cotacao_produtos"
    ADD CONSTRAINT "cotacao_produtos_pkey" PRIMARY KEY ("cotacao_produtos_id");


--
-- Name: cotacao_produtos cotacao_produtos_cotacao_transacao_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cotacao_produtos"
    ADD CONSTRAINT "cotacao_produtos_cotacao_transacao_id_foreign" FOREIGN KEY ("cotacao_transacao_id") REFERENCES "public"."cotacao_transacao"("cotacao_transacao_id");


--
-- PostgreSQL database dump complete
--

\unrestrict xaN6zT28QruBwwvh03ufb99gjwhkjs6ahxDCpLcSgbktxkgdGfEdrAAA9ht2LC5

