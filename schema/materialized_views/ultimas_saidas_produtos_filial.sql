--
-- PostgreSQL database dump
--

\restrict QahWfR301UnuVZl00q4xcalGBM8TThPfAbOT7cMvf9cuVTKQaeJbUaxaSr7dMq2

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

SET default_table_access_method = heap;

--
-- Name: ultimas_saidas_produtos_filial; Type: MATERIALIZED VIEW; Schema: public; Owner: -
--

CREATE MATERIALIZED VIEW public.ultimas_saidas_produtos_filial AS
 SELECT pf.idproduto,
    pf.filial,
    pf.iddepartamento,
    pf.idsecao,
    pf.idcategoria,
    max(c.emissao) AS ultima_saida
   FROM (public.consumos c
     JOIN public.produtos_filial pf ON (((pf.filial = c.filial) AND ((pf.idproduto)::text = (c.idproduto)::text))))
  GROUP BY pf.idproduto, pf.filial, pf.iddepartamento, pf.idsecao, pf.idcategoria
  WITH NO DATA;


--
-- PostgreSQL database dump complete
--

\unrestrict QahWfR301UnuVZl00q4xcalGBM8TThPfAbOT7cMvf9cuVTKQaeJbUaxaSr7dMq2

