--
-- PostgreSQL database dump
--

\restrict 4hFZCICa0obq5IsB7LYjLEvg0XqtLJK4dvetr4FKfuYkQbpLQVfbMEelxAPEsbK

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
-- Name: requisicoes_desconsideradas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."requisicoes_desconsideradas" (
    "id_solicitacao" double precision NOT NULL,
    "item" double precision NOT NULL,
    "idproduto" character varying(25) NOT NULL,
    "qtde_pendente" double precision NOT NULL,
    "id_usuario" integer,
    "created_at" character varying(30)
);


--
-- Name: requisicoes_desconsideradas requisicoes_desconsideradas_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."requisicoes_desconsideradas"
    ADD CONSTRAINT "requisicoes_desconsideradas_pk" PRIMARY KEY ("id_solicitacao", "item", "idproduto");


--
-- Name: requisicoes_desconsideradas fk_id_usuario; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."requisicoes_desconsideradas"
    ADD CONSTRAINT "fk_id_usuario" FOREIGN KEY ("id_usuario") REFERENCES "public"."users"("id");


--
-- PostgreSQL database dump complete
--

\unrestrict 4hFZCICa0obq5IsB7LYjLEvg0XqtLJK4dvetr4FKfuYkQbpLQVfbMEelxAPEsbK

