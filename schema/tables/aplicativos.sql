--
-- PostgreSQL database dump
--

\restrict hIE17Kh3mnQ1mO9mq3jW82ilcKY3j805C979g20MwAfJe0UTg4iLkZkmtCQacrb

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
-- Name: aplicativos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."aplicativos" (
    "idaplicativo" integer DEFAULT "nextval"('"public"."aplicativos_idaplicativo_seq"'::"regclass") NOT NULL,
    "descricao_aplicativo" character varying(60),
    "src_aplicativo" character varying(60),
    "idmodulo" integer NOT NULL,
    "rota" boolean DEFAULT false NOT NULL,
    "menu" boolean DEFAULT true NOT NULL
);


--
-- Name: aplicativos aplicativos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."aplicativos"
    ADD CONSTRAINT "aplicativos_pkey" PRIMARY KEY ("idaplicativo");


--
-- Name: fk_aplicativos_modulos1_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "fk_aplicativos_modulos1_idx" ON "public"."aplicativos" USING "btree" ("idmodulo");


--
-- Name: aplicativos fk_aplicativos_modulos1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."aplicativos"
    ADD CONSTRAINT "fk_aplicativos_modulos1" FOREIGN KEY ("idmodulo") REFERENCES "public"."modulos"("idmodulo");


--
-- PostgreSQL database dump complete
--

\unrestrict hIE17Kh3mnQ1mO9mq3jW82ilcKY3j805C979g20MwAfJe0UTg4iLkZkmtCQacrb

