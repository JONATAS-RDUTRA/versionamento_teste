--
-- PostgreSQL database dump
--

\restrict hHRpad7B9a2AhDUYop8ER9DezSYDcL8gzkmFqmv9VgqznvtqK8COZh3cz5o4EGb

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
-- Name: status_consumos_para_ocultar; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."status_consumos_para_ocultar" (
    "id" integer NOT NULL,
    "descricao" character varying(5) NOT NULL
);


--
-- Name: status_consumos_para_ocultar_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."status_consumos_para_ocultar_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: status_consumos_para_ocultar_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."status_consumos_para_ocultar_id_seq" OWNED BY "public"."status_consumos_para_ocultar"."id";


--
-- Name: status_consumos_para_ocultar id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."status_consumos_para_ocultar" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."status_consumos_para_ocultar_id_seq"'::"regclass");


--
-- PostgreSQL database dump complete
--

\unrestrict hHRpad7B9a2AhDUYop8ER9DezSYDcL8gzkmFqmv9VgqznvtqK8COZh3cz5o4EGb

