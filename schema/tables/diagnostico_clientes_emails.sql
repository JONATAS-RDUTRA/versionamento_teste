--
-- PostgreSQL database dump
--

\restrict dhnWi8CrCURl2Ql5EzAP9Q63x4w0ukmanPLoedLfnQMmmih1Q9qGvmhQ40ouh6f

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
-- Name: diagnostico_clientes_emails; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."diagnostico_clientes_emails" (
    "id" integer NOT NULL,
    "email" character varying(100) NOT NULL
);


--
-- Name: diagnostico_clientes_emails_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."diagnostico_clientes_emails_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: diagnostico_clientes_emails_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."diagnostico_clientes_emails_id_seq" OWNED BY "public"."diagnostico_clientes_emails"."id";


--
-- Name: diagnostico_clientes_emails id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."diagnostico_clientes_emails" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."diagnostico_clientes_emails_id_seq"'::"regclass");


--
-- PostgreSQL database dump complete
--

\unrestrict dhnWi8CrCURl2Ql5EzAP9Q63x4w0ukmanPLoedLfnQMmmih1Q9qGvmhQ40ouh6f

