--
-- PostgreSQL database dump
--

\restrict 6eCazEQDngziSA5IptU035AhffOVxqhqPIA0GxEbLsL6ZMMKQuqwXcTvOrw8dg6

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
-- Name: unidades_medida; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."unidades_medida" (
    "idunidade_medida" character varying(3) DEFAULT ''::character varying NOT NULL,
    "descricao_unidade" character varying(60)
);


--
-- Name: unidades_medida unidades_medida_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."unidades_medida"
    ADD CONSTRAINT "unidades_medida_pkey" PRIMARY KEY ("idunidade_medida");


--
-- PostgreSQL database dump complete
--

\unrestrict 6eCazEQDngziSA5IptU035AhffOVxqhqPIA0GxEbLsL6ZMMKQuqwXcTvOrw8dg6

