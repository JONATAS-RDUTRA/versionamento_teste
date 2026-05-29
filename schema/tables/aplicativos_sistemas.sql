--
-- PostgreSQL database dump
--

\restrict 4DSV0Ahsoyz5TyTz6kbcgGweHxZryMrAXRPXo8aeU6J4L0MfD92VTjRZNxnYUbj

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
-- Name: aplicativos_sistemas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."aplicativos_sistemas" (
    "id_sistema" integer NOT NULL,
    "id_aplicativo" integer NOT NULL
);


--
-- Name: aplicativos_sistemas aplicativos_sistemas_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."aplicativos_sistemas"
    ADD CONSTRAINT "aplicativos_sistemas_pk" PRIMARY KEY ("id_sistema", "id_aplicativo");


--
-- Name: aplicativos_sistemas fk_id_aplicativo; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."aplicativos_sistemas"
    ADD CONSTRAINT "fk_id_aplicativo" FOREIGN KEY ("id_aplicativo") REFERENCES "public"."aplicativos"("idaplicativo");


--
-- Name: aplicativos_sistemas fk_id_sistema; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."aplicativos_sistemas"
    ADD CONSTRAINT "fk_id_sistema" FOREIGN KEY ("id_sistema") REFERENCES "public"."integracao_sistemas"("id");


--
-- PostgreSQL database dump complete
--

\unrestrict 4DSV0Ahsoyz5TyTz6kbcgGweHxZryMrAXRPXo8aeU6J4L0MfD92VTjRZNxnYUbj

