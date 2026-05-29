--
-- PostgreSQL database dump
--

\restrict Fc6EBN9vKoBGRjAC9hbRGaVb1t3qakmfO8xFHAk3UlDSlzVxX3XcreINJ4sGblJ

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
-- Name: analise_movimentacoes_categoria_mp_pa; Type: MATERIALIZED VIEW; Schema: public; Owner: -
--

CREATE MATERIALIZED VIEW public.analise_movimentacoes_categoria_mp_pa AS
 SELECT l.tipo,
    l.mes,
    l.ano,
    l.id_grupo,
    l.id,
    l.nome,
    l.total
   FROM ( WITH _produtos AS (
                 SELECT DISTINCT pcmp.id_categoria,
                    pcmp.id_produto_pa AS idproduto
                   FROM public.produtos_categoria_mp_pa pcmp
                UNION
                 SELECT DISTINCT pcmp.id_categoria,
                    pcmp.id_produto_mp AS idproduto
                   FROM public.produtos_categoria_mp_pa pcmp
                )
         SELECT 'SD'::text AS tipo,
            to_char((c.emissao)::timestamp with time zone, 'MM'::text) AS mes,
            to_char((c.emissao)::timestamp with time zone, 'YYYY'::text) AS ano,
            g.id_grupo,
            cmp.id,
            cmp.nome,
            round((sum((c.qtde * (c.valor_unit)::double precision)))::numeric, 2) AS total
           FROM ((((public.consumos c
             JOIN public.grupo_filial g ON ((g.filial = c.filial)))
             JOIN public.produtos_compras_grupo pcg ON (((pcg.id_grupo = g.id_grupo) AND ((pcg.idproduto)::text = (c.idproduto)::text))))
             JOIN _produtos p ON (((p.idproduto)::text = (pcg.idproduto)::text)))
             JOIN public.categorias_mp_pa cmp ON ((cmp.id = p.id_categoria)))
          WHERE ((c.emissao >= public.first_day((('now'::text)::date - 365))) AND (c.emissao <= ('now'::text)::date) AND ((c.status)::text <> 'ATENDIDO PRODUCAO'::text))
          GROUP BY (to_char((c.emissao)::timestamp with time zone, 'YYYY'::text)), (to_char((c.emissao)::timestamp with time zone, 'MM'::text)), cmp.id, cmp.nome, g.id_grupo) l
UNION ALL
 SELECT l.tipo,
    l.mes,
    l.ano,
    l.id_grupo,
    l.id,
    l.nome,
    l.total
   FROM ( WITH materia_prima AS (
                 SELECT DISTINCT pcmp.id_categoria,
                    pcmp.id_produto_mp AS idproduto
                   FROM public.produtos_categoria_mp_pa pcmp
                )
         SELECT 'RQ'::text AS tipo,
            to_char((r.data_solicitacao)::timestamp with time zone, 'MM'::text) AS mes,
            to_char((r.data_solicitacao)::timestamp with time zone, 'YYYY'::text) AS ano,
            g.id_grupo,
            cmp.id,
            cmp.nome,
            round((sum((r.qtde * r.pcompra)))::numeric, 2) AS total
           FROM ((((public.requisicoes r
             JOIN public.grupo_filial g ON ((g.filial = r.idfilial)))
             JOIN public.produtos_compras_grupo pcg ON (((pcg.id_grupo = g.id_grupo) AND ((pcg.idproduto)::text = (r.idproduto)::text))))
             JOIN materia_prima mp ON (((mp.idproduto)::text = (r.idproduto)::text)))
             JOIN public.categorias_mp_pa cmp ON ((cmp.id = mp.id_categoria)))
          WHERE ((r.data_solicitacao >= public.first_day((('now'::text)::date - 365))) AND (r.data_solicitacao <= ('now'::text)::date))
          GROUP BY (to_char((r.data_solicitacao)::timestamp with time zone, 'YYYY'::text)), (to_char((r.data_solicitacao)::timestamp with time zone, 'MM'::text)), cmp.id, cmp.nome, g.id_grupo) l
  WITH NO DATA;


--
-- PostgreSQL database dump complete
--

\unrestrict Fc6EBN9vKoBGRjAC9hbRGaVb1t3qakmfO8xFHAk3UlDSlzVxX3XcreINJ4sGblJ

