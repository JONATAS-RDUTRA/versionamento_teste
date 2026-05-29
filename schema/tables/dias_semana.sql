--
-- PostgreSQL database dump
--

\restrict 0rDDfXTBmVuLJbDLJNd32adl99uY1grrMAHOqHBH2pDZuILabtn3tIfo4JPMrzU

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
-- Name: dias_semana; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."dias_semana" (
    "dia_semana_id" smallint NOT NULL,
    "nome" character varying(20) NOT NULL,
    "abreviacao" character varying(3) NOT NULL
);


--
-- Name: dias_semana dias_semana_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."dias_semana"
    ADD CONSTRAINT "dias_semana_pkey" PRIMARY KEY ("dia_semana_id");


--
-- PostgreSQL database dump complete
--

\unrestrict 0rDDfXTBmVuLJbDLJNd32adl99uY1grrMAHOqHBH2pDZuILabtn3tIfo4JPMrzU

