--
-- PostgreSQL database dump
--

\restrict hib1orpLaIqevgaldOJX0iXL5q2bbBDrlCo4dmcNkA5qXMUxCtOOGHfuBog1RFV

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
-- Name: aplicativos_perfil; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."aplicativos_perfil" (
    "idaplicativo" integer NOT NULL,
    "idperfil" integer NOT NULL,
    "add" character varying(1) DEFAULT 'N'::character varying NOT NULL,
    "del" character varying(1) DEFAULT 'N'::character varying NOT NULL,
    "edit" character varying(1) DEFAULT 'N'::character varying NOT NULL,
    "view" character varying(1) DEFAULT 'N'::character varying NOT NULL
);


--
-- Name: aplicativos_perfil aplicativos_perfil_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."aplicativos_perfil"
    ADD CONSTRAINT "aplicativos_perfil_pkey" PRIMARY KEY ("idaplicativo", "idperfil");


--
-- Name: fk_aplicativos_has_perfil_aplicativos1_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "fk_aplicativos_has_perfil_aplicativos1_idx" ON "public"."aplicativos_perfil" USING "btree" ("idaplicativo");


--
-- Name: fk_aplicativos_has_perfil_perfil1_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "fk_aplicativos_has_perfil_perfil1_idx" ON "public"."aplicativos_perfil" USING "btree" ("idperfil");


--
-- Name: aplicativos_perfil fk_aplicativos_has_perfil_aplicativos1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."aplicativos_perfil"
    ADD CONSTRAINT "fk_aplicativos_has_perfil_aplicativos1" FOREIGN KEY ("idaplicativo") REFERENCES "public"."aplicativos"("idaplicativo");


--
-- Name: aplicativos_perfil fk_aplicativos_has_perfil_perfil1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."aplicativos_perfil"
    ADD CONSTRAINT "fk_aplicativos_has_perfil_perfil1" FOREIGN KEY ("idperfil") REFERENCES "public"."perfil"("idperfil");


--
-- PostgreSQL database dump complete
--

\unrestrict hib1orpLaIqevgaldOJX0iXL5q2bbBDrlCo4dmcNkA5qXMUxCtOOGHfuBog1RFV

