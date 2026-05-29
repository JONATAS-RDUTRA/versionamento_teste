--
-- PostgreSQL database dump
--

\restrict UT4oP46vWRljGMDufa9FK27LsOqIcAW69PAQY72JTDS1eYXEABYMxnewX4sreTR

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
-- Name: sys_justificativas_mix_filiais; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."sys_justificativas_mix_filiais" (
    "id" bigint NOT NULL,
    "id_usuario" integer NOT NULL,
    "justificativa" "text" NOT NULL,
    "payload" "json",
    "created_at" timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: sys_justificativas_mix_filiais_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."sys_justificativas_mix_filiais_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sys_justificativas_mix_filiais_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."sys_justificativas_mix_filiais_id_seq" OWNED BY "public"."sys_justificativas_mix_filiais"."id";


--
-- Name: sys_justificativas_mix_filiais id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."sys_justificativas_mix_filiais" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."sys_justificativas_mix_filiais_id_seq"'::"regclass");


--
-- Name: sys_justificativas_mix_filiais sys_justificativas_mix_filiais_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."sys_justificativas_mix_filiais"
    ADD CONSTRAINT "sys_justificativas_mix_filiais_pkey" PRIMARY KEY ("id");


--
-- PostgreSQL database dump complete
--

\unrestrict UT4oP46vWRljGMDufa9FK27LsOqIcAW69PAQY72JTDS1eYXEABYMxnewX4sreTR

