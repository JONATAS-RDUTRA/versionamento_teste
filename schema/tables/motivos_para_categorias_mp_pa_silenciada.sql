--
-- PostgreSQL database dump
--

\restrict xrSiPOqPRy9hnXDYrEGetxDE6PCtP3cPdkYfWpHs5Ho3ybcqnKsT3X5XaS5hIso

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
-- Name: motivos_para_categorias_mp_pa_silenciada; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."motivos_para_categorias_mp_pa_silenciada" (
    "id_notif" bigint NOT NULL,
    "id_motivo" bigint NOT NULL
);


--
-- Name: motivos_para_categorias_mp_pa_silenciada motivos_para_categorias_mp_pa_silenciado_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."motivos_para_categorias_mp_pa_silenciada"
    ADD CONSTRAINT "motivos_para_categorias_mp_pa_silenciado_pk" PRIMARY KEY ("id_notif", "id_motivo");


--
-- Name: motivos_para_categorias_mp_pa_silenciada fk_motivo_blacklist_produto; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."motivos_para_categorias_mp_pa_silenciada"
    ADD CONSTRAINT "fk_motivo_blacklist_produto" FOREIGN KEY ("id_motivo") REFERENCES "public"."motivo_blacklist_produto"("id");


--
-- Name: motivos_para_categorias_mp_pa_silenciada fk_notificacao_categorias_mp_pa_blacklist; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."motivos_para_categorias_mp_pa_silenciada"
    ADD CONSTRAINT "fk_notificacao_categorias_mp_pa_blacklist" FOREIGN KEY ("id_notif") REFERENCES "public"."notificacao_categorias_mp_pa_blacklist"("id");


--
-- PostgreSQL database dump complete
--

\unrestrict xrSiPOqPRy9hnXDYrEGetxDE6PCtP3cPdkYfWpHs5Ho3ybcqnKsT3X5XaS5hIso

