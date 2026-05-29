--
-- PostgreSQL database dump
--

\restrict eiG4zrPOaXqM3j4VLxCuvCDZ2BIrvPS8gmI0sNheLyUsVg9Z1iy5le6hM0E6DH2

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
-- Name: movimentacoes_produtos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."movimentacoes_produtos" (
    "movimentacao_idorcamentos" integer NOT NULL,
    "produtos_idproduto" character varying(25) DEFAULT ''::character varying NOT NULL,
    "qtde" integer
);


--
-- Name: movimentacoes_produtos movimentacoes_produtos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."movimentacoes_produtos"
    ADD CONSTRAINT "movimentacoes_produtos_pkey" PRIMARY KEY ("movimentacao_idorcamentos", "produtos_idproduto");


--
-- Name: fk_movimentacoes_has_produtos_movimentacoes1_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "fk_movimentacoes_has_produtos_movimentacoes1_idx" ON "public"."movimentacoes_produtos" USING "btree" ("movimentacao_idorcamentos");


--
-- Name: fk_movimentacoes_has_produtos_produtos1_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "fk_movimentacoes_has_produtos_produtos1_idx" ON "public"."movimentacoes_produtos" USING "btree" ("produtos_idproduto");


--
-- Name: movimentacoes_produtos fk_movimentacoes_has_produtos_movimentacoes1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."movimentacoes_produtos"
    ADD CONSTRAINT "fk_movimentacoes_has_produtos_movimentacoes1" FOREIGN KEY ("movimentacao_idorcamentos") REFERENCES "public"."movimentacoes"("idmovimentacao");


--
-- PostgreSQL database dump complete
--

\unrestrict eiG4zrPOaXqM3j4VLxCuvCDZ2BIrvPS8gmI0sNheLyUsVg9Z1iy5le6hM0E6DH2

