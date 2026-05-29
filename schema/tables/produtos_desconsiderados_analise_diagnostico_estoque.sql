--
-- PostgreSQL database dump
--

\restrict gbFhA6BQ3YklV4tLQrQN0qulyz7fJ1ReyV7xSbh0yMvRTbMbEG9ft2MX8sIXeGA

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
-- Name: produtos_desconsiderados_analise_diagnostico_estoque; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."produtos_desconsiderados_analise_diagnostico_estoque" (
    "idproduto" character varying(25) NOT NULL
);


--
-- Name: produtos_desconsiderados_analise_diagnostico_estoque produtos_desconsiderados_analise_diagnostico_estoque_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."produtos_desconsiderados_analise_diagnostico_estoque"
    ADD CONSTRAINT "produtos_desconsiderados_analise_diagnostico_estoque_pk" PRIMARY KEY ("idproduto");


--
-- PostgreSQL database dump complete
--

\unrestrict gbFhA6BQ3YklV4tLQrQN0qulyz7fJ1ReyV7xSbh0yMvRTbMbEG9ft2MX8sIXeGA

