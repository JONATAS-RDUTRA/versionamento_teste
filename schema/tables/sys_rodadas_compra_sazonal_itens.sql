--
-- PostgreSQL database dump
--

\restrict N4P3WGPjx2WPeCHUtyfzAmBo501jcuomUVSoj8TnSEDL3qu733Y27NCbOl4Vvkm

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
-- Name: sys_rodadas_compra_sazonal_itens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."sys_rodadas_compra_sazonal_itens" (
    "id" bigint NOT NULL,
    "id_rodada_compra" integer NOT NULL,
    "filial" integer NOT NULL,
    "idproduto" character varying(25) NOT NULL,
    "created_at" timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: sys_rodadas_compra_sazonal_itens_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."sys_rodadas_compra_sazonal_itens_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sys_rodadas_compra_sazonal_itens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."sys_rodadas_compra_sazonal_itens_id_seq" OWNED BY "public"."sys_rodadas_compra_sazonal_itens"."id";


--
-- Name: sys_rodadas_compra_sazonal_itens id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."sys_rodadas_compra_sazonal_itens" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."sys_rodadas_compra_sazonal_itens_id_seq"'::"regclass");


--
-- Name: sys_rodadas_compra_sazonal_itens sys_rodadas_compra_sazonal_itens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."sys_rodadas_compra_sazonal_itens"
    ADD CONSTRAINT "sys_rodadas_compra_sazonal_itens_pkey" PRIMARY KEY ("id");


--
-- Name: sys_rodadas_compra_sazonal_itens sys_rodadas_compra_sazonal_itens_rodadas_compra_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."sys_rodadas_compra_sazonal_itens"
    ADD CONSTRAINT "sys_rodadas_compra_sazonal_itens_rodadas_compra_fkey" FOREIGN KEY ("id_rodada_compra") REFERENCES "public"."sys_rodadas_compra_sazonal"("id");


--
-- PostgreSQL database dump complete
--

\unrestrict N4P3WGPjx2WPeCHUtyfzAmBo501jcuomUVSoj8TnSEDL3qu733Y27NCbOl4Vvkm

