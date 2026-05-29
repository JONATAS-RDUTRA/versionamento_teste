--
-- PostgreSQL database dump
--

\restrict MW8NCmqs33g61MntXQNxwAzxf46ji5YO7dfnvKAmN56p7jXHXq60GFZUPxkz2TU

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
-- Name: questionario_criticidade; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."questionario_criticidade" (
    "idquestionario" integer DEFAULT "nextval"('"public"."questionario_criticidade_idquestionario_seq"'::"regclass") NOT NULL,
    "pergunta" "text"
);


--
-- Name: questionario_criticidade questionario_criticidade_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."questionario_criticidade"
    ADD CONSTRAINT "questionario_criticidade_pkey" PRIMARY KEY ("idquestionario");


--
-- PostgreSQL database dump complete
--

\unrestrict MW8NCmqs33g61MntXQNxwAzxf46ji5YO7dfnvKAmN56p7jXHXq60GFZUPxkz2TU

