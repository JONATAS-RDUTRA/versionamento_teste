--
-- PostgreSQL database dump
--

\restrict 2pikbd66gtnFKkt1vfkvxRsIpCeANe9c2Z2lgxqbuSZcoDv5pmmIO7CrQUKB7Cd

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
-- Name: hist_gatilho_compras_grupo; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."hist_gatilho_compras_grupo" (
    "grupo" numeric(12,0) DEFAULT 0 NOT NULL,
    "idproduto" character varying(25) NOT NULL,
    "data" "date" NOT NULL,
    "tipo" character varying(2) NOT NULL,
    "status" character varying(2) DEFAULT 'A'::character varying NOT NULL,
    "estoque" numeric(20,4) DEFAULT 0 NOT NULL,
    "ponto_pedido" numeric(20,4) DEFAULT 0 NOT NULL,
    "sugestao" numeric(20,4) DEFAULT 0 NOT NULL,
    "idrequisicao" numeric(12,4) DEFAULT 0 NOT NULL,
    "data_requisicao" "date",
    "arvore_decisao" character varying(4),
    "tempo_reposicao" numeric(12,4),
    "std_dv_tempo_reposicao" numeric(12,4)
)
WITH ("autovacuum_vacuum_scale_factor"='2.36380');


--
-- Name: hist_gatilho_compras_grupo_index00; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "hist_gatilho_compras_grupo_index00" ON "public"."hist_gatilho_compras_grupo" USING "btree" ("grupo", "idproduto", "data", "tipo", "status");


--
-- Name: hist_gatilho_compras_grupo_index01; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "hist_gatilho_compras_grupo_index01" ON "public"."hist_gatilho_compras_grupo" USING "btree" ("grupo", "idproduto", "tipo", "status");


--
-- PostgreSQL database dump complete
--

\unrestrict 2pikbd66gtnFKkt1vfkvxRsIpCeANe9c2Z2lgxqbuSZcoDv5pmmIO7CrQUKB7Cd

