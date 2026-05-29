--
-- PostgreSQL database dump
--

\restrict n0Gpp6hr6U913PIbW6EIfTrke5hLYtN9Bq3PLfIKYGsMxeqCwdiLS7IxllYNW6Z

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
-- Name: colaboradores; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."colaboradores" (
    "idcolaborador" integer DEFAULT "nextval"('"public"."colaboradores_idcolaborador_seq"'::"regclass") NOT NULL,
    "nome_colaborador" character varying(60),
    "idfuncao" integer NOT NULL,
    "iddepartamento" integer NOT NULL
);


--
-- Name: colaboradores colaboradores_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."colaboradores"
    ADD CONSTRAINT "colaboradores_pkey" PRIMARY KEY ("idcolaborador");


--
-- Name: fk_colaboradores_departamentos1_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "fk_colaboradores_departamentos1_idx" ON "public"."colaboradores" USING "btree" ("iddepartamento");


--
-- Name: fk_colaboradores_funcoes_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "fk_colaboradores_funcoes_idx" ON "public"."colaboradores" USING "btree" ("idfuncao");


--
-- Name: colaboradores fk_colaboradores_departamentos1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."colaboradores"
    ADD CONSTRAINT "fk_colaboradores_departamentos1" FOREIGN KEY ("iddepartamento") REFERENCES "public"."departamentos"("iddepartamento");


--
-- Name: colaboradores fk_colaboradores_funcoes; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."colaboradores"
    ADD CONSTRAINT "fk_colaboradores_funcoes" FOREIGN KEY ("idfuncao") REFERENCES "public"."funcoes"("idfuncao");


--
-- PostgreSQL database dump complete
--

\unrestrict n0Gpp6hr6U913PIbW6EIfTrke5hLYtN9Bq3PLfIKYGsMxeqCwdiLS7IxllYNW6Z

