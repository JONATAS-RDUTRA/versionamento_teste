--
-- PostgreSQL database dump
--

\restrict xu5E4H6UwPzVMXcEeqHmLXr7HprQAh1wt9WRaJ3g0oUYt5mr9bFbMWl1tcu9dh1

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
-- Name: mapa_compra; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."mapa_compra" (
    "filial" integer NOT NULL,
    "filial_cd" integer NOT NULL
);


--
-- Name: mapa_compra mapa_compra_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."mapa_compra"
    ADD CONSTRAINT "mapa_compra_pk" PRIMARY KEY ("filial", "filial_cd");


--
-- PostgreSQL database dump complete
--

\unrestrict xu5E4H6UwPzVMXcEeqHmLXr7HprQAh1wt9WRaJ3g0oUYt5mr9bFbMWl1tcu9dh1

