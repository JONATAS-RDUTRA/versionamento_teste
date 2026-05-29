--
-- PostgreSQL database dump
--

\restrict hBmUjsUu12sE4sVbdeoEKMl7BrfeOfkaI0u7cQ3yuxNgRYgvm1BVnBkeI6axm4B

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
-- Name: analise_movimentacoes_departamentos_grupos; Type: MATERIALIZED VIEW; Schema: public; Owner: -
--

CREATE MATERIALIZED VIEW public.analise_movimentacoes_departamentos_grupos AS
 SELECT 'SD'::text AS tipo,
    to_char((c.emissao)::timestamp with time zone, 'MM'::text) AS mes,
    to_char((c.emissao)::timestamp with time zone, 'YYYY'::text) AS ano,
    g.id_grupo,
    p.iddepartamento,
    p.idsecao,
    p.idcategoria,
    d.descricao_departamento,
    round((sum(c.qtde))::numeric, 2) AS quantidade,
    round((sum((c.qtde * (c.valor_unit)::double precision)))::numeric, 2) AS total
   FROM (((public.consumos c
     JOIN public.produtos_filial p ON (((p.filial = c.filial) AND ((p.idproduto)::text = (c.idproduto)::text))))
     JOIN public.departamentos d ON (((d.iddepartamento)::text = (p.iddepartamento)::text)))
     JOIN public.grupo_filial g ON ((g.filial = c.filial)))
  WHERE ((c.emissao >= public.first_day((('now'::text)::date - 365))) AND (c.emissao <= ('now'::text)::date))
  GROUP BY (to_char((c.emissao)::timestamp with time zone, 'YYYY'::text)), (to_char((c.emissao)::timestamp with time zone, 'MM'::text)), p.iddepartamento, p.idsecao, p.idcategoria, d.descricao_departamento, g.id_grupo
UNION ALL
 SELECT 'RQ'::text AS tipo,
    to_char((r.data_solicitacao)::timestamp with time zone, 'MM'::text) AS mes,
    to_char((r.data_solicitacao)::timestamp with time zone, 'YYYY'::text) AS ano,
    g.id_grupo,
    p.iddepartamento,
    p.idsecao,
    p.idcategoria,
    d.descricao_departamento,
    round((sum(r.qtde))::numeric, 2) AS quantidade,
    round((sum((r.qtde * r.pcompra)))::numeric, 2) AS total
   FROM (((public.requisicoes r
     JOIN public.produtos_filial p ON ((((p.idproduto)::text = (r.idproduto)::text) AND (p.filial = r.idfilial))))
     JOIN public.departamentos d ON (((d.iddepartamento)::text = (p.iddepartamento)::text)))
     JOIN public.grupo_filial g ON ((g.filial = r.idfilial)))
  WHERE ((r.data_solicitacao >= public.first_day((('now'::text)::date - 365))) AND (r.data_solicitacao <= ('now'::text)::date))
  GROUP BY (to_char((r.data_solicitacao)::timestamp with time zone, 'YYYY'::text)), (to_char((r.data_solicitacao)::timestamp with time zone, 'MM'::text)), p.iddepartamento, p.idsecao, p.idcategoria, d.descricao_departamento, g.id_grupo
UNION ALL
 SELECT 'EN'::text AS tipo,
    to_char((m.data_entrada)::timestamp with time zone, 'MM'::text) AS mes,
    to_char((m.data_entrada)::timestamp with time zone, 'YYYY'::text) AS ano,
    g.id_grupo,
    p.iddepartamento,
    p.idsecao,
    p.idcategoria,
    d.descricao_departamento,
    round((sum(m.qtde))::numeric, 2) AS quantidade,
    round((sum((m.qtde * (m.custo_unit)::double precision)))::numeric, 2) AS total
   FROM (((public.entrada_mercadorias m
     JOIN public.produtos_filial p ON ((((p.idproduto)::text = (m.idproduto)::text) AND (p.filial = m.idfilial))))
     JOIN public.departamentos d ON (((d.iddepartamento)::text = (p.iddepartamento)::text)))
     JOIN public.grupo_filial g ON ((g.filial = m.idfilial)))
  WHERE ((m.data_entrada >= public.first_day((('now'::text)::date - 365))) AND (m.data_entrada <= ('now'::text)::date))
  GROUP BY (to_char((m.data_entrada)::timestamp with time zone, 'YYYY'::text)), (to_char((m.data_entrada)::timestamp with time zone, 'MM'::text)), p.iddepartamento, p.idsecao, p.idcategoria, d.descricao_departamento, g.id_grupo
  WITH NO DATA;


--
-- Name: analise_movimentacoes_departamentos_grupos_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX analise_movimentacoes_departamentos_grupos_idx ON public.analise_movimentacoes_departamentos_grupos USING btree (tipo, ano, mes, idcategoria);


--
-- PostgreSQL database dump complete
--

\unrestrict hBmUjsUu12sE4sVbdeoEKMl7BrfeOfkaI0u7cQ3yuxNgRYgvm1BVnBkeI6axm4B

