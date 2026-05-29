--
-- PostgreSQL database dump
--

\restrict siDhsjNsbcr2qYCNPO0AoSePevsCn9iXbsfVCXK4qD3Kaq8BF2GuDbdjk4tT5zg

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
-- Name: grupo_filial; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."grupo_filial" (
    "id_grupo" bigint NOT NULL,
    "filial" bigint NOT NULL,
    "data_cadastro" "date" DEFAULT ('now'::"text")::"date" NOT NULL,
    "cobertura_drp" bigint DEFAULT 30 NOT NULL,
    "tempo_ressuprimento_drp" bigint DEFAULT 5 NOT NULL,
    "matriz" character varying(1) DEFAULT 'N'::character varying NOT NULL,
    "filtro_disponibilidade_drp" character varying(1) DEFAULT 'S'::character varying NOT NULL,
    "filial_cd" character varying(1) DEFAULT 'N'::character varying NOT NULL,
    "limite_cobertura" integer DEFAULT 0 NOT NULL,
    "limite_distribuicao" integer DEFAULT 0 NOT NULL,
    "cobertura_drp_reverso" bigint DEFAULT 30 NOT NULL,
    "tempo_ressuprimento_drp_reverso" bigint DEFAULT 5 NOT NULL,
    "limite_cobertura_reverso" bigint DEFAULT 0 NOT NULL,
    "limite_distribuicao_reverso" bigint DEFAULT 0 NOT NULL,
    "cobertura_por_curva" character varying(1) DEFAULT 'S'::character varying NOT NULL,
    "subgrupo" bigint,
    "drp_ordem_distribuicao" integer DEFAULT 0 NOT NULL,
    "filial_para_pedido_compra" boolean DEFAULT false,
    "drp_filial_estrategica_balanceamento" boolean DEFAULT false NOT NULL,
    "considerar_estoque" boolean DEFAULT true NOT NULL
);


--
-- Name: COLUMN "grupo_filial"."cobertura_drp"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."grupo_filial"."cobertura_drp" IS 'Quantidade de dias de cobertura de estoque drp';


--
-- Name: COLUMN "grupo_filial"."tempo_ressuprimento_drp"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."grupo_filial"."tempo_ressuprimento_drp" IS 'Quantidade de dias para o ressuprimento DRP';


--
-- Name: grupo_filial grupo_filial_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."grupo_filial"
    ADD CONSTRAINT "grupo_filial_pk" PRIMARY KEY ("id_grupo", "filial");


--
-- Name: grupo_filial_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "grupo_filial_idx" ON "public"."grupo_filial" USING "btree" ("filial");


--
-- PostgreSQL database dump complete
--

\unrestrict siDhsjNsbcr2qYCNPO0AoSePevsCn9iXbsfVCXK4qD3Kaq8BF2GuDbdjk4tT5zg

