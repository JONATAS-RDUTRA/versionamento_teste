--
-- PostgreSQL database dump
--

\restrict u6hxCApbBnx9IMukf7GRhDmpEdlQtO9dnFVirDUhyUKB3pl3mXdbgjKYIvNAY3i

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
-- Name: hist_estoque; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."hist_estoque" (
    "idproduto" character varying(25) NOT NULL,
    "filial" numeric(12,0) DEFAULT 0 NOT NULL,
    "data" "date" NOT NULL,
    "qtde" numeric(17,4) DEFAULT 0 NOT NULL,
    "preco_custo" numeric(17,4)
)
WITH ("autovacuum_vacuum_scale_factor"='0.03807');


--
-- Name: hist_estoque pk_hist_estoque; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."hist_estoque"
    ADD CONSTRAINT "pk_hist_estoque" PRIMARY KEY ("filial", "idproduto", "data");


--
-- Name: hist_estoque_index00; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "hist_estoque_index00" ON "public"."hist_estoque" USING "btree" ("idproduto", "data");


--
-- PostgreSQL database dump complete
--

\unrestrict u6hxCApbBnx9IMukf7GRhDmpEdlQtO9dnFVirDUhyUKB3pl3mXdbgjKYIvNAY3i

