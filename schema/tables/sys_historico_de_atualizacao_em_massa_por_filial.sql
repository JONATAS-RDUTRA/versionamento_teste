--
-- PostgreSQL database dump
--

\restrict ZGJW0RFIRRVJDBpuW9cv6sP0zfoKvNxMevEVIsULiSota9RPswlaMOF4iWlhE8w

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
-- Name: sys_historico_de_atualizacao_em_massa_por_filial; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."sys_historico_de_atualizacao_em_massa_por_filial" (
    "id" integer NOT NULL,
    "user_id" integer NOT NULL,
    "created_at" timestamp(0) without time zone,
    "updated_at" timestamp(0) without time zone
);


--
-- Name: sys_historico_de_atualizacao_em_massa_por_filial_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."sys_historico_de_atualizacao_em_massa_por_filial_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sys_historico_de_atualizacao_em_massa_por_filial_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."sys_historico_de_atualizacao_em_massa_por_filial_id_seq" OWNED BY "public"."sys_historico_de_atualizacao_em_massa_por_filial"."id";


--
-- Name: sys_historico_de_atualizacao_em_massa_por_filial id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."sys_historico_de_atualizacao_em_massa_por_filial" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."sys_historico_de_atualizacao_em_massa_por_filial_id_seq"'::"regclass");


--
-- Name: sys_historico_de_atualizacao_em_massa_por_filial sys_historico_de_atualizacao_em_massa_por_filial_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."sys_historico_de_atualizacao_em_massa_por_filial"
    ADD CONSTRAINT "sys_historico_de_atualizacao_em_massa_por_filial_pkey" PRIMARY KEY ("id");


--
-- Name: sys_historico_de_atualizacao_em_massa_por_filial sys_historico_de_atualizacao_em_massa_por_filial_user_id_foreig; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."sys_historico_de_atualizacao_em_massa_por_filial"
    ADD CONSTRAINT "sys_historico_de_atualizacao_em_massa_por_filial_user_id_foreig" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id");


--
-- PostgreSQL database dump complete
--

\unrestrict ZGJW0RFIRRVJDBpuW9cv6sP0zfoKvNxMevEVIsULiSota9RPswlaMOF4iWlhE8w

