--
-- PostgreSQL database dump
--

\restrict FGvJ7I9nZWg0GfFR8ZcCrOX3bk9Rl4ZrNqcWim0RnNbLav8TXmukLT54lwVRNAG

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
-- Name: distribuicao_drp_exportacao_erp; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."distribuicao_drp_exportacao_erp" (
    "idpedido" bigint NOT NULL,
    "exportacao" "json" NOT NULL,
    "data_exportacao" "date" DEFAULT ('now'::"text")::"date" NOT NULL,
    "erp" character varying(15),
    "extra" "json" DEFAULT '{}'::"json" NOT NULL
);


--
-- Name: distribuicao_drp_exportacao_erp pk_distribuicao_drp_exportacao_erp; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."distribuicao_drp_exportacao_erp"
    ADD CONSTRAINT "pk_distribuicao_drp_exportacao_erp" PRIMARY KEY ("idpedido");


--
-- PostgreSQL database dump complete
--

\unrestrict FGvJ7I9nZWg0GfFR8ZcCrOX3bk9Rl4ZrNqcWim0RnNbLav8TXmukLT54lwVRNAG

