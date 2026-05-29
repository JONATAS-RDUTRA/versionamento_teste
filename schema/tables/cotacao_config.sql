--
-- PostgreSQL database dump
--

\restrict EayL4JwD6lXsJCYDuPevh1vupAnU9Hqf0AraL0MG5BFAMbhJEuTYtJATibxojsO

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
-- Name: cotacao_config; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."cotacao_config" (
    "cotacao_config_id" integer NOT NULL,
    "cotacao_transacao_id" integer NOT NULL,
    "idfilial" integer NOT NULL,
    "inicio_periodo_recebimento_proposta" timestamp without time zone NOT NULL,
    "termino_periodo_recebimento_proposta" timestamp without time zone NOT NULL
);


--
-- Name: cotacao_config_cotacao_config_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."cotacao_config_cotacao_config_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cotacao_config_cotacao_config_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."cotacao_config_cotacao_config_id_seq" OWNED BY "public"."cotacao_config"."cotacao_config_id";


--
-- Name: cotacao_config cotacao_config_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cotacao_config" ALTER COLUMN "cotacao_config_id" SET DEFAULT "nextval"('"public"."cotacao_config_cotacao_config_id_seq"'::"regclass");


--
-- Name: cotacao_config cotacao_config_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cotacao_config"
    ADD CONSTRAINT "cotacao_config_pkey" PRIMARY KEY ("cotacao_config_id");


--
-- Name: cotacao_config cotacao_config_cotacao_transacao_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cotacao_config"
    ADD CONSTRAINT "cotacao_config_cotacao_transacao_id_foreign" FOREIGN KEY ("cotacao_transacao_id") REFERENCES "public"."cotacao_transacao"("cotacao_transacao_id");


--
-- PostgreSQL database dump complete
--

\unrestrict EayL4JwD6lXsJCYDuPevh1vupAnU9Hqf0AraL0MG5BFAMbhJEuTYtJATibxojsO

