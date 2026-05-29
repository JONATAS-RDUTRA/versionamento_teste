--
-- PostgreSQL database dump
--

\restrict HbCAaoaUtBUYivOkw8VG6OYXp1x9ScbtbKikgKwNH4hRoFbcU9gs2dYMIhHLowJ

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
-- Name: arvore_decisao; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."arvore_decisao" (
    "idarvore_decisao" integer DEFAULT "nextval"('"public"."arvore_decisao_idarvore_decisao_seq"'::"regclass") NOT NULL,
    "combinacao" character varying(6),
    "manter_estoque" character varying(1),
    "idnivel_servico" integer NOT NULL
);


--
-- Name: arvore_decisao arvore_decisao_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."arvore_decisao"
    ADD CONSTRAINT "arvore_decisao_pkey" PRIMARY KEY ("idarvore_decisao");


--
-- Name: combinacao_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "combinacao_idx" ON "public"."arvore_decisao" USING "btree" ("combinacao");


--
-- Name: fk_arvore_decisao_nivel_servico1_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "fk_arvore_decisao_nivel_servico1_idx" ON "public"."arvore_decisao" USING "btree" ("idnivel_servico");


--
-- Name: arvore_decisao fk_arvore_decisao_nivel_servico1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."arvore_decisao"
    ADD CONSTRAINT "fk_arvore_decisao_nivel_servico1" FOREIGN KEY ("idnivel_servico") REFERENCES "public"."nivel_servico"("idnivel_servico");


--
-- PostgreSQL database dump complete
--

\unrestrict HbCAaoaUtBUYivOkw8VG6OYXp1x9ScbtbKikgKwNH4hRoFbcU9gs2dYMIhHLowJ

