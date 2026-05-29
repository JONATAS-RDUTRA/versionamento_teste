--
-- PostgreSQL database dump
--

\restrict ywNSFFDjyfyehN7icYqH1elS16ezIrkxZv0s6zNVxlOg54NBXMq81WoCpe91dxe

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
-- Name: tempo; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."tempo" (
    "codtempo" integer NOT NULL,
    "ano" integer NOT NULL,
    "mes" integer NOT NULL
);


--
-- Name: tempo tempo_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."tempo"
    ADD CONSTRAINT "tempo_pkey" PRIMARY KEY ("codtempo");


--
-- PostgreSQL database dump complete
--

\unrestrict ywNSFFDjyfyehN7icYqH1elS16ezIrkxZv0s6zNVxlOg54NBXMq81WoCpe91dxe

