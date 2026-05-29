--
-- PostgreSQL database dump
--

\restrict aV4F6hg6MFd5wKCIheSPMF1vqnHhasnJ2mbLt1acD09EGv7yEkB6NleJ9rE7Aqr

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
-- Name: avaria_produtos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."avaria_produtos" (
    "idconsumo" bigint NOT NULL,
    "emissao" "date" NOT NULL,
    "filial" bigint NOT NULL,
    "idproduto" character varying(25) NOT NULL,
    "item" integer NOT NULL,
    "idfornecedor" character varying(30) NOT NULL,
    "qtde" double precision NOT NULL,
    "valor_unitario" numeric(12,4) NOT NULL,
    "flag" character varying(1)
);


--
-- Name: avaria_produtos avaria_produtos_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."avaria_produtos"
    ADD CONSTRAINT "avaria_produtos_pk" PRIMARY KEY ("idconsumo", "emissao", "filial", "idproduto", "item");


--
-- PostgreSQL database dump complete
--

\unrestrict aV4F6hg6MFd5wKCIheSPMF1vqnHhasnJ2mbLt1acD09EGv7yEkB6NleJ9rE7Aqr

