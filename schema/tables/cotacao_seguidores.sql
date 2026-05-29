--
-- PostgreSQL database dump
--

\restrict eL3AURY4Ut8Lsx48V53F644cRtSo1NE32NXgWqgw7NFq6Kn1ISZFFKgEbXOohbg

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
-- Name: cotacao_seguidores; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."cotacao_seguidores" (
    "cotacao_seguidores_id" integer NOT NULL,
    "user_id" integer,
    "responsavel_id" integer NOT NULL,
    "cotacao_transacao_id" integer
);


--
-- Name: cotacao_seguidores_cotacao_seguidores_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."cotacao_seguidores_cotacao_seguidores_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cotacao_seguidores_cotacao_seguidores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."cotacao_seguidores_cotacao_seguidores_id_seq" OWNED BY "public"."cotacao_seguidores"."cotacao_seguidores_id";


--
-- Name: cotacao_seguidores cotacao_seguidores_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cotacao_seguidores" ALTER COLUMN "cotacao_seguidores_id" SET DEFAULT "nextval"('"public"."cotacao_seguidores_cotacao_seguidores_id_seq"'::"regclass");


--
-- Name: cotacao_seguidores cotacao_seguidores_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cotacao_seguidores"
    ADD CONSTRAINT "cotacao_seguidores_pkey" PRIMARY KEY ("cotacao_seguidores_id");


--
-- Name: cotacao_seguidores_responsavel_unique_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "cotacao_seguidores_responsavel_unique_idx" ON "public"."cotacao_seguidores" USING "btree" ("cotacao_transacao_id", "responsavel_id") WHERE ("user_id" IS NULL);


--
-- Name: cotacao_seguidores cotacao_seguidores_cotacao_transacao_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cotacao_seguidores"
    ADD CONSTRAINT "cotacao_seguidores_cotacao_transacao_id_foreign" FOREIGN KEY ("cotacao_transacao_id") REFERENCES "public"."cotacao_transacao"("cotacao_transacao_id");


--
-- PostgreSQL database dump complete
--

\unrestrict eL3AURY4Ut8Lsx48V53F644cRtSo1NE32NXgWqgw7NFq6Kn1ISZFFKgEbXOohbg

