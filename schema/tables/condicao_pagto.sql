--
-- PostgreSQL database dump
--

\restrict eI6mr2WSIT4T16srgyyHPdhBqwwUpKTPLvTGqoSBtWXKgwMwD0EE2G6QQFhcirH

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
-- Name: condicao_pagto; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."condicao_pagto" (
    "id" bigint NOT NULL,
    "descricao" character varying(100)
);


--
-- Name: condicao_pagto cond_pagto_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."condicao_pagto"
    ADD CONSTRAINT "cond_pagto_pk" PRIMARY KEY ("id");


--
-- PostgreSQL database dump complete
--

\unrestrict eI6mr2WSIT4T16srgyyHPdhBqwwUpKTPLvTGqoSBtWXKgwMwD0EE2G6QQFhcirH

