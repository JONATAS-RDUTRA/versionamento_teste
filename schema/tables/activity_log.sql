--
-- PostgreSQL database dump
--

\restrict dELhOfqm9UcpJuVziQMQ3aeSKqZdUmh45OtDb80wSX7cdaO0tJrcpesufkpImWN

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
-- Name: activity_log; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."activity_log" (
    "id" bigint NOT NULL,
    "log_name" character varying(255),
    "description" "text" NOT NULL,
    "subject_type" character varying(255),
    "subject_id" bigint,
    "causer_type" character varying(255),
    "causer_id" bigint,
    "properties" "json",
    "created_at" timestamp(0) without time zone,
    "updated_at" timestamp(0) without time zone,
    "is_reset" boolean DEFAULT true
)
WITH ("autovacuum_vacuum_scale_factor"='11.36767');


--
-- Name: activity_log_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."activity_log_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: activity_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."activity_log_id_seq" OWNED BY "public"."activity_log"."id";


--
-- Name: activity_log id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."activity_log" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."activity_log_id_seq"'::"regclass");


--
-- Name: activity_log activity_log_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."activity_log"
    ADD CONSTRAINT "activity_log_pkey" PRIMARY KEY ("id");


--
-- Name: activity_log_log_name_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "activity_log_log_name_index" ON "public"."activity_log" USING "btree" ("log_name");


--
-- Name: causer; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "causer" ON "public"."activity_log" USING "btree" ("causer_type", "causer_id");


--
-- Name: idx_activity_log_filial_idproduto_created_at_desc; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "idx_activity_log_filial_idproduto_created_at_desc" ON "public"."activity_log" USING "btree" (((((("properties" -> 'attributes'::"text") -> 'novo'::"text") ->> 'filial'::"text"))::integer), (((("properties" -> 'attributes'::"text") -> 'novo'::"text") ->> 'idproduto'::"text")), "created_at" DESC);


--
-- Name: subject; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "subject" ON "public"."activity_log" USING "btree" ("subject_type", "subject_id");


--
-- PostgreSQL database dump complete
--

\unrestrict dELhOfqm9UcpJuVziQMQ3aeSKqZdUmh45OtDb80wSX7cdaO0tJrcpesufkpImWN

