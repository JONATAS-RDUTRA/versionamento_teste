--
-- PostgreSQL database dump
--

\restrict c9xXwLKnamPwmCu8hWTxPvXYzC6INc5tScsPUoTsLJzmkmFkosOAr4vDZfpHbqY

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
-- Name: ddl_queue; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."ddl_queue" (
    "schema_nome" "text" NOT NULL,
    "objeto" "text" NOT NULL,
    "tipo_objeto" "text",
    "comando" "text",
    "usuario" "text",
    "ultima_alteracao" timestamp without time zone DEFAULT "now"(),
    "processado" boolean DEFAULT false
);


--
-- Name: ddl_queue ddl_queue_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."ddl_queue"
    ADD CONSTRAINT "ddl_queue_pkey" PRIMARY KEY ("schema_nome", "objeto");


--
-- Name: idx_ddl_queue_processado; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "idx_ddl_queue_processado" ON "public"."ddl_queue" USING "btree" ("processado", "ultima_alteracao");


--
-- PostgreSQL database dump complete
--

\unrestrict c9xXwLKnamPwmCu8hWTxPvXYzC6INc5tScsPUoTsLJzmkmFkosOAr4vDZfpHbqY

