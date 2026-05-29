--
-- PostgreSQL database dump
--

\restrict KoJcKSA9n7kr2UW2uZA4629RAa0fw5cl9DjeYgMvfrhzDBGYuU17iAg0H4T4uho

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
-- Name: distribuicao_drp_itens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."distribuicao_drp_itens" (
    "idpedido" bigint NOT NULL,
    "filial_origem" bigint NOT NULL,
    "filial_destino" bigint NOT NULL,
    "idproduto" character varying(25) DEFAULT ''::character varying NOT NULL,
    "qtde_pedido" numeric(12,4) NOT NULL,
    "qtde_conf" numeric(12,4) DEFAULT 0 NOT NULL,
    "log_data" timestamp without time zone,
    "qtde_inicial" numeric(12,4),
    "prioridade" character varying(1) DEFAULT 'N'::character varying NOT NULL,
    "idjustificativa" integer
);


--
-- Name: distribuicao_drp_itens dist_drp_itens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."distribuicao_drp_itens"
    ADD CONSTRAINT "dist_drp_itens_pkey" PRIMARY KEY ("idpedido", "filial_origem", "filial_destino", "idproduto");


--
-- Name: distribuicao_drp_itens fk_dist_drp_itens; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."distribuicao_drp_itens"
    ADD CONSTRAINT "fk_dist_drp_itens" FOREIGN KEY ("idpedido") REFERENCES "public"."distribuicao_drp"("idpedido");


--
-- PostgreSQL database dump complete
--

\unrestrict KoJcKSA9n7kr2UW2uZA4629RAa0fw5cl9DjeYgMvfrhzDBGYuU17iAg0H4T4uho

