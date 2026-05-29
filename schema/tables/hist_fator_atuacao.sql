--
-- PostgreSQL database dump
--

\restrict 30vydBE3fdcwL8Iy69Kl5LVpooUSAWahAKyxPKu9LcWVWpqgeRFiK5CvUaujoB2

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
-- Name: hist_fator_atuacao; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."hist_fator_atuacao" (
    "id" integer NOT NULL,
    "id_grupo" numeric(12,0) DEFAULT 0 NOT NULL,
    "id_fornecedor" numeric(12,0) DEFAULT 0 NOT NULL,
    "idproduto" character varying(25),
    "data" timestamp without time zone NOT NULL,
    "fator" numeric(12,4) DEFAULT 0 NOT NULL,
    "id_user" integer,
    "data_limite" "date",
    "status" character varying(1) DEFAULT 'A'::character varying NOT NULL,
    "processamento" timestamp without time zone
);


--
-- Name: hist_fator_atuacao_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."hist_fator_atuacao_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hist_fator_atuacao_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."hist_fator_atuacao_id_seq" OWNED BY "public"."hist_fator_atuacao"."id";


--
-- Name: hist_fator_atuacao id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."hist_fator_atuacao" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."hist_fator_atuacao_id_seq"'::"regclass");


--
-- Name: hist_fator_atuacao pk_hist_fator_atuacao; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."hist_fator_atuacao"
    ADD CONSTRAINT "pk_hist_fator_atuacao" PRIMARY KEY ("id");


--
-- Name: hist_fator_atuacao_id_grupo_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "hist_fator_atuacao_id_grupo_idx" ON "public"."hist_fator_atuacao" USING "btree" ("id_grupo", "id_fornecedor");


--
-- Name: hist_fator_atuacao_id_grupo_prod_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "hist_fator_atuacao_id_grupo_prod_idx" ON "public"."hist_fator_atuacao" USING "btree" ("id_grupo", "id_fornecedor", "idproduto");


--
-- PostgreSQL database dump complete
--

\unrestrict 30vydBE3fdcwL8Iy69Kl5LVpooUSAWahAKyxPKu9LcWVWpqgeRFiK5CvUaujoB2

