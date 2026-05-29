--
-- PostgreSQL database dump
--

\restrict I64zh7pSToC6ckfBtbBLO4yscqpKl6FtoqpfeiW4pNx34nlWVvwHB6uoGgbTZbw

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
-- Name: distribuicao_drp_blacklist; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."distribuicao_drp_blacklist" (
    "id" integer NOT NULL,
    "filial" bigint NOT NULL,
    "idproduto" character varying(25) NOT NULL,
    "log_user" bigint NOT NULL,
    "log_data" timestamp without time zone
);


--
-- Name: distribuicao_drp_blacklist_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."distribuicao_drp_blacklist_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: distribuicao_drp_blacklist_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."distribuicao_drp_blacklist_id_seq" OWNED BY "public"."distribuicao_drp_blacklist"."id";


--
-- Name: distribuicao_drp_blacklist id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."distribuicao_drp_blacklist" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."distribuicao_drp_blacklist_id_seq"'::"regclass");


--
-- Name: distribuicao_drp_blacklist dist_drp_blacklist_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."distribuicao_drp_blacklist"
    ADD CONSTRAINT "dist_drp_blacklist_pkey" PRIMARY KEY ("id");


--
-- Name: dist_drp_blacklist_filial_produto_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "dist_drp_blacklist_filial_produto_idx" ON "public"."distribuicao_drp_blacklist" USING "btree" ("filial", "idproduto");


--
-- PostgreSQL database dump complete
--

\unrestrict I64zh7pSToC6ckfBtbBLO4yscqpKl6FtoqpfeiW4pNx34nlWVvwHB6uoGgbTZbw

