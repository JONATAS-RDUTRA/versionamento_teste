--
-- PostgreSQL database dump
--

\restrict 4EVqeyE78gX6xPdFtmedu1gZUoUnXMfSaajH51ewJDuZpKRnnONTuMQqYugRKh0

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
-- Name: cotacoes_compra; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."cotacoes_compra" (
    "id_pedido" integer NOT NULL,
    "id_cotacao" integer NOT NULL,
    "id_produto" character varying NOT NULL,
    "quantidade" numeric NOT NULL,
    "preco" numeric NOT NULL,
    "data_abertura" timestamp without time zone NOT NULL
);


--
-- Name: cotacoes_compra pk_cotacoes_compra; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cotacoes_compra"
    ADD CONSTRAINT "pk_cotacoes_compra" PRIMARY KEY ("id_pedido", "id_cotacao", "id_produto");


--
-- Name: cotacoes_compra fk_cotacoes_compra; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cotacoes_compra"
    ADD CONSTRAINT "fk_cotacoes_compra" FOREIGN KEY ("id_pedido") REFERENCES "public"."pedidos_compras"("idpedido");


--
-- PostgreSQL database dump complete
--

\unrestrict 4EVqeyE78gX6xPdFtmedu1gZUoUnXMfSaajH51ewJDuZpKRnnONTuMQqYugRKh0

