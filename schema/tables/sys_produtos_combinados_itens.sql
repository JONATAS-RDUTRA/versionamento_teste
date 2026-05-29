--
-- PostgreSQL database dump
--

\restrict VJO1ZGFPwKeIPXQ1jqIZTPGcKKdzCuLm8UG0uVtzOTDsLWGSKp2ltKCNZJVg5xL

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
-- Name: sys_produtos_combinados_itens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."sys_produtos_combinados_itens" (
    "id_produto_combinado" character varying(36) NOT NULL,
    "idproduto" character varying(60) NOT NULL,
    "fator_conversao" numeric(12,4) DEFAULT 1 NOT NULL,
    "produto_pai" boolean DEFAULT true
);


--
-- Name: sys_produtos_combinados_itens pk_sys_produtos_combinados_itens; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."sys_produtos_combinados_itens"
    ADD CONSTRAINT "pk_sys_produtos_combinados_itens" PRIMARY KEY ("id_produto_combinado", "idproduto");


--
-- Name: sys_produtos_combinados_itens fk_sys_produtos_combinados_itens; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."sys_produtos_combinados_itens"
    ADD CONSTRAINT "fk_sys_produtos_combinados_itens" FOREIGN KEY ("id_produto_combinado") REFERENCES "public"."sys_produtos_combinados"("id");


--
-- PostgreSQL database dump complete
--

\unrestrict VJO1ZGFPwKeIPXQ1jqIZTPGcKKdzCuLm8UG0uVtzOTDsLWGSKp2ltKCNZJVg5xL

