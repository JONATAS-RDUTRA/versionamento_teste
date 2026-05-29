--
-- PostgreSQL database dump
--

\restrict MP2zUwtyyqi6czYkrAQmQzNir36M8BqqjA3QjsLYyfbJMoXkB1k8H11w3kLAnP6

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
-- Name: produtos_categoria_mp_pa; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."produtos_categoria_mp_pa" (
    "id_categoria" integer,
    "id_produto_mp" character varying(25),
    "id_produto_pa" character varying(25)
);


--
-- PostgreSQL database dump complete
--

\unrestrict MP2zUwtyyqi6czYkrAQmQzNir36M8BqqjA3QjsLYyfbJMoXkB1k8H11w3kLAnP6

