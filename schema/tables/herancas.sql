--
-- PostgreSQL database dump
--

\restrict 7U8A50hbxIMto6q7fwCItz35kdvqsYOmNipdCGnXqwPRjftFodQbcngr4zCuXMx

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
-- Name: herancas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."herancas" (
    "id" integer NOT NULL,
    "id_item_pai" character varying NOT NULL,
    "id_item_filho" character varying NOT NULL,
    "prazo_ini" "date" DEFAULT ('now'::"text")::"date" NOT NULL,
    "prazo_fim" "date" DEFAULT (('now'::"text")::"date" + 30) NOT NULL
);


--
-- Name: herancas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."herancas_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: herancas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."herancas_id_seq" OWNED BY "public"."herancas"."id";


--
-- Name: herancas id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."herancas" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."herancas_id_seq"'::"regclass");


--
-- Name: herancas heranca_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."herancas"
    ADD CONSTRAINT "heranca_pk" PRIMARY KEY ("id");


--
-- Name: herancas_id_item_pai_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "herancas_id_item_pai_idx" ON "public"."herancas" USING "btree" ("id_item_pai", "id_item_filho");


--
-- PostgreSQL database dump complete
--

\unrestrict 7U8A50hbxIMto6q7fwCItz35kdvqsYOmNipdCGnXqwPRjftFodQbcngr4zCuXMx

