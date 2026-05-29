--
-- PostgreSQL database dump
--

\restrict suoVj1GqWjnq8c24ZugesehbzfhSw1KpqbDtpigLvNhSbh6h1mOc6cgdCb1U7Lz

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
-- Name: motivos_para_produto_silenciado; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."motivos_para_produto_silenciado" (
    "id_notif" bigint NOT NULL,
    "id_motivo" bigint NOT NULL
);


--
-- Name: motivos_para_produto_silenciado id_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."motivos_para_produto_silenciado"
    ADD CONSTRAINT "id_pkey" PRIMARY KEY ("id_notif", "id_motivo");


--
-- Name: motivos_para_produto_silenciado fk_motivo_blacklist_produto; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."motivos_para_produto_silenciado"
    ADD CONSTRAINT "fk_motivo_blacklist_produto" FOREIGN KEY ("id_motivo") REFERENCES "public"."motivo_blacklist_produto"("id");


--
-- Name: motivos_para_produto_silenciado fk_notificacao_produtos_blacklist; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."motivos_para_produto_silenciado"
    ADD CONSTRAINT "fk_notificacao_produtos_blacklist" FOREIGN KEY ("id_notif") REFERENCES "public"."notificacao_produtos_blacklist"("id");


--
-- PostgreSQL database dump complete
--

\unrestrict suoVj1GqWjnq8c24ZugesehbzfhSw1KpqbDtpigLvNhSbh6h1mOc6cgdCb1U7Lz

