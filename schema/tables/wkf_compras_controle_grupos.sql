--
-- PostgreSQL database dump
--

\restrict RgUd2jCtpR4wkj6sxwHoc3MsPILJ8uj8NsJdogQKANCaHS8AGtrJHrJdpbcVabA

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
-- Name: wkf_compras_controle_grupos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."wkf_compras_controle_grupos" (
    "id_grupo" bigint NOT NULL,
    "id_wkf_item" bigint NOT NULL,
    "valor" character varying(20),
    "max" character varying(20),
    "min" character varying(20)
);


--
-- Name: wkf_compras_controle_grupos wkf_compras_controle_grupos_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."wkf_compras_controle_grupos"
    ADD CONSTRAINT "wkf_compras_controle_grupos_pk" PRIMARY KEY ("id_grupo", "id_wkf_item");


--
-- Name: wkf_compras_controle_grupos wkf_compras_itens_wkf_compras_controle_grupos_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."wkf_compras_controle_grupos"
    ADD CONSTRAINT "wkf_compras_itens_wkf_compras_controle_grupos_fk" FOREIGN KEY ("id_wkf_item") REFERENCES "public"."wkf_compras_itens"("id");


--
-- PostgreSQL database dump complete
--

\unrestrict RgUd2jCtpR4wkj6sxwHoc3MsPILJ8uj8NsJdogQKANCaHS8AGtrJHrJdpbcVabA

