--
-- PostgreSQL database dump
--

\restrict zxezOS5mxyOUANuWFX2yNbPtzGtEB41yRywfLzZx4SIgipIYpvVprEnIqjAXAlh

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
-- Name: pedidos_compra_departamento; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."pedidos_compra_departamento" (
    "id_pedido" bigint NOT NULL,
    "iddepatamento" character varying(25) NOT NULL
);


--
-- Name: pedidos_compra_departamento pk_pedidos_compra_departamento; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."pedidos_compra_departamento"
    ADD CONSTRAINT "pk_pedidos_compra_departamento" PRIMARY KEY ("id_pedido");


--
-- Name: pedidos_compra_departamento fk_pedidos_compra_tipo; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."pedidos_compra_departamento"
    ADD CONSTRAINT "fk_pedidos_compra_tipo" FOREIGN KEY ("id_pedido") REFERENCES "public"."pedidos_compra_tipo"("id");


--
-- PostgreSQL database dump complete
--

\unrestrict zxezOS5mxyOUANuWFX2yNbPtzGtEB41yRywfLzZx4SIgipIYpvVprEnIqjAXAlh

