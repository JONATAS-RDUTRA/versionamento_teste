--
-- PostgreSQL database dump
--

\restrict iYaorCRNdNXh1K8TJatKSmexG6a3zLs0zgSvnxlwI4rcuyb2YcZBZQyxP5c912I

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
-- Name: notificacao_produtos_blacklist; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."notificacao_produtos_blacklist" (
    "id" integer NOT NULL,
    "grupo" bigint NOT NULL,
    "filial" bigint NOT NULL,
    "idfornecedor" bigint NOT NULL,
    "idproduto" character varying(25) NOT NULL,
    "data_limite" "date" NOT NULL,
    "log_user" bigint NOT NULL,
    "log_data" timestamp without time zone,
    "delete_at" timestamp(0) without time zone,
    "user_delete" bigint,
    "deleted_at" timestamp(0) without time zone,
    "id_autorizacao" integer
);


--
-- Name: notificacao_produtos_blacklist_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."notificacao_produtos_blacklist_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notificacao_produtos_blacklist_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."notificacao_produtos_blacklist_id_seq" OWNED BY "public"."notificacao_produtos_blacklist"."id";


--
-- Name: notificacao_produtos_blacklist id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."notificacao_produtos_blacklist" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."notificacao_produtos_blacklist_id_seq"'::"regclass");


--
-- Name: notificacao_produtos_blacklist notif_prod_blacklist; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."notificacao_produtos_blacklist"
    ADD CONSTRAINT "notif_prod_blacklist" PRIMARY KEY ("id");


--
-- Name: notif_prod_blacklist_forn_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "notif_prod_blacklist_forn_idx" ON "public"."notificacao_produtos_blacklist" USING "btree" ("idfornecedor");


--
-- Name: notif_prod_blacklist_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "notif_prod_blacklist_idx" ON "public"."notificacao_produtos_blacklist" USING "btree" ("id", "grupo", "filial", "idproduto", "data_limite", "deleted_at");


--
-- PostgreSQL database dump complete
--

\unrestrict iYaorCRNdNXh1K8TJatKSmexG6a3zLs0zgSvnxlwI4rcuyb2YcZBZQyxP5c912I

