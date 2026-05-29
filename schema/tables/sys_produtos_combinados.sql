--
-- PostgreSQL database dump
--

\restrict dMY1V2ybzHhWn9DxhMPagpztAcQjDksbheKA9MmkHycSAeJeoNX7wIGchDOjIHT

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
-- Name: sys_produtos_combinados; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."sys_produtos_combinados" (
    "id" character varying(36) DEFAULT ('SYSCOMB'::"text" || "nextval"('"public"."sys_produtos_combinados_sequence"'::"regclass")) NOT NULL,
    "descricao" character varying(150) NOT NULL,
    "created_at" character varying(30) DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "deleted_at" character varying(30)
);


--
-- Name: sys_produtos_combinados pk_sys_produtos_combinados; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."sys_produtos_combinados"
    ADD CONSTRAINT "pk_sys_produtos_combinados" PRIMARY KEY ("id");


--
-- PostgreSQL database dump complete
--

\unrestrict dMY1V2ybzHhWn9DxhMPagpztAcQjDksbheKA9MmkHycSAeJeoNX7wIGchDOjIHT

