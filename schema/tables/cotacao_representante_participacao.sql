--
-- PostgreSQL database dump
--

\restrict gFE19DqphP3S51J9GNETf9CQIiIePypWOGG6IYuTIZfQ8RNgzjzx5BbRpTooQa7

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
-- Name: cotacao_representante_participacao; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."cotacao_representante_participacao" (
    "cotacao_representante_participacao_id" integer NOT NULL,
    "cotacao_representante_fornecedor_id" integer NOT NULL,
    "cotacao_transacao_id" integer NOT NULL,
    "fornecedor_id" integer NOT NULL
);


--
-- Name: cotacao_representante_partici_cotacao_representante_partici_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."cotacao_representante_partici_cotacao_representante_partici_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cotacao_representante_partici_cotacao_representante_partici_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."cotacao_representante_partici_cotacao_representante_partici_seq" OWNED BY "public"."cotacao_representante_participacao"."cotacao_representante_participacao_id";


--
-- Name: cotacao_representante_participacao cotacao_representante_participacao_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cotacao_representante_participacao" ALTER COLUMN "cotacao_representante_participacao_id" SET DEFAULT "nextval"('"public"."cotacao_representante_partici_cotacao_representante_partici_seq"'::"regclass");


--
-- Name: cotacao_representante_participacao cotacao_representante_participacao_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cotacao_representante_participacao"
    ADD CONSTRAINT "cotacao_representante_participacao_pkey" PRIMARY KEY ("cotacao_representante_participacao_id");


--
-- Name: idx_cotacao_representante_participacao_cotacao_representante_fo; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "idx_cotacao_representante_participacao_cotacao_representante_fo" ON "public"."cotacao_representante_participacao" USING "btree" ("cotacao_representante_fornecedor_id");


--
-- Name: idx_cotacao_representante_participacao_cotacao_transacao_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "idx_cotacao_representante_participacao_cotacao_transacao_id" ON "public"."cotacao_representante_participacao" USING "btree" ("cotacao_transacao_id");


--
-- Name: idx_cotacao_representante_participacao_fornecedor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "idx_cotacao_representante_participacao_fornecedor_id" ON "public"."cotacao_representante_participacao" USING "btree" ("fornecedor_id");


--
-- Name: idx_cotacao_representante_participacao_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "idx_cotacao_representante_participacao_unique" ON "public"."cotacao_representante_participacao" USING "btree" ("cotacao_transacao_id", "cotacao_representante_fornecedor_id");


--
-- Name: cotacao_representante_participacao cotacao_representante_participacao_cotacao_representante_fornec; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cotacao_representante_participacao"
    ADD CONSTRAINT "cotacao_representante_participacao_cotacao_representante_fornec" FOREIGN KEY ("cotacao_representante_fornecedor_id") REFERENCES "public"."cotacao_representante_fornecedor"("cotacao_representante_fornecedor_id") ON DELETE CASCADE;


--
-- Name: cotacao_representante_participacao cotacao_representante_participacao_cotacao_transacao_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cotacao_representante_participacao"
    ADD CONSTRAINT "cotacao_representante_participacao_cotacao_transacao_id_foreign" FOREIGN KEY ("cotacao_transacao_id") REFERENCES "public"."cotacao_transacao"("cotacao_transacao_id") ON DELETE CASCADE;


--
-- Name: cotacao_representante_participacao cotacao_representante_participacao_fornecedor_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cotacao_representante_participacao"
    ADD CONSTRAINT "cotacao_representante_participacao_fornecedor_id_foreign" FOREIGN KEY ("fornecedor_id") REFERENCES "public"."fornecedor"("id") ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict gFE19DqphP3S51J9GNETf9CQIiIePypWOGG6IYuTIZfQ8RNgzjzx5BbRpTooQa7

