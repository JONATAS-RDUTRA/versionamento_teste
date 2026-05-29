--
-- PostgreSQL database dump
--

\restrict LcOrsZ8KyLVwalxHEZOOfyms1KFgWSWYWYM95nTWX7uJNPVy9XiuYJdgXqNch26

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
-- Name: movimentacoes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."movimentacoes" (
    "idmovimentacao" integer DEFAULT "nextval"('"public"."movimentacoes_idmovimentacao_seq"'::"regclass") NOT NULL,
    "emissao" "date",
    "horario_mov" time without time zone,
    "tipo_movimentacao" character varying(3),
    "solicitante" integer NOT NULL,
    "idcentro_custo_consumo" integer,
    "impresso" character varying(1) DEFAULT 'N'::character varying
);


--
-- Name: movimentacoes movimentacoes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."movimentacoes"
    ADD CONSTRAINT "movimentacoes_pkey" PRIMARY KEY ("idmovimentacao");


--
-- Name: fk_movimentacoes_centro_custos1_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "fk_movimentacoes_centro_custos1_idx" ON "public"."movimentacoes" USING "btree" ("idcentro_custo_consumo");


--
-- Name: fk_orcamentos_colaboradores1_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "fk_orcamentos_colaboradores1_idx" ON "public"."movimentacoes" USING "btree" ("solicitante");


--
-- Name: movimentacoes fk_movimentacoes_centro_custos1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."movimentacoes"
    ADD CONSTRAINT "fk_movimentacoes_centro_custos1" FOREIGN KEY ("idcentro_custo_consumo") REFERENCES "public"."centro_custos"("idcentro_custo");


--
-- Name: movimentacoes fk_orcamentos_colaboradores1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."movimentacoes"
    ADD CONSTRAINT "fk_orcamentos_colaboradores1" FOREIGN KEY ("solicitante") REFERENCES "public"."colaboradores"("idcolaborador");


--
-- PostgreSQL database dump complete
--

\unrestrict LcOrsZ8KyLVwalxHEZOOfyms1KFgWSWYWYM95nTWX7uJNPVy9XiuYJdgXqNch26

