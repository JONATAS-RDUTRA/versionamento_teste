--
-- PostgreSQL database dump
--

\restrict qFPmhzbiPwrDIaE2KbQnKe6s5zwOIe8VE0sSZ9LfHfcRLSwynA5vLUCdhcVEGZ0

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
-- Name: imagens_produtos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."imagens_produtos" (
    "idimagem_produto" integer DEFAULT "nextval"('"public"."imagens_produtos_idimagem_produto_seq"'::"regclass") NOT NULL,
    "idproduto" character varying(25) DEFAULT ''::character varying NOT NULL,
    "src" character varying(200),
    "mime_type" character varying(15),
    "extensao" character varying(15)
);


--
-- Name: imagens_produtos imagens_produtos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."imagens_produtos"
    ADD CONSTRAINT "imagens_produtos_pkey" PRIMARY KEY ("idimagem_produto");


--
-- Name: fk_imagens_produtos_produtos1_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "fk_imagens_produtos_produtos1_idx" ON "public"."imagens_produtos" USING "btree" ("idproduto");


--
-- PostgreSQL database dump complete
--

\unrestrict qFPmhzbiPwrDIaE2KbQnKe6s5zwOIe8VE0sSZ9LfHfcRLSwynA5vLUCdhcVEGZ0

