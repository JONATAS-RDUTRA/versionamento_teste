--
-- PostgreSQL database dump
--

\restrict PLAzlAG54D5tM3hBIp8l3c5BT47AEDItxcvlqxtOzzCI21pwXN2OdIix0XgpdCw

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
-- Name: produtos_pa; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."produtos_pa" (
    "id_produto" character varying(25) DEFAULT ''::character varying NOT NULL,
    "id_fornecedor" bigint NOT NULL,
    "qtde" numeric(12,4) NOT NULL,
    "id_user" bigint NOT NULL,
    "data_cadastro" "date" NOT NULL,
    "id_fornecedor_materia_prima" bigint NOT NULL,
    "id_produto_materia_prima" character varying(25) DEFAULT ''::character varying NOT NULL,
    "peso_pa" numeric DEFAULT 0 NOT NULL
);


--
-- Name: produtos_pa pk_produtos_pa; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."produtos_pa"
    ADD CONSTRAINT "pk_produtos_pa" PRIMARY KEY ("id_produto", "id_produto_materia_prima");


--
-- Name: produtos_pa fk_usuario; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."produtos_pa"
    ADD CONSTRAINT "fk_usuario" FOREIGN KEY ("id_user") REFERENCES "public"."users"("id");


--
-- PostgreSQL database dump complete
--

\unrestrict PLAzlAG54D5tM3hBIp8l3c5BT47AEDItxcvlqxtOzzCI21pwXN2OdIix0XgpdCw

