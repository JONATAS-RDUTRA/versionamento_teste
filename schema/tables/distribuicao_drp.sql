--
-- PostgreSQL database dump
--

\restrict JXpo4IegH2eRahs6FvSsDATUaTaptWD9G8cpc6E3XNEvN5eLekZbVFKRblSgbMI

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
-- Name: distribuicao_drp; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."distribuicao_drp" (
    "idpedido" integer NOT NULL,
    "data_emissao" "date",
    "iduser" bigint NOT NULL,
    "status" character varying(2) DEFAULT 'AB'::character varying NOT NULL,
    "conf_saida" character varying(50),
    "data_conf_saida" timestamp without time zone,
    "conf_entrada" character varying(50),
    "data_conf_entrada" timestamp without time zone,
    "observacoes" "text"
);


--
-- Name: distribuicao_drp_idpedido_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."distribuicao_drp_idpedido_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: distribuicao_drp_idpedido_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."distribuicao_drp_idpedido_seq" OWNED BY "public"."distribuicao_drp"."idpedido";


--
-- Name: distribuicao_drp idpedido; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."distribuicao_drp" ALTER COLUMN "idpedido" SET DEFAULT "nextval"('"public"."distribuicao_drp_idpedido_seq"'::"regclass");


--
-- Name: distribuicao_drp distrib_drp_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."distribuicao_drp"
    ADD CONSTRAINT "distrib_drp_pkey" PRIMARY KEY ("idpedido");


--
-- Name: distrib_drp_iduser_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "distrib_drp_iduser_idx" ON "public"."distribuicao_drp" USING "btree" ("iduser", "status");


--
-- Name: distribuicao_drp fk_distrib_drp_usuario; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."distribuicao_drp"
    ADD CONSTRAINT "fk_distrib_drp_usuario" FOREIGN KEY ("iduser") REFERENCES "public"."users"("id");


--
-- PostgreSQL database dump complete
--

\unrestrict JXpo4IegH2eRahs6FvSsDATUaTaptWD9G8cpc6E3XNEvN5eLekZbVFKRblSgbMI

