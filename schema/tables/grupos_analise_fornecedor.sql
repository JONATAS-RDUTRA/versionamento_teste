--
-- PostgreSQL database dump
--

\restrict eq3gEendeXYTzsT9c8Q6BGf6UV42Xy9Uy5tmjWTPBv5nqvP6EQ1dy4GDV71bqkx

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
-- Name: grupos_analise_fornecedor; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."grupos_analise_fornecedor" (
    "id" integer NOT NULL,
    "nome" character varying(50) NOT NULL,
    "created_at" character varying(30),
    "updated_at" character varying(30),
    "deleted_at" character varying(30),
    "observacao" "text"
);


--
-- Name: grupos_analise_fornecedor_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."grupos_analise_fornecedor_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: grupos_analise_fornecedor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."grupos_analise_fornecedor_id_seq" OWNED BY "public"."grupos_analise_fornecedor"."id";


--
-- Name: grupos_analise_fornecedor id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."grupos_analise_fornecedor" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."grupos_analise_fornecedor_id_seq"'::"regclass");


--
-- Name: grupos_analise_fornecedor grupos_analise_fornecedor_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."grupos_analise_fornecedor"
    ADD CONSTRAINT "grupos_analise_fornecedor_pk" PRIMARY KEY ("id");


--
-- PostgreSQL database dump complete
--

\unrestrict eq3gEendeXYTzsT9c8Q6BGf6UV42Xy9Uy5tmjWTPBv5nqvP6EQ1dy4GDV71bqkx

