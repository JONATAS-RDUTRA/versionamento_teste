--
-- PostgreSQL database dump
--

\restrict KcKjeINc1zonZUuADb9tI2WjfgoAaKe2mL5gcGPhkJ6VvzhGS7qb8HTC1Obbvnx

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
-- Name: categorias_distribuicao_filial; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."categorias_distribuicao_filial" (
    "id" integer NOT NULL,
    "filial" bigint NOT NULL,
    "id_categoria" character varying(25) NOT NULL,
    "created_at" character varying(30) DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: categorias_distribuicao_filial_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."categorias_distribuicao_filial_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categorias_distribuicao_filial_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."categorias_distribuicao_filial_id_seq" OWNED BY "public"."categorias_distribuicao_filial"."id";


--
-- Name: categorias_distribuicao_filial id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."categorias_distribuicao_filial" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."categorias_distribuicao_filial_id_seq"'::"regclass");


--
-- Name: categorias_distribuicao_filial categorias_distribuicao_filial_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."categorias_distribuicao_filial"
    ADD CONSTRAINT "categorias_distribuicao_filial_pkey" PRIMARY KEY ("id");


--
-- Name: categorias_distribuicao_filial filial_categoria_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."categorias_distribuicao_filial"
    ADD CONSTRAINT "filial_categoria_unique" UNIQUE ("filial", "id_categoria");


--
-- PostgreSQL database dump complete
--

\unrestrict KcKjeINc1zonZUuADb9tI2WjfgoAaKe2mL5gcGPhkJ6VvzhGS7qb8HTC1Obbvnx

