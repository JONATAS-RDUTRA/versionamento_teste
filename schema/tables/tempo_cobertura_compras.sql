--
-- PostgreSQL database dump
--

\restrict dECH93Jxe0KQGr8kd9l0OAgF2B5hqtWXAczaGv0wuzj0HC55KrBR8t43tMcbNTd

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
-- Name: tempo_cobertura_compras; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."tempo_cobertura_compras" (
    "id" integer NOT NULL,
    "id_grupo" integer NOT NULL,
    "filial" integer NOT NULL,
    "id_user" integer NOT NULL,
    "pqr" character varying(1) NOT NULL,
    "xyz" character varying(1) NOT NULL,
    "tempo_cobertura" bigint,
    "created_at" timestamp(0) without time zone,
    "updated_at" timestamp(0) without time zone,
    "deleted_at" timestamp(0) without time zone,
    "aplicado" timestamp(0) without time zone,
    "tempo_cobertura_esseg" integer DEFAULT 0
);


--
-- Name: tempo_cobertura_compras_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."tempo_cobertura_compras_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tempo_cobertura_compras_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."tempo_cobertura_compras_id_seq" OWNED BY "public"."tempo_cobertura_compras"."id";


--
-- Name: tempo_cobertura_compras id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."tempo_cobertura_compras" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."tempo_cobertura_compras_id_seq"'::"regclass");


--
-- Name: tempo_cobertura_compras tempo_cobertura_compras_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."tempo_cobertura_compras"
    ADD CONSTRAINT "tempo_cobertura_compras_pk" PRIMARY KEY ("id");


--
-- Name: tempo_cobertura_compras_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "tempo_cobertura_compras_idx" ON "public"."tempo_cobertura_compras" USING "btree" ("id_grupo", "filial", "pqr", "xyz");


--
-- PostgreSQL database dump complete
--

\unrestrict dECH93Jxe0KQGr8kd9l0OAgF2B5hqtWXAczaGv0wuzj0HC55KrBR8t43tMcbNTd

