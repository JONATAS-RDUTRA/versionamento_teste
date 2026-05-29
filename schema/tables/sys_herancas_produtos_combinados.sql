--
-- PostgreSQL database dump
--

\restrict lJVCrayYJRhhqB2z4AtznKGeRlWElw2wycFaPz5HTFmEznbifp4dJMnWLQ1QHlL

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
-- Name: sys_herancas_produtos_combinados; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."sys_herancas_produtos_combinados" (
    "id_produto_combinado" character varying(36) NOT NULL,
    "idproduto_heranca" character varying(36) NOT NULL,
    "tipo_heranca" integer NOT NULL,
    "created_at" character varying(30) DEFAULT "now"() NOT NULL
);


--
-- Name: sys_herancas_produtos_combinados sys_herancas_produtos_combinados_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."sys_herancas_produtos_combinados"
    ADD CONSTRAINT "sys_herancas_produtos_combinados_pkey" PRIMARY KEY ("id_produto_combinado");


--
-- PostgreSQL database dump complete
--

\unrestrict lJVCrayYJRhhqB2z4AtznKGeRlWElw2wycFaPz5HTFmEznbifp4dJMnWLQ1QHlL

