--
-- PostgreSQL database dump
--

\restrict yQmIKY2ks4I6zX5fY64L6ub0lsAHQpF4dnwvn5qRdYhrCbXK1iQlWSuwBWmyQvh

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
-- Name: cotacao_integracao_erp; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."cotacao_integracao_erp" (
    "cotacao_integracao_erp_id" integer NOT NULL,
    "status_integracao_erp" character varying(35) NOT NULL
);


--
-- Name: cotacao_integracao_erp_cotacao_integracao_erp_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."cotacao_integracao_erp_cotacao_integracao_erp_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cotacao_integracao_erp_cotacao_integracao_erp_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."cotacao_integracao_erp_cotacao_integracao_erp_id_seq" OWNED BY "public"."cotacao_integracao_erp"."cotacao_integracao_erp_id";


--
-- Name: cotacao_integracao_erp cotacao_integracao_erp_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cotacao_integracao_erp" ALTER COLUMN "cotacao_integracao_erp_id" SET DEFAULT "nextval"('"public"."cotacao_integracao_erp_cotacao_integracao_erp_id_seq"'::"regclass");


--
-- Name: cotacao_integracao_erp cotacao_integracao_erp_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cotacao_integracao_erp"
    ADD CONSTRAINT "cotacao_integracao_erp_pkey" PRIMARY KEY ("cotacao_integracao_erp_id");


--
-- PostgreSQL database dump complete
--

\unrestrict yQmIKY2ks4I6zX5fY64L6ub0lsAHQpF4dnwvn5qRdYhrCbXK1iQlWSuwBWmyQvh

