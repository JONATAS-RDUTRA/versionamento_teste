--
-- PostgreSQL database dump
--

\restrict iEholjWuzOw1dgJXYA6dOQY3E87aNrWoaDeAs8MKRIYzBDm9uBEl35T6gOdYx7n

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
-- Name: hist_gatilho_compras; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."hist_gatilho_compras" (
    "idproduto" character varying(25) NOT NULL,
    "filial" numeric(12,0) DEFAULT 0 NOT NULL,
    "data" "date" NOT NULL,
    "status" character varying(2) DEFAULT 'A'::character varying NOT NULL,
    "estoque" numeric(12,4) DEFAULT 0 NOT NULL,
    "ponto_pedido" numeric(12,4) DEFAULT 0 NOT NULL,
    "sugestao" numeric(12,4) DEFAULT 0 NOT NULL,
    "idrequisicao" numeric(12,4) DEFAULT 0 NOT NULL,
    "data_requisicao" "date",
    "arvore_decisao" character varying(4),
    "tempo_reposicao" numeric(12,4)
);


--
-- Name: hist_gatilho_compras_index00; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "hist_gatilho_compras_index00" ON "public"."hist_gatilho_compras" USING "btree" ("idproduto", "filial", "data", "status");


--
-- Name: hist_gatilho_compras_index01; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "hist_gatilho_compras_index01" ON "public"."hist_gatilho_compras" USING "btree" ("idproduto", "status");


--
-- PostgreSQL database dump complete
--

\unrestrict iEholjWuzOw1dgJXYA6dOQY3E87aNrWoaDeAs8MKRIYzBDm9uBEl35T6gOdYx7n

