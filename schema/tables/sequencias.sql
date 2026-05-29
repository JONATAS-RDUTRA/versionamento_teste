--
-- PostgreSQL database dump
--

\restrict thQQF4egDLVmy0bEKm9uyYg2X2zvR0xx8u5GczOF0AN4C4VcmKKGTflgStXvz0r

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
-- Name: sequencias; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."sequencias" (
    "idsequencia" character varying(25) NOT NULL,
    "sequencia" integer
);


--
-- Name: sequencias sequencias_pk_ressuprimentos; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."sequencias"
    ADD CONSTRAINT "sequencias_pk_ressuprimentos" PRIMARY KEY ("idsequencia");


--
-- PostgreSQL database dump complete
--

\unrestrict thQQF4egDLVmy0bEKm9uyYg2X2zvR0xx8u5GczOF0AN4C4VcmKKGTflgStXvz0r

