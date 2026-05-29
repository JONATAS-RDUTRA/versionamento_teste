--
-- PostgreSQL database dump
--

\restrict jYaNKAia9Wq5V32po3XuxeV3NxpxaPAAHlbdPJQAPFLYfBVZxHhcuDzopbRR3bB

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
-- Name: cotacao_representante_fornecedor; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."cotacao_representante_fornecedor" (
    "cotacao_representante_fornecedor_id" integer NOT NULL,
    "fornecedor_id" integer NOT NULL,
    "email" character varying(255),
    "telefone" character varying(255),
    "nome_representante" character varying(255),
    "cargo_representante" character varying(255)
);


--
-- Name: cotacao_representante_fornece_cotacao_representante_fornece_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."cotacao_representante_fornece_cotacao_representante_fornece_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cotacao_representante_fornece_cotacao_representante_fornece_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."cotacao_representante_fornece_cotacao_representante_fornece_seq" OWNED BY "public"."cotacao_representante_fornecedor"."cotacao_representante_fornecedor_id";


--
-- Name: cotacao_representante_fornecedor cotacao_representante_fornecedor_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cotacao_representante_fornecedor" ALTER COLUMN "cotacao_representante_fornecedor_id" SET DEFAULT "nextval"('"public"."cotacao_representante_fornece_cotacao_representante_fornece_seq"'::"regclass");


--
-- Name: cotacao_representante_fornecedor cotacao_representante_fornecedor_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cotacao_representante_fornecedor"
    ADD CONSTRAINT "cotacao_representante_fornecedor_pkey" PRIMARY KEY ("cotacao_representante_fornecedor_id");


--
-- Name: cotacao_representante_fornecedor cotacao_representante_fornecedor_fornecedor_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cotacao_representante_fornecedor"
    ADD CONSTRAINT "cotacao_representante_fornecedor_fornecedor_id_foreign" FOREIGN KEY ("fornecedor_id") REFERENCES "public"."fornecedor"("id");


--
-- PostgreSQL database dump complete
--

\unrestrict jYaNKAia9Wq5V32po3XuxeV3NxpxaPAAHlbdPJQAPFLYfBVZxHhcuDzopbRR3bB

