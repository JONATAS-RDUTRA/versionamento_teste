--
-- PostgreSQL database dump
--

\restrict QdNORMATqGWOxGkMeJyReJZN6uYFiUhEAa56tCirBlWT4ZRIaErXuy2TZbr7OuD

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
-- Name: parceiros; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."parceiros" (
    "idparceiro" integer DEFAULT "nextval"('"public"."parceiros_idparceiro_seq"'::"regclass") NOT NULL,
    "razao_social" character varying(60),
    "nome_fantasia" character varying(60),
    "cnpj" character varying(15),
    "prioridade" integer,
    "data_inicio" "date",
    "data_final" "date",
    "logomarca" character varying(120)
);


--
-- Name: parceiros parceiros_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."parceiros"
    ADD CONSTRAINT "parceiros_pkey" PRIMARY KEY ("idparceiro");


--
-- PostgreSQL database dump complete
--

\unrestrict QdNORMATqGWOxGkMeJyReJZN6uYFiUhEAa56tCirBlWT4ZRIaErXuy2TZbr7OuD

