--
-- PostgreSQL database dump
--

\restrict sZZkhj9u5JGSb5gtaLIQPVjCaS0vd0rZTXRKdJIwGYj88KKfJzppREJKMdYmmx3

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
-- Name: drp_calendario_separacao_feriados; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."drp_calendario_separacao_feriados" (
    "data_feriado" "date" NOT NULL,
    "recorrente" boolean
);


--
-- Name: drp_calendario_separacao_feriados drp_calendario_separacao_feriados_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."drp_calendario_separacao_feriados"
    ADD CONSTRAINT "drp_calendario_separacao_feriados_pkey" PRIMARY KEY ("data_feriado");


--
-- PostgreSQL database dump complete
--

\unrestrict sZZkhj9u5JGSb5gtaLIQPVjCaS0vd0rZTXRKdJIwGYj88KKfJzppREJKMdYmmx3

