--
-- PostgreSQL database dump
--

\restrict X7FFDyfrCh46rjNy9XwaGzqPzhb9jB54SnTKujjBasnlJugwF46CYucotGDGRfv

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
-- Name: resposta_criticidade; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."resposta_criticidade" (
    "idquestionario" integer NOT NULL,
    "idresposta" integer DEFAULT "nextval"('"public"."resposta_criticidade_idresposta_seq"'::"regclass") NOT NULL,
    "resposta" "text",
    "classificacao" character varying(1)
);


--
-- Name: resposta_criticidade resposta_criticidade_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."resposta_criticidade"
    ADD CONSTRAINT "resposta_criticidade_pkey" PRIMARY KEY ("idresposta");


--
-- Name: fk_resposta_criticidade_questionario_criticidade1_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "fk_resposta_criticidade_questionario_criticidade1_idx" ON "public"."resposta_criticidade" USING "btree" ("idquestionario");


--
-- Name: resposta_criticidade fk_resposta_criticidade_questionario_criticidade1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."resposta_criticidade"
    ADD CONSTRAINT "fk_resposta_criticidade_questionario_criticidade1" FOREIGN KEY ("idquestionario") REFERENCES "public"."questionario_criticidade"("idquestionario");


--
-- PostgreSQL database dump complete
--

\unrestrict X7FFDyfrCh46rjNy9XwaGzqPzhb9jB54SnTKujjBasnlJugwF46CYucotGDGRfv

