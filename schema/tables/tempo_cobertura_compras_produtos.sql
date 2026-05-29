--
-- PostgreSQL database dump
--

\restrict Jngb72ZDVCuxWIghD1RaZCPce4cDdqqCuihjqeER4ClwSBVcxs6DOCcmPMtKSmL

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
-- Name: tempo_cobertura_compras_produtos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."tempo_cobertura_compras_produtos" (
    "id" integer NOT NULL,
    "idproduto" character varying(25) NOT NULL,
    "id_user" integer NOT NULL,
    "tempo_cobertura" bigint,
    "created_at" timestamp(0) without time zone,
    "updated_at" timestamp(0) without time zone,
    "deleted_at" timestamp(0) without time zone,
    "tempo_cobertura_esseg" integer DEFAULT 0
);


--
-- Name: COLUMN "tempo_cobertura_compras_produtos"."tempo_cobertura_esseg"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."tempo_cobertura_compras_produtos"."tempo_cobertura_esseg" IS '1 - CURVAS 2 - DEPARTAMENTO/SEGMENTO 3 - FORNECEDOR 4 - PRODUTO';


--
-- Name: tempo_cobertura_compras_produtos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."tempo_cobertura_compras_produtos_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tempo_cobertura_compras_produtos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."tempo_cobertura_compras_produtos_id_seq" OWNED BY "public"."tempo_cobertura_compras_produtos"."id";


--
-- Name: tempo_cobertura_compras_produtos id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."tempo_cobertura_compras_produtos" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."tempo_cobertura_compras_produtos_id_seq"'::"regclass");


--
-- Name: tempo_cobertura_compras_produtos tempo_cobertura_compras_produtos_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."tempo_cobertura_compras_produtos"
    ADD CONSTRAINT "tempo_cobertura_compras_produtos_pk" PRIMARY KEY ("id");


--
-- Name: tempo_cobertura_compras_produtos_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "tempo_cobertura_compras_produtos_idx" ON "public"."tempo_cobertura_compras_produtos" USING "btree" ("idproduto");


--
-- PostgreSQL database dump complete
--

\unrestrict Jngb72ZDVCuxWIghD1RaZCPce4cDdqqCuihjqeER4ClwSBVcxs6DOCcmPMtKSmL

