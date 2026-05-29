--
-- PostgreSQL database dump
--

\restrict 0Tlol7aW57PuoKP8ay444TIH3k5XWh5Rebw1mET2MnJfUL8NdqjnDyk1pnPxWTT

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
-- Name: release_notes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."release_notes" (
    "id" integer NOT NULL,
    "versao" character varying(10) NOT NULL,
    "descricao" "text" NOT NULL
);


--
-- Name: release_notes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."release_notes_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: release_notes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."release_notes_id_seq" OWNED BY "public"."release_notes"."id";


--
-- Name: release_notes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."release_notes" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."release_notes_id_seq"'::"regclass");


--
-- Name: release_notes release_notes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."release_notes"
    ADD CONSTRAINT "release_notes_pkey" PRIMARY KEY ("id");


--
-- Name: release_notes versao_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."release_notes"
    ADD CONSTRAINT "versao_unique" UNIQUE ("versao");


--
-- PostgreSQL database dump complete
--

\unrestrict 0Tlol7aW57PuoKP8ay444TIH3k5XWh5Rebw1mET2MnJfUL8NdqjnDyk1pnPxWTT

