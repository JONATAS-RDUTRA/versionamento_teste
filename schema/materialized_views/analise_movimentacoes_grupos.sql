--
-- PostgreSQL database dump
--

\restrict c58tSQ6V3V0YReObIyLfecj9LXC8sYuHuae6Zi7Pm2aY73vnAOzqc1hHpMNHPbF

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
-- Name: analise_movimentacoes_grupos; Type: MATERIALIZED VIEW; Schema: public; Owner: -
--

CREATE MATERIALIZED VIEW public.analise_movimentacoes_grupos AS
 SELECT 'SD'::text AS tipo,
    to_char((c.emissao)::timestamp with time zone, 'MM'::text) AS mes,
    to_char((c.emissao)::timestamp with time zone, 'YYYY'::text) AS ano,
    g.id_grupo,
    p.idfornecedor,
    f.razao_social,
    round((sum((c.qtde * (c.valor_unit)::double precision)))::numeric, 2) AS total
   FROM (((public.consumos c
     JOIN public.produtos_filial p ON (((p.filial = c.filial) AND ((p.idproduto)::text = (c.idproduto)::text))))
     JOIN public.fornecedor f ON ((f.id = p.idfornecedor)))
     JOIN public.grupo_filial g ON ((g.filial = c.filial)))
  WHERE ((c.emissao >= public.first_day((('now'::text)::date - 365))) AND (c.emissao <= ('now'::text)::date) AND ((c.status)::text <> 'ATENDIDO PRODUCAO'::text))
  GROUP BY (to_char((c.emissao)::timestamp with time zone, 'YYYY'::text)), (to_char((c.emissao)::timestamp with time zone, 'MM'::text)), p.idfornecedor, f.razao_social, g.id_grupo
UNION ALL
 SELECT 'RQ'::text AS tipo,
    to_char((r.data_solicitacao)::timestamp with time zone, 'MM'::text) AS mes,
    to_char((r.data_solicitacao)::timestamp with time zone, 'YYYY'::text) AS ano,
    g.id_grupo,
    p.idfornecedor,
    f.razao_social,
    round((sum((r.qtde * r.pcompra)))::numeric, 2) AS total
   FROM (((public.requisicoes r
     JOIN public.produtos_filial p ON ((((p.idproduto)::text = (r.idproduto)::text) AND (p.filial = r.idfilial))))
     JOIN public.fornecedor f ON ((f.id = p.idfornecedor)))
     JOIN public.grupo_filial g ON ((g.filial = r.idfilial)))
  WHERE ((r.data_solicitacao >= public.first_day((('now'::text)::date - 365))) AND (r.data_solicitacao <= ('now'::text)::date))
  GROUP BY (to_char((r.data_solicitacao)::timestamp with time zone, 'YYYY'::text)), (to_char((r.data_solicitacao)::timestamp with time zone, 'MM'::text)), p.idfornecedor, f.razao_social, g.id_grupo
UNION ALL
 SELECT 'EN'::text AS tipo,
    to_char((m.data_entrada)::timestamp with time zone, 'MM'::text) AS mes,
    to_char((m.data_entrada)::timestamp with time zone, 'YYYY'::text) AS ano,
    g.id_grupo,
    p.idfornecedor,
    f.razao_social,
    round((sum((m.qtde * (m.custo_unit)::double precision)))::numeric, 2) AS total
   FROM (((public.entrada_mercadorias m
     JOIN public.produtos_filial p ON ((((p.idproduto)::text = (m.idproduto)::text) AND (p.filial = m.idfilial))))
     JOIN public.fornecedor f ON ((f.id = p.idfornecedor)))
     JOIN public.grupo_filial g ON ((g.filial = m.idfilial)))
  WHERE ((m.data_entrada >= public.first_day((('now'::text)::date - 365))) AND (m.data_entrada <= ('now'::text)::date))
  GROUP BY (to_char((m.data_entrada)::timestamp with time zone, 'YYYY'::text)), (to_char((m.data_entrada)::timestamp with time zone, 'MM'::text)), p.idfornecedor, f.razao_social, g.id_grupo
  WITH NO DATA;


--
-- Name: analise_movimentacoes_grupos_tipo_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX analise_movimentacoes_grupos_tipo_idx ON public.analise_movimentacoes_grupos USING btree (tipo, mes, ano, id_grupo, idfornecedor);


--
-- PostgreSQL database dump complete
--

\unrestrict c58tSQ6V3V0YReObIyLfecj9LXC8sYuHuae6Zi7Pm2aY73vnAOzqc1hHpMNHPbF

