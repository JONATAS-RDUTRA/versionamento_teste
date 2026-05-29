--
-- PostgreSQL database dump
--

\restrict SozV2hM6FarytZneBPf2kFcv3DlN7s2HGRioVrvw2tOaEL8r38VQwXMbht1WxKh

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
-- Name: consumos_desconsiderados; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."consumos_desconsiderados" (
    "filial" bigint NOT NULL,
    "idconsumo" bigint NOT NULL,
    "emissao" "date" NOT NULL,
    "idproduto" character varying(25) NOT NULL,
    "item" integer NOT NULL,
    "status" character varying(45) NOT NULL,
    "horariomov" character varying(8) NOT NULL,
    "qtde" double precision,
    "id_usuario" integer,
    "created_at" character varying(30)
);


--
-- Name: consumos_desconsiderados consumos_desconsideradas_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."consumos_desconsiderados"
    ADD CONSTRAINT "consumos_desconsideradas_pk" PRIMARY KEY ("filial", "idconsumo", "emissao", "idproduto", "item", "status", "horariomov");


--
-- Name: consumos_desconsiderados fk_id_usuario_consumos_desconsideradas; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."consumos_desconsiderados"
    ADD CONSTRAINT "fk_id_usuario_consumos_desconsideradas" FOREIGN KEY ("id_usuario") REFERENCES "public"."users"("id");


--
-- PostgreSQL database dump complete
--

\unrestrict SozV2hM6FarytZneBPf2kFcv3DlN7s2HGRioVrvw2tOaEL8r38VQwXMbht1WxKh

