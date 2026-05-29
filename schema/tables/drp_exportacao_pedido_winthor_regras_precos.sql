--
-- PostgreSQL database dump
--

\restrict izRLGyygnjLvAqMXlE6QklPNplbeJ2nwTLjKdqFbHkSmWtEQgNZM0xTmafuqF2G

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
-- Name: drp_exportacao_pedido_winthor_regras_precos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."drp_exportacao_pedido_winthor_regras_precos" (
    "id" integer NOT NULL,
    "filial_origem" bigint NOT NULL,
    "filial_destino" bigint NOT NULL,
    "tabela_oracle" character varying NOT NULL,
    "campo_oracle" character varying(50) NOT NULL
);


--
-- Name: drp_exportacao_pedido_winthor_regras_precos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."drp_exportacao_pedido_winthor_regras_precos_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: drp_exportacao_pedido_winthor_regras_precos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."drp_exportacao_pedido_winthor_regras_precos_id_seq" OWNED BY "public"."drp_exportacao_pedido_winthor_regras_precos"."id";


--
-- Name: drp_exportacao_pedido_winthor_regras_precos id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."drp_exportacao_pedido_winthor_regras_precos" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."drp_exportacao_pedido_winthor_regras_precos_id_seq"'::"regclass");


--
-- Name: drp_exportacao_pedido_winthor_regras_precos drp_exportacao_pedido_winthor_regras_precos_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."drp_exportacao_pedido_winthor_regras_precos"
    ADD CONSTRAINT "drp_exportacao_pedido_winthor_regras_precos_pk" PRIMARY KEY ("id");


--
-- PostgreSQL database dump complete
--

\unrestrict izRLGyygnjLvAqMXlE6QklPNplbeJ2nwTLjKdqFbHkSmWtEQgNZM0xTmafuqF2G

