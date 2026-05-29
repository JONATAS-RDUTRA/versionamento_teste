--
-- PostgreSQL database dump
--

\restrict aqg10cvyuYMpGj4UWMS17Qy38sqaSyNzwLOAzZhgCcV8SGkGSWBFzIRtKsDzHpW

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
-- Name: config_notificacao_email; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."config_notificacao_email" (
    "host" character varying(100) NOT NULL,
    "user_name" character varying(100) NOT NULL,
    "password" character varying(40) NOT NULL,
    "port" integer NOT NULL,
    "from" character varying(100) NOT NULL,
    "from_descricao" character varying(60) NOT NULL,
    "id_user" bigint DEFAULT 0 NOT NULL
);


--
-- Name: config_notificacao_email config_notificacao_email_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."config_notificacao_email"
    ADD CONSTRAINT "config_notificacao_email_pk" PRIMARY KEY ("id_user", "from");


--
-- PostgreSQL database dump complete
--

\unrestrict aqg10cvyuYMpGj4UWMS17Qy38sqaSyNzwLOAzZhgCcV8SGkGSWBFzIRtKsDzHpW

