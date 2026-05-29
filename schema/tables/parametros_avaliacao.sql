--
-- PostgreSQL database dump
--

\restrict SMiMNuDFyZ81naM6vDJm5QmDnsVyRTBeismjWpnqwaBgOaJCXod6he8GVlngl3s

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
-- Name: parametros_avaliacao; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."parametros_avaliacao" (
    "cod_avaliacao" character varying(1) DEFAULT ''::character varying NOT NULL,
    "descricao_avaliacao" "text"
);


--
-- Name: parametros_avaliacao parametros_avaliacao_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."parametros_avaliacao"
    ADD CONSTRAINT "parametros_avaliacao_pkey" PRIMARY KEY ("cod_avaliacao");


--
-- PostgreSQL database dump complete
--

\unrestrict SMiMNuDFyZ81naM6vDJm5QmDnsVyRTBeismjWpnqwaBgOaJCXod6he8GVlngl3s

