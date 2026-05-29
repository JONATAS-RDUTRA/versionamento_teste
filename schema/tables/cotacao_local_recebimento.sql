--
-- PostgreSQL database dump
--

\restrict O5ORfU7xpx8Ouiq1eYl7WLPsxcqQjuPwewHsFhr7sEmknmYSpan6Q96GdGAUGSr

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
-- Name: cotacao_local_recebimento; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."cotacao_local_recebimento" (
    "cotacao_local_recebimento_id" integer NOT NULL,
    "cotacao_transacao_id" integer NOT NULL,
    "idfilial" integer NOT NULL,
    "endereco" character varying(200) NOT NULL,
    "hora_recebimento_inicio" time without time zone NOT NULL,
    "hora_recebimento_fim" time without time zone NOT NULL,
    "observacao_recebimento" character varying(255) NOT NULL
);


--
-- Name: cotacao_local_recebimento_cotacao_local_recebimento_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."cotacao_local_recebimento_cotacao_local_recebimento_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cotacao_local_recebimento_cotacao_local_recebimento_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."cotacao_local_recebimento_cotacao_local_recebimento_id_seq" OWNED BY "public"."cotacao_local_recebimento"."cotacao_local_recebimento_id";


--
-- Name: cotacao_local_recebimento cotacao_local_recebimento_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cotacao_local_recebimento" ALTER COLUMN "cotacao_local_recebimento_id" SET DEFAULT "nextval"('"public"."cotacao_local_recebimento_cotacao_local_recebimento_id_seq"'::"regclass");


--
-- Name: cotacao_local_recebimento cotacao_local_recebimento_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cotacao_local_recebimento"
    ADD CONSTRAINT "cotacao_local_recebimento_pkey" PRIMARY KEY ("cotacao_local_recebimento_id");


--
-- Name: cotacao_local_recebimento cotacao_local_recebimento_cotacao_transacao_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cotacao_local_recebimento"
    ADD CONSTRAINT "cotacao_local_recebimento_cotacao_transacao_id_foreign" FOREIGN KEY ("cotacao_transacao_id") REFERENCES "public"."cotacao_transacao"("cotacao_transacao_id");


--
-- PostgreSQL database dump complete
--

\unrestrict O5ORfU7xpx8Ouiq1eYl7WLPsxcqQjuPwewHsFhr7sEmknmYSpan6Q96GdGAUGSr

