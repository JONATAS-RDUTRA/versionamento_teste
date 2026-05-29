--
-- PostgreSQL database dump
--

\restrict oDiceaGXPWNyRfkWPfFgP1cjKeoSNrInC9svzTEbGKCfhkjexFZYqvTgBKnBrnI

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
-- Name: motivo_blacklist_produto; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."motivo_blacklist_produto" (
    "id" integer NOT NULL,
    "descricao" character varying(200) NOT NULL
);


--
-- Name: motivo_blacklist_produto_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."motivo_blacklist_produto_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: motivo_blacklist_produto_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."motivo_blacklist_produto_id_seq" OWNED BY "public"."motivo_blacklist_produto"."id";


--
-- Name: motivo_blacklist_produto id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."motivo_blacklist_produto" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."motivo_blacklist_produto_id_seq"'::"regclass");


--
-- Name: motivo_blacklist_produto motivo_blacklist_prod; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."motivo_blacklist_produto"
    ADD CONSTRAINT "motivo_blacklist_prod" PRIMARY KEY ("id");


--
-- PostgreSQL database dump complete
--

\unrestrict oDiceaGXPWNyRfkWPfFgP1cjKeoSNrInC9svzTEbGKCfhkjexFZYqvTgBKnBrnI

