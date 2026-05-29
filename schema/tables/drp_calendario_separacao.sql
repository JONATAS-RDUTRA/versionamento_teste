--
-- PostgreSQL database dump
--

\restrict 9e7FONh7jWsDTNil6nqJxaMEp4dn7shZEK6o4Krg1BRzSn9jmjSPQ5H7mf99x35

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
-- Name: drp_calendario_separacao; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."drp_calendario_separacao" (
    "id" integer NOT NULL,
    "id_grupo_sep" bigint NOT NULL,
    "start" "date",
    "timed" boolean DEFAULT true,
    "status" character varying(15),
    "details" "text"
);


--
-- Name: drp_calendario_separacao_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."drp_calendario_separacao_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: drp_calendario_separacao_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."drp_calendario_separacao_id_seq" OWNED BY "public"."drp_calendario_separacao"."id";


--
-- Name: drp_calendario_separacao id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."drp_calendario_separacao" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."drp_calendario_separacao_id_seq"'::"regclass");


--
-- Name: drp_calendario_separacao calendario_separacao_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."drp_calendario_separacao"
    ADD CONSTRAINT "calendario_separacao_pk" PRIMARY KEY ("id");


--
-- PostgreSQL database dump complete
--

\unrestrict 9e7FONh7jWsDTNil6nqJxaMEp4dn7shZEK6o4Krg1BRzSn9jmjSPQ5H7mf99x35

