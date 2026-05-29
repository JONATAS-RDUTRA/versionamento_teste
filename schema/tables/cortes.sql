--
-- PostgreSQL database dump
--

\restrict KsJVgjTLVhfMv8D7IKKiMZ0Ic5cvUuiKsc83PeiBb5brWS1TtBKUumTuKnFWds4

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
-- Name: cortes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."cortes" (
    "idproduto" character varying(25) NOT NULL,
    "data" "date" NOT NULL,
    "qtde" numeric(12,4) DEFAULT 0 NOT NULL,
    "motivo" character varying(100)
);


--
-- Name: cortes pk_cortes; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cortes"
    ADD CONSTRAINT "pk_cortes" PRIMARY KEY ("idproduto", "data");


--
-- PostgreSQL database dump complete
--

\unrestrict KsJVgjTLVhfMv8D7IKKiMZ0Ic5cvUuiKsc83PeiBb5brWS1TtBKUumTuKnFWds4

