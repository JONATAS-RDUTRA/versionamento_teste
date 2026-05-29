--
-- PostgreSQL database dump
--

\restrict 4uRqWHalKCzSN6bxSgclEFG1P1ZlXPyKVL7fDxFTQui4vq8AHvMJmP8pnwBko2t

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
-- Name: depositos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."depositos" (
    "iddeposito" integer DEFAULT "nextval"('"public"."depositos_iddeposito_seq"'::"regclass") NOT NULL,
    "descricao_deposito" character varying(60),
    "idfilial" integer NOT NULL
);


--
-- Name: depositos depositos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."depositos"
    ADD CONSTRAINT "depositos_pkey" PRIMARY KEY ("iddeposito");


--
-- Name: fk_depositos_filial1_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "fk_depositos_filial1_idx" ON "public"."depositos" USING "btree" ("idfilial");


--
-- Name: depositos fk_depositos_filial1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."depositos"
    ADD CONSTRAINT "fk_depositos_filial1" FOREIGN KEY ("idfilial") REFERENCES "public"."filial"("idfilial");


--
-- PostgreSQL database dump complete
--

\unrestrict 4uRqWHalKCzSN6bxSgclEFG1P1ZlXPyKVL7fDxFTQui4vq8AHvMJmP8pnwBko2t

