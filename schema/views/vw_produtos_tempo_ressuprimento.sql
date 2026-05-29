--
-- PostgreSQL database dump
--

\restrict AzUaV6FFXtzLa4USiJAMxb6umg4ejjrsLU2guuM4CJEdM4R9UhoXRtNVoWnX9cf

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
-- Name: vw_produtos_tempo_ressuprimento; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.vw_produtos_tempo_ressuprimento AS
 SELECT filial,
    idproduto,
    COALESCE(round(avg(tempo_ressuprimento), 2), (2)::numeric) AS tempo_medio_ressuprimento,
    COALESCE(round(stddev_pop(tempo_ressuprimento), 2), (0)::numeric) AS desvio_padrao_ressuprimento
   FROM ( SELECT r.idfilial AS filial,
            r.idproduto,
            r.data_solicitacao,
            r.data_entrega,
                CASE
                    WHEN ((pf.ressuprimento_manual)::text = 'S'::text) THEN pf.ressuprimento_manual_dias
                    ELSE ((r.data_entrega - r.data_solicitacao))::numeric
                END AS tempo_ressuprimento,
            pf.tipo_ressuprimento,
            pf.ressuprimento_manual,
            pf.ressuprimento_manual_dias
           FROM (public.requisicoes r
             JOIN public.produtos_filial pf ON (((pf.filial = r.idfilial) AND ((pf.idproduto)::text = (r.idproduto)::text))))
          WHERE ((r.data_solicitacao >= (('now'::text)::date - 365)) AND (r.data_solicitacao <= ('now'::text)::date))) a
  GROUP BY filial, idproduto;


--
-- PostgreSQL database dump complete
--

\unrestrict AzUaV6FFXtzLa4USiJAMxb6umg4ejjrsLU2guuM4CJEdM4R9UhoXRtNVoWnX9cf

