--
-- PostgreSQL database dump
--

\restrict bJbku6vzzIBAQB8CXvX1cPeOz49RboIc953JO5qVd4Q3qhNN9Htfw2LDlxql5Jq

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
-- Name: cotacao_transacao; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."cotacao_transacao" (
    "cotacao_transacao_id" integer NOT NULL,
    "cliente_empresa_systock_id" integer NOT NULL,
    "cotacao_titulo" character varying(100) NOT NULL,
    "identificador_externo" character varying(255),
    "publicar_cotacao" boolean DEFAULT false NOT NULL,
    "cotacao_status_id" integer,
    "cotacao_decisao_id" integer,
    "cotacao_situacao_pedidos_id" integer,
    "created_at" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "updated_at" timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: cotacao_transacao_cotacao_transacao_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."cotacao_transacao_cotacao_transacao_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cotacao_transacao_cotacao_transacao_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."cotacao_transacao_cotacao_transacao_id_seq" OWNED BY "public"."cotacao_transacao"."cotacao_transacao_id";


--
-- Name: cotacao_transacao cotacao_transacao_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cotacao_transacao" ALTER COLUMN "cotacao_transacao_id" SET DEFAULT "nextval"('"public"."cotacao_transacao_cotacao_transacao_id_seq"'::"regclass");


--
-- Name: cotacao_transacao cotacao_transacao_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cotacao_transacao"
    ADD CONSTRAINT "cotacao_transacao_pkey" PRIMARY KEY ("cotacao_transacao_id");


--
-- Name: cotacao_transacao update_cotacao_transacao_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER "update_cotacao_transacao_updated_at" BEFORE UPDATE ON "public"."cotacao_transacao" FOR EACH ROW EXECUTE FUNCTION "public"."update_cotacao_transacao_updated_at"();


--
-- Name: cotacao_transacao cotacao_transacao_cliente_empresa_systock_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cotacao_transacao"
    ADD CONSTRAINT "cotacao_transacao_cliente_empresa_systock_id_foreign" FOREIGN KEY ("cliente_empresa_systock_id") REFERENCES "public"."cfgsystem"("id");


--
-- Name: cotacao_transacao cotacao_transacao_cotacao_decisao_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cotacao_transacao"
    ADD CONSTRAINT "cotacao_transacao_cotacao_decisao_id_foreign" FOREIGN KEY ("cotacao_decisao_id") REFERENCES "public"."cotacao_decisao"("cotacao_decisao_id") ON DELETE SET NULL;


--
-- Name: cotacao_transacao cotacao_transacao_cotacao_situacao_pedidos_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cotacao_transacao"
    ADD CONSTRAINT "cotacao_transacao_cotacao_situacao_pedidos_id_foreign" FOREIGN KEY ("cotacao_situacao_pedidos_id") REFERENCES "public"."cotacao_situacao_pedidos"("cotacao_situacao_pedidos_id") ON DELETE SET NULL;


--
-- Name: cotacao_transacao cotacao_transacao_cotacao_status_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cotacao_transacao"
    ADD CONSTRAINT "cotacao_transacao_cotacao_status_id_foreign" FOREIGN KEY ("cotacao_status_id") REFERENCES "public"."cotacao_status"("cotacao_status_id") ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

\unrestrict bJbku6vzzIBAQB8CXvX1cPeOz49RboIc953JO5qVd4Q3qhNN9Htfw2LDlxql5Jq

