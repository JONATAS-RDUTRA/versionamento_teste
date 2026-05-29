--
-- PostgreSQL database dump
--

\restrict 0PhS0cLq8OeBKapXbgi2wivYtNjdSbZFJcK7oa0vO1Xol7zAxrwOoYriJDp0Jy2

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
-- Name: familia_produtos_parceiros; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."familia_produtos_parceiros" (
    "idfamilia_produto" integer NOT NULL,
    "idparceiro" integer NOT NULL
);


--
-- Name: familia_produtos_parceiros familia_produtos_parceiros_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."familia_produtos_parceiros"
    ADD CONSTRAINT "familia_produtos_parceiros_pkey" PRIMARY KEY ("idfamilia_produto", "idparceiro");


--
-- Name: fk_familia_produtos_has_parceiros_familia_produtos1_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "fk_familia_produtos_has_parceiros_familia_produtos1_idx" ON "public"."familia_produtos_parceiros" USING "btree" ("idfamilia_produto");


--
-- Name: fk_familia_produtos_has_parceiros_parceiros1_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "fk_familia_produtos_has_parceiros_parceiros1_idx" ON "public"."familia_produtos_parceiros" USING "btree" ("idparceiro");


--
-- Name: familia_produtos_parceiros fk_familia_produtos_has_parceiros_familia_produtos1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."familia_produtos_parceiros"
    ADD CONSTRAINT "fk_familia_produtos_has_parceiros_familia_produtos1" FOREIGN KEY ("idfamilia_produto") REFERENCES "public"."familia_produtos"("idfamilia_produto");


--
-- Name: familia_produtos_parceiros fk_familia_produtos_has_parceiros_parceiros1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."familia_produtos_parceiros"
    ADD CONSTRAINT "fk_familia_produtos_has_parceiros_parceiros1" FOREIGN KEY ("idparceiro") REFERENCES "public"."parceiros"("idparceiro");


--
-- PostgreSQL database dump complete
--

\unrestrict 0PhS0cLq8OeBKapXbgi2wivYtNjdSbZFJcK7oa0vO1Xol7zAxrwOoYriJDp0Jy2

