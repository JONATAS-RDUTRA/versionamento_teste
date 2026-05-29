--
-- PostgreSQL database dump
--

\restrict h1naaRgFRsQ4gJeHZVNzzyoa36JAfamrK6aoaTImAJieqV6wcvFuOm8aErThh5s

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
-- Name: categorias; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."categorias" (
    "idcategoria" integer NOT NULL,
    "descricao_categoria" character varying(45),
    "idsecao" bigint,
    "tempo_forecast" integer
);


--
-- Name: categorias_idcategoria_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."categorias_idcategoria_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categorias_idcategoria_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."categorias_idcategoria_seq" OWNED BY "public"."categorias"."idcategoria";


--
-- Name: categorias idcategoria; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."categorias" ALTER COLUMN "idcategoria" SET DEFAULT "nextval"('"public"."categorias_idcategoria_seq"'::"regclass");


--
-- Name: categorias categoria_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."categorias"
    ADD CONSTRAINT "categoria_pkey" PRIMARY KEY ("idcategoria");


--
-- PostgreSQL database dump complete
--

\unrestrict h1naaRgFRsQ4gJeHZVNzzyoa36JAfamrK6aoaTImAJieqV6wcvFuOm8aErThh5s

