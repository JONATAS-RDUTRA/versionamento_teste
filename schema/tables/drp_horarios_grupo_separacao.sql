--
-- PostgreSQL database dump
--

\restrict YgBAMLe4HlwVAHhfM2hjoNKvedkaQ7oqUkYl0kMW2ezRkPMBIN3Ni6HfOPPeIN1

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
-- Name: drp_horarios_grupo_separacao; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."drp_horarios_grupo_separacao" (
    "id_grupo_separacao" integer NOT NULL,
    "horario" time without time zone NOT NULL,
    "created_at" character varying(30)
);


--
-- Name: drp_horarios_grupo_separacao drp_horarios_grupo_separacao_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."drp_horarios_grupo_separacao"
    ADD CONSTRAINT "drp_horarios_grupo_separacao_pk" PRIMARY KEY ("id_grupo_separacao", "horario");


--
-- Name: drp_horarios_grupo_separacao fk_id_drp_grupo_separacao; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."drp_horarios_grupo_separacao"
    ADD CONSTRAINT "fk_id_drp_grupo_separacao" FOREIGN KEY ("id_grupo_separacao") REFERENCES "public"."drp_grupo_separacao"("id");


--
-- PostgreSQL database dump complete
--

\unrestrict YgBAMLe4HlwVAHhfM2hjoNKvedkaQ7oqUkYl0kMW2ezRkPMBIN3Ni6HfOPPeIN1

