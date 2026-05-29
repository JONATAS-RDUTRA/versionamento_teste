--
-- PostgreSQL database dump
--

\restrict tfSQ7Qw8N4GryiqOLB9nhXx2GdlCtNb5CUbglIxDlVwFZ1YS9svP6azQ0ZXRsba

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
-- Name: produtos_capa_listas_preco; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."produtos_capa_listas_preco" (
    "id_capa" integer NOT NULL,
    "cod_barras" character varying(25),
    "id_produto" character varying(25) NOT NULL,
    "preco" numeric(12,4) NOT NULL,
    "cod_produto" character varying(30)
);


--
-- Name: produtos_capa_listas_preco pk_produtos_capa_listas_preco; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."produtos_capa_listas_preco"
    ADD CONSTRAINT "pk_produtos_capa_listas_preco" PRIMARY KEY ("id_capa", "id_produto");


--
-- Name: produtos_capa_listas_preco fk_produtos_capa_listas_preco; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."produtos_capa_listas_preco"
    ADD CONSTRAINT "fk_produtos_capa_listas_preco" FOREIGN KEY ("id_capa") REFERENCES "public"."capa_listas_preco"("id");


--
-- PostgreSQL database dump complete
--

\unrestrict tfSQ7Qw8N4GryiqOLB9nhXx2GdlCtNb5CUbglIxDlVwFZ1YS9svP6azQ0ZXRsba

