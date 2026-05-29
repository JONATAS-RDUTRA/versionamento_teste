--
-- PostgreSQL database dump
--

\restrict kvXj4FwoYx1KtsesTjOre6Q118H7BPeawHdm4gIU1zBPew6UcojxzmuYoRdTP4n

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
-- Name: ddl_changelog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."ddl_changelog" (
    "id" bigint NOT NULL,
    "data_exec" timestamp without time zone DEFAULT "now"(),
    "usuario" "text",
    "comando" "text",
    "tipo_objeto" "text",
    "objeto" "text",
    "schema_nome" "text",
    "sql_original" "text"
);


--
-- Name: ddl_changelog_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."ddl_changelog_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ddl_changelog_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."ddl_changelog_id_seq" OWNED BY "public"."ddl_changelog"."id";


--
-- Name: ddl_changelog id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."ddl_changelog" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."ddl_changelog_id_seq"'::"regclass");


--
-- Name: ddl_changelog ddl_changelog_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."ddl_changelog"
    ADD CONSTRAINT "ddl_changelog_pkey" PRIMARY KEY ("id");


--
-- PostgreSQL database dump complete
--

\unrestrict kvXj4FwoYx1KtsesTjOre6Q118H7BPeawHdm4gIU1zBPew6UcojxzmuYoRdTP4n

