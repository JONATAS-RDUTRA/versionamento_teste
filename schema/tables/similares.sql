--
-- PostgreSQL database dump
--

\restrict ujzwJXkfMrhaT2R3UmMn5Gvd1csT7hqmc4wrV31MIsAQSqk8J27ghZMPcxub1eq

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
-- Name: similares; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."similares" (
    "id" integer NOT NULL,
    "id_item_pai" character varying(25) NOT NULL,
    "id_item_filho" character varying(25) NOT NULL,
    "data_cadastro" "date" DEFAULT ('now'::"text")::"date" NOT NULL,
    "agregar_estoque" character varying(1) DEFAULT 'N'::character varying NOT NULL
);


--
-- Name: similares_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."similares_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: similares_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."similares_id_seq" OWNED BY "public"."similares"."id";


--
-- Name: similares id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."similares" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."similares_id_seq"'::"regclass");


--
-- Name: similares similares_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."similares"
    ADD CONSTRAINT "similares_pk" PRIMARY KEY ("id");


--
-- Name: similares_id_item_pai_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "similares_id_item_pai_idx" ON "public"."similares" USING "btree" ("id_item_pai", "id_item_filho");


--
-- Name: similares similares_estoque_filial_trg; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER "similares_estoque_filial_trg" AFTER INSERT OR DELETE OR UPDATE ON "public"."similares" FOR EACH ROW EXECUTE FUNCTION "public"."gatilho_similares_filial"();


--
-- PostgreSQL database dump complete
--

\unrestrict ujzwJXkfMrhaT2R3UmMn5Gvd1csT7hqmc4wrV31MIsAQSqk8J27ghZMPcxub1eq

