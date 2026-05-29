--
-- PostgreSQL database dump
--

\restrict cGsWpj1klmUmNvQZz5Km9VNMh2tB2wbufKFpan4J9gwPzxWms2KMCVoas0jSMc4

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
-- Name: sys_produtos_importados_em_massa_por_filial; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."sys_produtos_importados_em_massa_por_filial" (
    "id" integer NOT NULL,
    "historico_id" integer NOT NULL,
    "filial_id" character varying(255) NOT NULL,
    "produto_id" character varying(255) NOT NULL,
    "estoque_minimo" double precision NOT NULL,
    "estoque_seguranca" double precision NOT NULL,
    "ponto_pedido" double precision NOT NULL,
    "estoque_maximo" double precision NOT NULL,
    "created_at" timestamp(0) without time zone,
    "updated_at" timestamp(0) without time zone
);


--
-- Name: sys_produtos_importados_em_massa_por_filial_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."sys_produtos_importados_em_massa_por_filial_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sys_produtos_importados_em_massa_por_filial_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."sys_produtos_importados_em_massa_por_filial_id_seq" OWNED BY "public"."sys_produtos_importados_em_massa_por_filial"."id";


--
-- Name: sys_produtos_importados_em_massa_por_filial id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."sys_produtos_importados_em_massa_por_filial" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."sys_produtos_importados_em_massa_por_filial_id_seq"'::"regclass");


--
-- Name: sys_produtos_importados_em_massa_por_filial sys_produtos_importados_em_massa_por_filial_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."sys_produtos_importados_em_massa_por_filial"
    ADD CONSTRAINT "sys_produtos_importados_em_massa_por_filial_pkey" PRIMARY KEY ("id");


--
-- Name: sys_produtos_importados_em_massa_por_filial sys_produtos_importados_em_massa_por_filial_historico_id_foreig; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."sys_produtos_importados_em_massa_por_filial"
    ADD CONSTRAINT "sys_produtos_importados_em_massa_por_filial_historico_id_foreig" FOREIGN KEY ("historico_id") REFERENCES "public"."sys_historico_de_atualizacao_em_massa_por_filial"("id");


--
-- PostgreSQL database dump complete
--

\unrestrict cGsWpj1klmUmNvQZz5Km9VNMh2tB2wbufKFpan4J9gwPzxWms2KMCVoas0jSMc4

