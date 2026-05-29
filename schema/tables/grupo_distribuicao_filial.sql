--
-- PostgreSQL database dump
--

\restrict XxG7Toe9cv7fWtm5XVdP8bb1sqUcAxgkI9tFeJ2wNhKtMBr8RaPOoHeqbfclcYD

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
-- Name: grupo_distribuicao_filial; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."grupo_distribuicao_filial" (
    "id_grupo" bigint NOT NULL,
    "filial" bigint NOT NULL,
    "data_cadastro" "date" DEFAULT ('now'::"text")::"date" NOT NULL
);


--
-- Name: grupo_distribuicao_filial grupo_dist_filial_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."grupo_distribuicao_filial"
    ADD CONSTRAINT "grupo_dist_filial_pk" PRIMARY KEY ("id_grupo", "filial");


--
-- PostgreSQL database dump complete
--

\unrestrict XxG7Toe9cv7fWtm5XVdP8bb1sqUcAxgkI9tFeJ2wNhKtMBr8RaPOoHeqbfclcYD

