--
-- PostgreSQL database dump
--

\restrict VmZcWVPsca1rsTrmUulWQTKmkgb5jzy0IIf9SGntJrPthAGXpltgpNtTVjUYgTK

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
-- Name: familias; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."familias" (
    "familia" character varying(255),
    "sub_familia" character varying(255),
    "noun" character varying(255),
    "modifier" character varying(255),
    "tipos_de_material" character varying(255)
);


--
-- PostgreSQL database dump complete
--

\unrestrict VmZcWVPsca1rsTrmUulWQTKmkgb5jzy0IIf9SGntJrPthAGXpltgpNtTVjUYgTK

