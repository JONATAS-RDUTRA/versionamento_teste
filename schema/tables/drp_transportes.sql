--
-- PostgreSQL database dump
--

\restrict h90WJeTXojhHLaA34NYeMlm5f1NKmeChHx7BH7fTI5c76RxaqjMejzP3xFay9dL

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
-- Name: drp_transportes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."drp_transportes" (
    "id" integer NOT NULL,
    "descricao" character varying(60),
    "placa" character varying(9),
    "capacidade_carga" numeric(12,0),
    "deleted_at" timestamp(0) without time zone
);


--
-- Name: drp_transportes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."drp_transportes_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: drp_transportes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."drp_transportes_id_seq" OWNED BY "public"."drp_transportes"."id";


--
-- Name: drp_transportes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."drp_transportes" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."drp_transportes_id_seq"'::"regclass");


--
-- Name: drp_transportes transportes_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."drp_transportes"
    ADD CONSTRAINT "transportes_pk" PRIMARY KEY ("id");


--
-- Name: transportes_placa_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "transportes_placa_idx" ON "public"."drp_transportes" USING "btree" ("placa", "deleted_at");


--
-- PostgreSQL database dump complete
--

\unrestrict h90WJeTXojhHLaA34NYeMlm5f1NKmeChHx7BH7fTI5c76RxaqjMejzP3xFay9dL

