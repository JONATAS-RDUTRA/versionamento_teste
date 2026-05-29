--
-- PostgreSQL database dump
--

\restrict 5DGTsmA9D3mstH0BPes1bf5ahUG3bAMav8XpDIhsOrrdEJSY5XNAt1kSkaUV89p

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
-- Name: capa_listas_preco; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."capa_listas_preco" (
    "id" integer NOT NULL,
    "id_grupo" integer NOT NULL,
    "id_fornecedor" integer NOT NULL,
    "data_validade" "date" NOT NULL,
    "created_at" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "atualizar_preco_base_dados" boolean DEFAULT false
);


--
-- Name: capa_listas_preco_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."capa_listas_preco_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: capa_listas_preco_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."capa_listas_preco_id_seq" OWNED BY "public"."capa_listas_preco"."id";


--
-- Name: capa_listas_preco id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."capa_listas_preco" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."capa_listas_preco_id_seq"'::"regclass");


--
-- Name: capa_listas_preco pk_capa_listas_preco; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."capa_listas_preco"
    ADD CONSTRAINT "pk_capa_listas_preco" PRIMARY KEY ("id");


--
-- PostgreSQL database dump complete
--

\unrestrict 5DGTsmA9D3mstH0BPes1bf5ahUG3bAMav8XpDIhsOrrdEJSY5XNAt1kSkaUV89p

