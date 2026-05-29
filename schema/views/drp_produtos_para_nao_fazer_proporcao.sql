--
-- PostgreSQL database dump
--

\restrict CqBqaTjAmijwp7Mf1EVhODY4spyy7IBpfIMsOi66207GKfme3ohymueirNnnEJh

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
-- Name: drp_produtos_para_nao_fazer_proporcao; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.drp_produtos_para_nao_fazer_proporcao AS
 SELECT filial,
    idproduto
   FROM public.produtos_filial
  WHERE ((aplicacao_produto)::text = 'A'::text)
 LIMIT 0;


--
-- PostgreSQL database dump complete
--

\unrestrict CqBqaTjAmijwp7Mf1EVhODY4spyy7IBpfIMsOi66207GKfme3ohymueirNnnEJh

