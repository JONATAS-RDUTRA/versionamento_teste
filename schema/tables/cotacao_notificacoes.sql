--
-- PostgreSQL database dump
--

\restrict 71KlMWRoP2JPhjEIasBtfS4MKXva67hSunEBkfQ8bDcsxBLLHO3oBLC8aX6IDfu

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
-- Name: cotacao_notificacoes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."cotacao_notificacoes" (
    "cotacao_notificacao_id" integer NOT NULL,
    "cotacao_transacao_id" integer NOT NULL,
    "tipo_notificacao" character varying(20) NOT NULL,
    "destinatario_tipo" character varying(20) NOT NULL,
    "cotacao_representante_fornecedor_id" integer,
    "destinatario_email" character varying(255),
    "destinatario_telefone" character varying(20),
    "destinatario_nome" character varying(255),
    "status" character varying(20) DEFAULT 'pendente'::character varying NOT NULL,
    "tentativas" integer DEFAULT 0 NOT NULL,
    "data_envio" timestamp without time zone,
    "erro_mensagem" "text",
    "created_at" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updated_at" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "tipo_email" character varying(50) DEFAULT NULL::character varying,
    CONSTRAINT "cotacao_notificacoes_destinatario_tipo_check" CHECK ((("destinatario_tipo")::"text" = ANY ((ARRAY['fornecedor'::character varying, 'representante'::character varying, 'responsavel'::character varying, 'seguidor'::character varying])::"text"[]))),
    CONSTRAINT "cotacao_notificacoes_status_check" CHECK ((("status")::"text" = ANY ((ARRAY['pendente'::character varying, 'enviado'::character varying, 'falhou'::character varying])::"text"[]))),
    CONSTRAINT "cotacao_notificacoes_tipo_notificacao_check" CHECK ((("tipo_notificacao")::"text" = ANY ((ARRAY['email'::character varying, 'whatsapp'::character varying])::"text"[])))
);


--
-- Name: cotacao_notificacoes_cotacao_notificacao_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."cotacao_notificacoes_cotacao_notificacao_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cotacao_notificacoes_cotacao_notificacao_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."cotacao_notificacoes_cotacao_notificacao_id_seq" OWNED BY "public"."cotacao_notificacoes"."cotacao_notificacao_id";


--
-- Name: cotacao_notificacoes cotacao_notificacao_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cotacao_notificacoes" ALTER COLUMN "cotacao_notificacao_id" SET DEFAULT "nextval"('"public"."cotacao_notificacoes_cotacao_notificacao_id_seq"'::"regclass");


--
-- Name: cotacao_notificacoes cotacao_notificacoes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cotacao_notificacoes"
    ADD CONSTRAINT "cotacao_notificacoes_pkey" PRIMARY KEY ("cotacao_notificacao_id");


--
-- Name: idx_cotacao_notificacoes_cotacao_representante_fornecedor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "idx_cotacao_notificacoes_cotacao_representante_fornecedor_id" ON "public"."cotacao_notificacoes" USING "btree" ("cotacao_representante_fornecedor_id");


--
-- Name: idx_cotacao_notificacoes_cotacao_transacao_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "idx_cotacao_notificacoes_cotacao_transacao_id" ON "public"."cotacao_notificacoes" USING "btree" ("cotacao_transacao_id");


--
-- Name: idx_cotacao_notificacoes_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "idx_cotacao_notificacoes_status" ON "public"."cotacao_notificacoes" USING "btree" ("status");


--
-- Name: idx_cotacao_notificacoes_tipo_notificacao; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "idx_cotacao_notificacoes_tipo_notificacao" ON "public"."cotacao_notificacoes" USING "btree" ("tipo_notificacao");


--
-- Name: cotacao_notificacoes cotacao_notificacoes_cotacao_representante_fornecedor_id_foreig; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cotacao_notificacoes"
    ADD CONSTRAINT "cotacao_notificacoes_cotacao_representante_fornecedor_id_foreig" FOREIGN KEY ("cotacao_representante_fornecedor_id") REFERENCES "public"."cotacao_representante_fornecedor"("cotacao_representante_fornecedor_id") ON DELETE SET NULL;


--
-- Name: cotacao_notificacoes cotacao_notificacoes_cotacao_transacao_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cotacao_notificacoes"
    ADD CONSTRAINT "cotacao_notificacoes_cotacao_transacao_id_foreign" FOREIGN KEY ("cotacao_transacao_id") REFERENCES "public"."cotacao_transacao"("cotacao_transacao_id") ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict 71KlMWRoP2JPhjEIasBtfS4MKXva67hSunEBkfQ8bDcsxBLLHO3oBLC8aX6IDfu

