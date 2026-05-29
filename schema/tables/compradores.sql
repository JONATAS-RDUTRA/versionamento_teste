--
-- PostgreSQL database dump
--

\restrict 96S3fBUF6jkdo1jwgrCJ0PF2oPVtgEjeS57npbhTK2Cb20oA2bkeUDFD7PDD13C

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
-- Name: compradores; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."compradores" (
    "filial" double precision,
    "idcomprador" double precision,
    "comprador" character varying(255),
    "idproduto" character varying(25),
    "produto" character varying(255),
    "idfornecedor" double precision,
    "fornecedor" character varying(255),
    "idfamilia" double precision,
    "familia" character varying(255),
    "idarea" double precision,
    "area" character varying(255)
);


--
-- PostgreSQL database dump complete
--

\unrestrict 96S3fBUF6jkdo1jwgrCJ0PF2oPVtgEjeS57npbhTK2Cb20oA2bkeUDFD7PDD13C

