--
-- PostgreSQL database dump
--

\restrict 1WwdqELmUc6PAYWS6CGVeagLQzKzAtMyAqzPcw77eJNKHrVxkvdUsfmfNQHgqcI

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
-- Name: sys_exportacoes_pedidos_compras_api_itens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."sys_exportacoes_pedidos_compras_api_itens" (
    "idpedido" bigint NOT NULL,
    "idproduto" character varying(25) DEFAULT ''::character varying NOT NULL,
    "qtde_do_lote" bigint,
    "tipo_do_lote" character varying(50),
    "data_entrega" "date" NOT NULL,
    "data_faturamento" "date" NOT NULL
);


--
-- Name: sys_exportacoes_pedidos_compras_api_itens sys_exportacoes_pedidos_compras_api_itens_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."sys_exportacoes_pedidos_compras_api_itens"
    ADD CONSTRAINT "sys_exportacoes_pedidos_compras_api_itens_pk" PRIMARY KEY ("idpedido", "idproduto");


--
-- PostgreSQL database dump complete
--

\unrestrict 1WwdqELmUc6PAYWS6CGVeagLQzKzAtMyAqzPcw77eJNKHrVxkvdUsfmfNQHgqcI

