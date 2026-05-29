--
-- PostgreSQL database dump
--

\restrict 08lffvOJtHBdvfdyGM74GvXP9wnUHnMEaBdfTLBeUToIwqCQARhFkbKedZWxove

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
-- Name: cotacao_local_recebimento_dias; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."cotacao_local_recebimento_dias" (
    "cotacao_local_recebimento_dias_id" integer NOT NULL,
    "cotacao_local_recebimento_id" integer NOT NULL,
    "dia_semana_id" smallint NOT NULL
);


--
-- Name: cotacao_local_recebimento_dia_cotacao_local_recebimento_dia_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."cotacao_local_recebimento_dia_cotacao_local_recebimento_dia_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cotacao_local_recebimento_dia_cotacao_local_recebimento_dia_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."cotacao_local_recebimento_dia_cotacao_local_recebimento_dia_seq" OWNED BY "public"."cotacao_local_recebimento_dias"."cotacao_local_recebimento_dias_id";


--
-- Name: cotacao_local_recebimento_dias cotacao_local_recebimento_dias_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cotacao_local_recebimento_dias" ALTER COLUMN "cotacao_local_recebimento_dias_id" SET DEFAULT "nextval"('"public"."cotacao_local_recebimento_dia_cotacao_local_recebimento_dia_seq"'::"regclass");


--
-- Name: cotacao_local_recebimento_dias cotacao_local_recebimento_dias_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cotacao_local_recebimento_dias"
    ADD CONSTRAINT "cotacao_local_recebimento_dias_pkey" PRIMARY KEY ("cotacao_local_recebimento_dias_id");


--
-- Name: cotacao_local_recebimento_dias_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "cotacao_local_recebimento_dias_unique" ON "public"."cotacao_local_recebimento_dias" USING "btree" ("cotacao_local_recebimento_id", "dia_semana_id");


--
-- Name: cotacao_local_recebimento_dias cotacao_local_recebimento_dias_cotacao_local_recebimento_id_for; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cotacao_local_recebimento_dias"
    ADD CONSTRAINT "cotacao_local_recebimento_dias_cotacao_local_recebimento_id_for" FOREIGN KEY ("cotacao_local_recebimento_id") REFERENCES "public"."cotacao_local_recebimento"("cotacao_local_recebimento_id") ON DELETE CASCADE;


--
-- Name: cotacao_local_recebimento_dias cotacao_local_recebimento_dias_dia_semana_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cotacao_local_recebimento_dias"
    ADD CONSTRAINT "cotacao_local_recebimento_dias_dia_semana_id_foreign" FOREIGN KEY ("dia_semana_id") REFERENCES "public"."dias_semana"("dia_semana_id");


--
-- PostgreSQL database dump complete
--

\unrestrict 08lffvOJtHBdvfdyGM74GvXP9wnUHnMEaBdfTLBeUToIwqCQARhFkbKedZWxove

