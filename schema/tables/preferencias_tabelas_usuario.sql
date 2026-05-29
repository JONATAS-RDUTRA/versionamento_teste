--
-- PostgreSQL database dump
--

\restrict eGJ8yOdmNz5FOSLr0wJq4ijuZLuOOzHsUX4YWGYoAfEan9eOEikU1Hg1Yk5Jddt

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
-- Name: preferencias_tabelas_usuario; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."preferencias_tabelas_usuario" (
    "id_tabela" character varying(100) NOT NULL,
    "id_usuario" integer NOT NULL,
    "preferencias" "json" NOT NULL
);


--
-- Name: preferencias_tabelas_usuario preferencias_tabelas_usuario_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."preferencias_tabelas_usuario"
    ADD CONSTRAINT "preferencias_tabelas_usuario_pk" PRIMARY KEY ("id_tabela", "id_usuario");


--
-- Name: preferencias_tabelas_usuario user_preferencias_tabelas_usuario_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."preferencias_tabelas_usuario"
    ADD CONSTRAINT "user_preferencias_tabelas_usuario_fk" FOREIGN KEY ("id_usuario") REFERENCES "public"."users"("id");


--
-- PostgreSQL database dump complete
--

\unrestrict eGJ8yOdmNz5FOSLr0wJq4ijuZLuOOzHsUX4YWGYoAfEan9eOEikU1Hg1Yk5Jddt

