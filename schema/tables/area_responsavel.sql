--
-- PostgreSQL database dump
--

\restrict CdJeEUho0pi0mCUCOD6s9Nkvic4x7kLWQ3yrhqzpXhm0uVwddcDv88bjOyNAePX

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
-- Name: area_responsavel; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."area_responsavel" (
    "idarea_responsavel" integer DEFAULT "nextval"('"public"."area_responsavel_idarea_responsavel_seq"'::"regclass") NOT NULL,
    "descricao_area" character varying(60),
    "idcolaborador_responsavel" integer
);


--
-- Name: area_responsavel area_responsavel_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."area_responsavel"
    ADD CONSTRAINT "area_responsavel_pkey" PRIMARY KEY ("idarea_responsavel");


--
-- Name: descricao_area_UNIQUE; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "descricao_area_UNIQUE" ON "public"."area_responsavel" USING "btree" ("descricao_area");


--
-- Name: fk_area_responsavel_colaboradores1_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "fk_area_responsavel_colaboradores1_idx" ON "public"."area_responsavel" USING "btree" ("idcolaborador_responsavel");


--
-- Name: area_responsavel fk_area_responsavel_colaboradores1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."area_responsavel"
    ADD CONSTRAINT "fk_area_responsavel_colaboradores1" FOREIGN KEY ("idcolaborador_responsavel") REFERENCES "public"."colaboradores"("idcolaborador");


--
-- PostgreSQL database dump complete
--

\unrestrict CdJeEUho0pi0mCUCOD6s9Nkvic4x7kLWQ3yrhqzpXhm0uVwddcDv88bjOyNAePX

