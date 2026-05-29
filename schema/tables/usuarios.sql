--
-- PostgreSQL database dump
--

\restrict Wrv7KORp7UxEjeJMqFqLi7hPqrzttYaO4ZzqdVjUu31wSsN38vLKMfdlpZc2sdv

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
-- Name: usuarios; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."usuarios" (
    "idusuario" integer DEFAULT "nextval"('"public"."usuarios_idusuario_seq"'::"regclass") NOT NULL,
    "nome_completo" character varying(60),
    "login" character varying(12),
    "email" character varying(60),
    "senha" character varying(45),
    "idperfil" integer NOT NULL,
    "last_login" timestamp without time zone,
    "first_acess" smallint DEFAULT 0,
    "reg_status" character varying(1) DEFAULT 'A'::character varying,
    "forgotten_password_code" character varying(45),
    "forgotten_password_time" integer,
    "imagem" character varying(200)
);


--
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."usuarios"
    ADD CONSTRAINT "usuarios_pkey" PRIMARY KEY ("idusuario");


--
-- Name: email_UNIQUE; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "email_UNIQUE" ON "public"."usuarios" USING "btree" ("email");


--
-- Name: fk_usuarios_perfil1_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "fk_usuarios_perfil1_idx" ON "public"."usuarios" USING "btree" ("idperfil");


--
-- Name: flag_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "flag_idx" ON "public"."usuarios" USING "btree" ("reg_status");


--
-- Name: usuarios fk_usuarios_perfil1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."usuarios"
    ADD CONSTRAINT "fk_usuarios_perfil1" FOREIGN KEY ("idperfil") REFERENCES "public"."perfil"("idperfil");


--
-- PostgreSQL database dump complete
--

\unrestrict Wrv7KORp7UxEjeJMqFqLi7hPqrzttYaO4ZzqdVjUu31wSsN38vLKMfdlpZc2sdv

