--
-- PostgreSQL database dump
--

\restrict QhIxlbIINqexHhA0itRnfc9j4ro9SFRbVfTRhz2xJrcTQpojpmAAgE80xBNXrhL

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
-- Name: comprador; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."comprador" (
    "id" bigint NOT NULL,
    "nome_completo" character varying(100),
    "cod_sistema" character varying(25),
    "user_id" integer
);


--
-- Name: comprador comprador_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."comprador"
    ADD CONSTRAINT "comprador_pkey" PRIMARY KEY ("id");


--
-- PostgreSQL database dump complete
--

\unrestrict QhIxlbIINqexHhA0itRnfc9j4ro9SFRbVfTRhz2xJrcTQpojpmAAgE80xBNXrhL

