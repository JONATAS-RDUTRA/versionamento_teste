--
-- PostgreSQL database dump
--

\restrict 1iNUBseuhBhghl8GojLPUgHfX6ze52Ih1MBIdM0BLTEMHPpb0KhBXx7cehLiF5h

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
-- Name: parametros_criticidade; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."parametros_criticidade" (
    "idcriticidade" character varying(6) DEFAULT ''::character varying NOT NULL,
    "classificacao" character varying(1) DEFAULT ''::character varying NOT NULL
);


--
-- Name: parametros_criticidade parametros_criticidade_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."parametros_criticidade"
    ADD CONSTRAINT "parametros_criticidade_pkey" PRIMARY KEY ("idcriticidade");


--
-- Name: fk_parametros_criticidade_parametros_avaliacao1_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "fk_parametros_criticidade_parametros_avaliacao1_idx" ON "public"."parametros_criticidade" USING "btree" ("classificacao");


--
-- Name: parametros_criticidade fk_parametros_criticidade_parametros_avaliacao1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."parametros_criticidade"
    ADD CONSTRAINT "fk_parametros_criticidade_parametros_avaliacao1" FOREIGN KEY ("classificacao") REFERENCES "public"."parametros_avaliacao"("cod_avaliacao");


--
-- PostgreSQL database dump complete
--

\unrestrict 1iNUBseuhBhghl8GojLPUgHfX6ze52Ih1MBIdM0BLTEMHPpb0KhBXx7cehLiF5h

