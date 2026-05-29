--
-- PostgreSQL database dump
--

\restrict dPsC14p7OzJhFG2omgeYXzOoeFzshL9lvk0k9WpbjbJ66WkQTqGkogqePQbRbGS

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
-- Name: sys_rodadas_compra_sazonal; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."sys_rodadas_compra_sazonal" (
    "id" bigint NOT NULL,
    "id_usuario" integer NOT NULL,
    "nome" character varying(100) NOT NULL,
    "data_inicio_referencia" "date" NOT NULL,
    "data_fim_referencia" "date" NOT NULL,
    "data_inicio_aplicacao" "date" NOT NULL,
    "data_fim_aplicacao" "date" NOT NULL,
    "created_at" timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: sys_rodadas_compra_sazonal_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."sys_rodadas_compra_sazonal_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sys_rodadas_compra_sazonal_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."sys_rodadas_compra_sazonal_id_seq" OWNED BY "public"."sys_rodadas_compra_sazonal"."id";


--
-- Name: sys_rodadas_compra_sazonal id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."sys_rodadas_compra_sazonal" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."sys_rodadas_compra_sazonal_id_seq"'::"regclass");


--
-- Name: sys_rodadas_compra_sazonal sys_rodadas_compra_sazonal_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."sys_rodadas_compra_sazonal"
    ADD CONSTRAINT "sys_rodadas_compra_sazonal_pkey" PRIMARY KEY ("id");


--
-- Name: sys_rodadas_compra_sazonal sys_rodadas_compra_sazonal_usuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."sys_rodadas_compra_sazonal"
    ADD CONSTRAINT "sys_rodadas_compra_sazonal_usuario_fkey" FOREIGN KEY ("id_usuario") REFERENCES "public"."users"("id");


--
-- PostgreSQL database dump complete
--

\unrestrict dPsC14p7OzJhFG2omgeYXzOoeFzshL9lvk0k9WpbjbJ66WkQTqGkogqePQbRbGS

