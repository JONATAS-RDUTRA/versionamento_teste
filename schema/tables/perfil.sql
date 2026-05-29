--
-- PostgreSQL database dump
--

\restrict QFPGygg6OAzZgfo3PZWPYSjGFSTiFeZSmxJl6dKtXeunnLWPAfe6A4iLUITjxV2

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
-- Name: perfil; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."perfil" (
    "idperfil" integer DEFAULT "nextval"('"public"."perfil_idperfil_seq"'::"regclass") NOT NULL,
    "descricao_perfil" character varying(45),
    "admin" character varying(1) DEFAULT 'N'::character varying NOT NULL
);


--
-- Name: perfil perfil_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."perfil"
    ADD CONSTRAINT "perfil_pkey" PRIMARY KEY ("idperfil");


--
-- PostgreSQL database dump complete
--

\unrestrict QFPGygg6OAzZgfo3PZWPYSjGFSTiFeZSmxJl6dKtXeunnLWPAfe6A4iLUITjxV2

