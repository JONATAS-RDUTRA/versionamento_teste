--
-- PostgreSQL database dump
--

\restrict 86jxbwek7fjS06f3rpLBjlMVPxmk9OtGQPg6eQIRuRwNVhGXb15ztKlSjU3Y4zR

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
-- Name: filtros_produto; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."filtros_produto" (
    "idgrupo" smallint NOT NULL,
    "idfilial" integer NOT NULL,
    "idfornecedor" bigint NOT NULL,
    "idproduto" character varying(25) DEFAULT ''::character varying NOT NULL,
    "item_novo" boolean DEFAULT false,
    "com_movimentacao" boolean DEFAULT false,
    "sem_movimentacao" boolean DEFAULT false,
    "similar" boolean DEFAULT false,
    "heranca" boolean DEFAULT false,
    "ciclo_vida" boolean DEFAULT false,
    "sazonalidade" boolean DEFAULT false,
    "evento" boolean DEFAULT false,
    "influencia_previsao" boolean DEFAULT false,
    "elevada_exposicao_ruptura" boolean DEFAULT false,
    "ruptura" boolean DEFAULT false,
    "baixa_exposicao_ruptura" boolean DEFAULT false,
    "adequado" boolean DEFAULT false,
    "excesso" boolean DEFAULT false
);


--
-- Name: filtros_produto filtros_produto_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."filtros_produto"
    ADD CONSTRAINT "filtros_produto_pk" PRIMARY KEY ("idgrupo", "idfilial", "idfornecedor", "idproduto");


--
-- PostgreSQL database dump complete
--

\unrestrict 86jxbwek7fjS06f3rpLBjlMVPxmk9OtGQPg6eQIRuRwNVhGXb15ztKlSjU3Y4zR

