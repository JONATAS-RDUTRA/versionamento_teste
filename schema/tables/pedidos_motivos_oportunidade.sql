--
-- PostgreSQL database dump
--

\restrict aFGtw7AUTQ6RK2eme7e2TQWriovKFoORhAYJtAgsD6vDb7aGMmhP6WfKLFXShOD

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
-- Name: pedidos_motivos_oportunidade; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."pedidos_motivos_oportunidade" (
    "idpedido" bigint NOT NULL,
    "idproduto" character varying(25) NOT NULL,
    "idmotivo" integer NOT NULL
);


--
-- Name: pedidos_motivos_oportunidade pk_pedidos_motivos_oportunidade; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."pedidos_motivos_oportunidade"
    ADD CONSTRAINT "pk_pedidos_motivos_oportunidade" PRIMARY KEY ("idpedido", "idproduto", "idmotivo");


--
-- Name: pedidos_motivos_oportunidade fk_idmotivo; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."pedidos_motivos_oportunidade"
    ADD CONSTRAINT "fk_idmotivo" FOREIGN KEY ("idmotivo") REFERENCES "public"."motivos_compras_oportunidade"("id");


--
-- Name: pedidos_motivos_oportunidade fk_idpedido; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."pedidos_motivos_oportunidade"
    ADD CONSTRAINT "fk_idpedido" FOREIGN KEY ("idpedido") REFERENCES "public"."pedidos_compras"("idpedido");


--
-- PostgreSQL database dump complete
--

\unrestrict aFGtw7AUTQ6RK2eme7e2TQWriovKFoORhAYJtAgsD6vDb7aGMmhP6WfKLFXShOD

