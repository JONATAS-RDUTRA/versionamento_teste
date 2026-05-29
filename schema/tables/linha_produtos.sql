--
-- PostgreSQL database dump
--

\restrict TJIrhOQYtpvsQ4AoRolaX9BpNGg35uPo7QFRIE07Lk1jSd2RHQE3lqgJyul6vfl

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
-- Name: linha_produtos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."linha_produtos" (
    "idlinhaprod" integer NOT NULL,
    "descricao_linhaprod" character varying(120),
    "com_movimento" character varying(1) DEFAULT 'S'::character varying
);


--
-- Name: linha_produtos_idlinhaprod_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."linha_produtos_idlinhaprod_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: linha_produtos_idlinhaprod_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."linha_produtos_idlinhaprod_seq" OWNED BY "public"."linha_produtos"."idlinhaprod";


--
-- Name: linha_produtos idlinhaprod; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."linha_produtos" ALTER COLUMN "idlinhaprod" SET DEFAULT "nextval"('"public"."linha_produtos_idlinhaprod_seq"'::"regclass");


--
-- Name: linha_produtos linhaprod_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."linha_produtos"
    ADD CONSTRAINT "linhaprod_pkey" PRIMARY KEY ("idlinhaprod");


--
-- PostgreSQL database dump complete
--

\unrestrict TJIrhOQYtpvsQ4AoRolaX9BpNGg35uPo7QFRIE07Lk1jSd2RHQE3lqgJyul6vfl

