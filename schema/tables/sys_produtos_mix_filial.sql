--
-- PostgreSQL database dump
--

\restrict BlPbqiVWu8CFGq6a1U5FLUeYdU7FkRMbJNExHSznVefAMBkxBZT0pkoyFqyhI89

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
-- Name: sys_produtos_mix_filial; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."sys_produtos_mix_filial" (
    "filial" integer NOT NULL,
    "idproduto" character varying(25) DEFAULT ''::character varying NOT NULL,
    "pertence_ao_mix" character varying(1) DEFAULT 'S'::character varying NOT NULL,
    "movimentacao" character varying(15) DEFAULT 'PROPRIA'::character varying NOT NULL,
    "filial_origem" numeric
);


--
-- Name: sys_produtos_mix_filial sys_produtos_mix_filial_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."sys_produtos_mix_filial"
    ADD CONSTRAINT "sys_produtos_mix_filial_pkey" PRIMARY KEY ("filial", "idproduto");


--
-- PostgreSQL database dump complete
--

\unrestrict BlPbqiVWu8CFGq6a1U5FLUeYdU7FkRMbJNExHSznVefAMBkxBZT0pkoyFqyhI89

