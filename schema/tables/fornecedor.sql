--
-- PostgreSQL database dump
--

\restrict 3KGHVTX5roM4EDg3c4hN9hV1aqb9pQOTd4qq7N7BZYM6fieMXDjkmUVmjFEeuRl

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
-- Name: fornecedor; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."fornecedor" (
    "id" bigint NOT NULL,
    "razao_social" character varying(100),
    "ressuprimento_manual" character varying(1) DEFAULT 'N'::character varying NOT NULL,
    "ressuprimento_qtde_dias" integer DEFAULT 0 NOT NULL,
    "processamento" timestamp without time zone DEFAULT "now"() NOT NULL,
    "idcomprador" bigint,
    "fator_atuacao" numeric(12,4) DEFAULT 1 NOT NULL,
    "tempo_forecast" integer DEFAULT 15 NOT NULL,
    "pedido_minino_compra" numeric(12,2),
    "ativo" character varying(1) DEFAULT 'S'::character varying NOT NULL,
    "dia_data_limite" integer DEFAULT 0 NOT NULL,
    "flag_cobertura_manual" character varying(1) DEFAULT 'N'::character varying NOT NULL,
    "cobertura_est_manual" integer DEFAULT 0 NOT NULL,
    "data_ultima_analise" timestamp(0) without time zone,
    "converter_para_emb_master" boolean DEFAULT false NOT NULL,
    "calcular_litragem" boolean DEFAULT false NOT NULL,
    "tipo_litragem" character varying(2) DEFAULT 'LT'::character varying,
    "observacao" "text",
    "status_tempo_esseg" integer DEFAULT 0,
    "condicao_pagamento" character varying(50),
    "fornecedor_local" boolean DEFAULT false,
    "uf" character(2),
    "cnpj" character varying(255),
    "email" character varying(255),
    "telefone_celular" character varying(255),
    CONSTRAINT "dia_data_limite_check" CHECK ((("dia_data_limite" >= 0) AND ("dia_data_limite" <= 31))),
    CONSTRAINT "fornecedor_fator_atuacao_check" CHECK (("fator_atuacao" <> (0)::numeric)),
    CONSTRAINT "ressuprimento_qtde_dias_maior_que_zero" CHECK (("ressuprimento_qtde_dias" >= 0)),
    CONSTRAINT "tipo_litragem_check" CHECK ((("tipo_litragem")::"text" = ANY (ARRAY[('LT'::character varying)::"text", ('GL'::character varying)::"text"])))
);


--
-- Name: COLUMN "fornecedor"."id"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."fornecedor"."id" IS 'Código do Fornecedor';


--
-- Name: COLUMN "fornecedor"."razao_social"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."fornecedor"."razao_social" IS 'Nome do Fornecedor';


--
-- Name: COLUMN "fornecedor"."idcomprador"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."fornecedor"."idcomprador" IS 'Código do Comprador no Fornecedor';


--
-- Name: COLUMN "fornecedor"."tipo_litragem"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."fornecedor"."tipo_litragem" IS 'Duas possibilidades: LT(Litro) ou GL(Galão)';


--
-- Name: COLUMN "fornecedor"."status_tempo_esseg"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."fornecedor"."status_tempo_esseg" IS '1 - CURVAS 2 - DEPARTAMENTO/SEGMENTO 3 - FORNECEDOR 4 - PRODUTO';


--
-- Name: fornecedor fornecedor_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."fornecedor"
    ADD CONSTRAINT "fornecedor_pkey" PRIMARY KEY ("id");


--
-- PostgreSQL database dump complete
--

\unrestrict 3KGHVTX5roM4EDg3c4hN9hV1aqb9pQOTd4qq7N7BZYM6fieMXDjkmUVmjFEeuRl

