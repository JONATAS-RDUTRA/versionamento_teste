--
-- PostgreSQL database dump
--

\restrict gEW62mQgcEuotw2gIQsNNFEZnt33RVtBqw5LKv7Z8HGyLBIPMzhB5NGhhH7KGxO

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
-- Name: drp_automatico_emails; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."drp_automatico_emails" (
    "id_grupo_separacao" integer NOT NULL,
    "filial" integer NOT NULL,
    "email" character varying(255) NOT NULL,
    "tipo" integer NOT NULL
);


--
-- Name: drp_automatico_emails drp_automatico_emails_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."drp_automatico_emails"
    ADD CONSTRAINT "drp_automatico_emails_pk" PRIMARY KEY ("id_grupo_separacao", "filial", "email", "tipo");


--
-- PostgreSQL database dump complete
--

\unrestrict gEW62mQgcEuotw2gIQsNNFEZnt33RVtBqw5LKv7Z8HGyLBIPMzhB5NGhhH7KGxO

