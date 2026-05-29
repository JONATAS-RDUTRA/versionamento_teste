--
-- PostgreSQL database dump
--

\restrict eYSZw4Lh0IwY4zLHg6HUfWwBBhYCfVHJZAMWcvnfhZHkjlggnWedLIZT5M5zycQ

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
-- Name: distribuicao_drp_exportacao_protheus; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."distribuicao_drp_exportacao_protheus" (
    "idpedido" bigint NOT NULL,
    "exportacao" "json" NOT NULL,
    "data_exportacao" "date" DEFAULT CURRENT_DATE NOT NULL
);


--
-- Name: distribuicao_drp_exportacao_protheus pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."distribuicao_drp_exportacao_protheus"
    ADD CONSTRAINT "pkey" PRIMARY KEY ("idpedido");


--
-- Name: distribuicao_drp_exportacao_protheus fk_id_pedido; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."distribuicao_drp_exportacao_protheus"
    ADD CONSTRAINT "fk_id_pedido" FOREIGN KEY ("idpedido") REFERENCES "public"."distribuicao_drp"("idpedido");


--
-- PostgreSQL database dump complete
--

\unrestrict eYSZw4Lh0IwY4zLHg6HUfWwBBhYCfVHJZAMWcvnfhZHkjlggnWedLIZT5M5zycQ

