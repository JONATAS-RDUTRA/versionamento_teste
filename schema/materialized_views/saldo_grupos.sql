--
-- PostgreSQL database dump
--

\restrict 8aa9xHP7u3nUTzbcjgrt5LefP95OLo2eAviBDQXGw47R131rjSzWKebZyVd0l49

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
-- Name: saldo_grupos; Type: MATERIALIZED VIEW; Schema: public; Owner: -
--

CREATE MATERIALIZED VIEW public.saldo_grupos
WITH (autovacuum_vacuum_scale_factor='0.06871') AS
 SELECT id_grupo,
    idproduto,
    data,
    ano,
    mes,
    trimestre,
    cod_trimestre,
    processamento,
    entradas,
    saidas,
    estoque,
    cmm,
    cmm_diario,
    cmm_std,
    tempo_ressuprimento,
    desvio_padrao_ressuprimento,
    arvore_decisao,
    fes,
    nivel_servico,
    esseg,
    round((esseg + (cmm * (tempo_ressuprimento + desvio_padrao_ressuprimento))), 2) AS ppd,
        CASE
            WHEN ((nivel_servico)::text = 'OCASIONAL'::text) THEN round(((esseg + (cmm * (tempo_ressuprimento + desvio_padrao_ressuprimento))) + (cmm / (2)::numeric)), 2)
            ELSE round(((esseg + (cmm * (tempo_ressuprimento + desvio_padrao_ressuprimento))) + cmm), 2)
        END AS emax
   FROM ( SELECT gf.id_grupo,
            sf.idproduto,
            sf.data,
            sf.ano,
            sf.mes,
            sf.trimestre,
            sf.cod_trimestre,
            now() AS processamento,
            sum(sf.entradas) AS entradas,
            sum(sf.saidas) AS saidas,
            sum(sf.estoque) AS estoque,
            sum(sf.media_trimestre) AS cmm,
            sum(sf.media_diaria_trimestre) AS cmm_diario,
            sum(sf.desvio_padrao_trimestre) AS cmm_std,
            avg(sf.tempo_ressuprimento) AS tempo_ressuprimento,
            avg(sf.desvio_padrao_ressuprimento) AS desvio_padrao_ressuprimento,
            pg.arvore_decisao,
            pg.fes,
            pg.nivel_servico,
                CASE
                    WHEN ((pg.nivel_servico)::text = 'OCASIONAL'::text) THEN round((sum(sf.media_trimestre) / (2)::numeric), 2)
                    WHEN (sum(sf.desvio_padrao_trimestre) = (0)::numeric) THEN round((sum(sf.media_trimestre) * pg.fes), 2)
                    ELSE round((sum(sf.desvio_padrao_trimestre) * pg.fes), 2)
                END AS esseg
           FROM ((public.saldo_filiais sf
             JOIN public.grupo_filial gf ON ((gf.filial = sf.filial)))
             JOIN public.prismas_grupos pg ON (((pg.id_grupo = gf.id_grupo) AND ((pg.idproduto)::text = (sf.idproduto)::text) AND (pg.data_ref = (date_trunc('month'::text, (sf.data)::timestamp with time zone))::date))))
          WHERE ((sf.data >= (('now'::text)::date - 365)) AND (sf.data <= (('now'::text)::date - 1)))
          GROUP BY gf.id_grupo, sf.idproduto, sf.data, sf.ano, sf.mes, sf.trimestre, sf.cod_trimestre, pg.arvore_decisao, pg.fes, pg.nivel_servico) a
  WITH NO DATA;


--
-- Name: saldo_grupos_data_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX saldo_grupos_data_idx ON public.saldo_grupos USING btree (data, idproduto);


--
-- Name: saldo_grupos_id_grupo_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX saldo_grupos_id_grupo_idx ON public.saldo_grupos USING btree (id_grupo, idproduto, data);


--
-- PostgreSQL database dump complete
--

\unrestrict 8aa9xHP7u3nUTzbcjgrt5LefP95OLo2eAviBDQXGw47R131rjSzWKebZyVd0l49

