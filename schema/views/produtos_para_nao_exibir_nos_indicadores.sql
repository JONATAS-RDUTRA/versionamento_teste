--
-- PostgreSQL database dump
--

\restrict t2qDIpQIkpRg4YR8TL9bfIleVTSGn2jDpUnQiEZevaPlRSzhXIDnN82yWn4J1ih

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

--
-- Name: produtos_para_nao_exibir_nos_indicadores; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.produtos_para_nao_exibir_nos_indicadores AS
 SELECT DISTINCT idproduto
   FROM public.produtos_filial pf
 LIMIT 0;


--
-- PostgreSQL database dump complete
--

\unrestrict t2qDIpQIkpRg4YR8TL9bfIleVTSGn2jDpUnQiEZevaPlRSzhXIDnN82yWn4J1ih

