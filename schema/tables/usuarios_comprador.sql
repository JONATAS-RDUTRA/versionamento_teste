--
-- PostgreSQL database dump
--

\restrict KYLUM1apbouvmaTwRVrb69h3E1fr83nbN1IAjo6K43OmsUyDH0W3vJP8BSLeKGS

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
-- Name: usuarios_comprador; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."usuarios_comprador" (
    "id_usuario" bigint NOT NULL,
    "id_comprador" bigint NOT NULL
);


--
-- Name: usuarios_comprador usuarios_comprador_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."usuarios_comprador"
    ADD CONSTRAINT "usuarios_comprador_pkey" PRIMARY KEY ("id_usuario", "id_comprador");


--
-- PostgreSQL database dump complete
--

\unrestrict KYLUM1apbouvmaTwRVrb69h3E1fr83nbN1IAjo6K43OmsUyDH0W3vJP8BSLeKGS

