--
-- PostgreSQL database dump
--

\restrict wHscGHKFN5V2hidZODYIhuIBLgeNfpMqx8caMnlGHfqgkbe6KPaDNFJcgBbh1Ib

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
-- Name: cotacao_seguidores_favoritos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."cotacao_seguidores_favoritos" (
    "cotacao_seguidores_favoritos_id" integer NOT NULL,
    "user_id" integer NOT NULL
);


--
-- Name: cotacao_seguidores_favoritos_cotacao_seguidores_favoritos_i_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."cotacao_seguidores_favoritos_cotacao_seguidores_favoritos_i_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cotacao_seguidores_favoritos_cotacao_seguidores_favoritos_i_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."cotacao_seguidores_favoritos_cotacao_seguidores_favoritos_i_seq" OWNED BY "public"."cotacao_seguidores_favoritos"."cotacao_seguidores_favoritos_id";


--
-- Name: cotacao_seguidores_favoritos cotacao_seguidores_favoritos_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cotacao_seguidores_favoritos" ALTER COLUMN "cotacao_seguidores_favoritos_id" SET DEFAULT "nextval"('"public"."cotacao_seguidores_favoritos_cotacao_seguidores_favoritos_i_seq"'::"regclass");


--
-- Name: cotacao_seguidores_favoritos cotacao_seguidores_favoritos_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cotacao_seguidores_favoritos"
    ADD CONSTRAINT "cotacao_seguidores_favoritos_pkey" PRIMARY KEY ("cotacao_seguidores_favoritos_id");


--
-- Name: idx_cotacao_seguidores_favoritos_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "idx_cotacao_seguidores_favoritos_user_id" ON "public"."cotacao_seguidores_favoritos" USING "btree" ("user_id");


--
-- Name: cotacao_seguidores_favoritos cotacao_seguidores_favoritos_user_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cotacao_seguidores_favoritos"
    ADD CONSTRAINT "cotacao_seguidores_favoritos_user_id_foreign" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict wHscGHKFN5V2hidZODYIhuIBLgeNfpMqx8caMnlGHfqgkbe6KPaDNFJcgBbh1Ib

