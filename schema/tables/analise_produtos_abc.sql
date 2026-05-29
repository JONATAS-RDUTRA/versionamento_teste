--
-- PostgreSQL database dump
--

\restrict NHp3cLh4DdqLFIOAgQ1iQT68g1eAtzW7bURM2qpfrkJck0gkVJV7dWcNXIkTjMc

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
-- Name: analise_produtos_abc; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."analise_produtos_abc" (
    "id" integer NOT NULL,
    "id_grupo" integer,
    "filial" integer,
    "idfornecedor" bigint,
    "razao_social" character varying(100),
    "idproduto" character varying(25) NOT NULL,
    "descricao_produto" character varying(60),
    "codigo_barras" character varying(25),
    "class_abc" "text",
    "media_saidas" numeric(12,4),
    "valor_unitario" numeric(12,4),
    "total_acomulado" numeric,
    "und_venda" character varying(4),
    "estoque_atual" numeric(12,4),
    "venda_1" numeric(12,4) DEFAULT 0 NOT NULL,
    "venda_2" numeric(12,4) DEFAULT 0 NOT NULL,
    "venda_3" numeric(12,4) DEFAULT 0 NOT NULL,
    "venda_4" numeric(12,4) DEFAULT 0 NOT NULL,
    "venda_5" numeric(12,4) DEFAULT 0 NOT NULL,
    "venda_6" numeric(12,4) DEFAULT 0 NOT NULL,
    "venda_7" numeric(12,4) DEFAULT 0 NOT NULL,
    "saldo_1" numeric(12,4) DEFAULT 0 NOT NULL,
    "saldo_2" numeric(12,4) DEFAULT 0 NOT NULL,
    "saldo_3" numeric(12,4) DEFAULT 0 NOT NULL,
    "saldo_4" numeric(12,4) DEFAULT 0 NOT NULL,
    "saldo_5" numeric(12,4) DEFAULT 0 NOT NULL,
    "saldo_6" numeric(12,4) DEFAULT 0 NOT NULL,
    "saldo_7" numeric(12,4) DEFAULT 0 NOT NULL
);


--
-- Name: analise_produtos_abc analise_produtos_abc_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."analise_produtos_abc"
    ADD CONSTRAINT "analise_produtos_abc_pk" PRIMARY KEY ("id");


--
-- PostgreSQL database dump complete
--

\unrestrict NHp3cLh4DdqLFIOAgQ1iQT68g1eAtzW7bURM2qpfrkJck0gkVJV7dWcNXIkTjMc

