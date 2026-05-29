--
-- PostgreSQL database dump
--

\restrict o2raNESVcoKcAFoMnDzUWayfPcTNc6nxt1lxLVw5oW83d0XOX9CmUosENgKHBdz

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
-- Name: grupo_distribuicao; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."grupo_distribuicao" (
    "id" integer NOT NULL,
    "descricao" character varying(60),
    "filial_pedido" integer
);


--
-- Name: grupo_distribuicao_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."grupo_distribuicao_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: grupo_distribuicao_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."grupo_distribuicao_id_seq" OWNED BY "public"."grupo_distribuicao"."id";


--
-- Name: grupo_distribuicao id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."grupo_distribuicao" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."grupo_distribuicao_id_seq"'::"regclass");


--
-- Name: grupo_distribuicao grupo_distribuicao_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."grupo_distribuicao"
    ADD CONSTRAINT "grupo_distribuicao_pk" PRIMARY KEY ("id");


--
-- PostgreSQL database dump complete
--

\unrestrict o2raNESVcoKcAFoMnDzUWayfPcTNc6nxt1lxLVw5oW83d0XOX9CmUosENgKHBdz

