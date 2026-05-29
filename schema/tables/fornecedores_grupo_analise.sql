--
-- PostgreSQL database dump
--

\restrict Z36SuzI9LC2f8Fc8lCf01Gz0YBpcGUYf7RXKooVMguiqMYdOWfAGcD5UKxuN0ec

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
-- Name: fornecedores_grupo_analise; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."fornecedores_grupo_analise" (
    "id" integer NOT NULL,
    "id_grupo_analise" integer NOT NULL,
    "id_fornecedor" bigint NOT NULL,
    "created_at" character varying(30),
    "updated_at" character varying(30),
    "deleted_at" character varying(30),
    "status_tempo_esseg" integer DEFAULT 0
);


--
-- Name: COLUMN "fornecedores_grupo_analise"."status_tempo_esseg"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."fornecedores_grupo_analise"."status_tempo_esseg" IS '1 - CURVAS 2 - DEPARTAMENTO/SEGMENTO 3 - FORNECEDOR 4 - PRODUTO';


--
-- Name: fornecedores_grupo_analise_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."fornecedores_grupo_analise_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fornecedores_grupo_analise_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."fornecedores_grupo_analise_id_seq" OWNED BY "public"."fornecedores_grupo_analise"."id";


--
-- Name: fornecedores_grupo_analise id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."fornecedores_grupo_analise" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."fornecedores_grupo_analise_id_seq"'::"regclass");


--
-- Name: fornecedores_grupo_analise fornecedores_grupo_analise_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."fornecedores_grupo_analise"
    ADD CONSTRAINT "fornecedores_grupo_analise_pk" PRIMARY KEY ("id");


--
-- Name: fornecedores_grupo_analise fk_id_fornecedor; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."fornecedores_grupo_analise"
    ADD CONSTRAINT "fk_id_fornecedor" FOREIGN KEY ("id_fornecedor") REFERENCES "public"."fornecedor"("id");


--
-- Name: fornecedores_grupo_analise fk_id_grupo_analise; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."fornecedores_grupo_analise"
    ADD CONSTRAINT "fk_id_grupo_analise" FOREIGN KEY ("id_grupo_analise") REFERENCES "public"."grupos_analise_fornecedor"("id");


--
-- PostgreSQL database dump complete
--

\unrestrict Z36SuzI9LC2f8Fc8lCf01Gz0YBpcGUYf7RXKooVMguiqMYdOWfAGcD5UKxuN0ec

