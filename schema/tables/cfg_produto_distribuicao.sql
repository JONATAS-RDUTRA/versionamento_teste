--
-- PostgreSQL database dump
--

\restrict 7N6Nf9NURy0IPEs1xSsJZBaCPLXXrREo0MwgfisBXHOjtbhyB1J72mqIL9gYaV0

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
-- Name: cfg_produto_distribuicao; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."cfg_produto_distribuicao" (
    "filial" bigint NOT NULL,
    "idproduto" character varying(25) NOT NULL,
    "cobertura_estoque" bigint,
    "estoque_min" numeric(12,4),
    "estoque_max" numeric(12,4),
    "created_at" timestamp without time zone,
    "updated_at" timestamp without time zone,
    "multiplo_dist" numeric(12,4) DEFAULT 1,
    "primeira_entrada" "date",
    CONSTRAINT "multiplo_dist_e_1" CHECK (("multiplo_dist" > (0)::numeric))
);


--
-- Name: cfg_produto_distribuicao cfg_produto_distribuicao_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cfg_produto_distribuicao"
    ADD CONSTRAINT "cfg_produto_distribuicao_pk" PRIMARY KEY ("filial", "idproduto");


--
-- PostgreSQL database dump complete
--

\unrestrict 7N6Nf9NURy0IPEs1xSsJZBaCPLXXrREo0MwgfisBXHOjtbhyB1J72mqIL9gYaV0

