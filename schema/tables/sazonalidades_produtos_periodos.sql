--
-- PostgreSQL database dump
--

\restrict W7YdOfTznpW3CAAJYGHYTLdiD0l14C10b6O5gSxPuagLi3jXXWBr7Xb7Tc3Wmon

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
-- Name: sazonalidades_produtos_periodos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."sazonalidades_produtos_periodos" (
    "filial" integer NOT NULL,
    "idproduto" character varying NOT NULL,
    "data_inicial" "date" NOT NULL,
    "data_final" "date" NOT NULL,
    "media_periodo" numeric(12,2),
    "media_aplicada" numeric(12,2) DEFAULT 0,
    "status" character(1) DEFAULT 'N'::"bpchar" NOT NULL,
    "aplicado" character varying(1) DEFAULT 0
);


--
-- Name: COLUMN "sazonalidades_produtos_periodos"."status"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."sazonalidades_produtos_periodos"."status" IS 'S - sim, N - não';


--
-- PostgreSQL database dump complete
--

\unrestrict W7YdOfTznpW3CAAJYGHYTLdiD0l14C10b6O5gSxPuagLi3jXXWBr7Xb7Tc3Wmon

