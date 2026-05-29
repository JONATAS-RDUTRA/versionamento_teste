--
-- PostgreSQL database dump
--

\restrict b5shDZmIPGisuYW5ozane06bXB9q2nfxTINWixmg5rdR1kAkdMZhpfChgzlDRri

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
-- Name: produtos_mp; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."produtos_mp" (
    "idgrupo" bigint NOT NULL,
    "id_fornecedor" bigint NOT NULL,
    "id_produto" character varying(25) DEFAULT ''::character varying NOT NULL,
    "estoque" numeric(12,4),
    "emax" numeric(12,4),
    "cmm" numeric(12,4),
    "std_cmm" numeric(12,4),
    "tp_ressup" numeric(12,4),
    "std_tp_ressup" numeric(12,4),
    "sugestao" numeric(12,4),
    "id_user" bigint NOT NULL,
    "data_cadastro" "date" NOT NULL,
    "status" character varying(1),
    "processamento" timestamp without time zone
);


--
-- Name: produtos_mp pk_produtos_mp; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."produtos_mp"
    ADD CONSTRAINT "pk_produtos_mp" PRIMARY KEY ("idgrupo", "id_fornecedor", "id_produto");


--
-- Name: produtos_mp fk_fornecedor; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."produtos_mp"
    ADD CONSTRAINT "fk_fornecedor" FOREIGN KEY ("id_fornecedor") REFERENCES "public"."fornecedor"("id");


--
-- PostgreSQL database dump complete
--

\unrestrict b5shDZmIPGisuYW5ozane06bXB9q2nfxTINWixmg5rdR1kAkdMZhpfChgzlDRri

