--
-- PostgreSQL database dump
--

\restrict CQkAeve4E1ma0hPdt0LBgrcAh6mGh7eYNqVthcoxb2D43h6gXEn6bxV84RKj3T5

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
-- Name: sys_produtos_comparacao; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."sys_produtos_comparacao" (
    "produto_pai" character varying NOT NULL,
    "id_usuario" integer NOT NULL,
    "idproduto" character varying NOT NULL,
    "data_modificacao" timestamp without time zone DEFAULT "now"()
);


--
-- PostgreSQL database dump complete
--

\unrestrict CQkAeve4E1ma0hPdt0LBgrcAh6mGh7eYNqVthcoxb2D43h6gXEn6bxV84RKj3T5

