--
-- PostgreSQL database dump
--

\restrict KUNgDVQNl0WcS7FhJqV3hiWRDZ9HT4Ghbz8AALuD8HQUQcfo0XNQbQ5H013I7JZ

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
-- Name: vw_analise_drp_parametrizada_reverso; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.vw_analise_drp_parametrizada_reverso AS
 SELECT a.filial,
    a.idproduto,
    a.descricao_produto,
    a.estoque,
    a.unidade_compra,
    a.idunidade_medida,
    a.cobertura_drp,
    a.tempo_ressuprimento_drp,
    a.demanda_cobertura_drp,
    a.esseg_drp,
    a.tp_drp,
    a.emax_drp,
    a.consumo_medio_mensal AS cmm_diario,
        CASE
            WHEN (((( SELECT c.drp_pertence_mix
               FROM public.cfgsystem c))::text = 'S'::text) AND (NOT a.pertence_mix_filial)) THEN (0)::numeric
            WHEN ((a.estoque - a.cmm_cmd) < (0)::numeric) THEN public.gerar_lote_embalagem_dist(a.emax_drp, a.multiplo_dist)
            WHEN (a.estoque <= a.tp_drp) THEN public.gerar_lote_embalagem_dist((a.emax_drp - (a.estoque - a.cmm_cmd)), a.multiplo_dist)
            WHEN ((a.estoque > a.tp_drp) AND (a.estoque <= a.emax_drp)) THEN (0)::numeric
            ELSE (0)::numeric
        END AS sugestao_drp,
    a.fator_conversao,
    a.peso_compras,
    a.embalagem,
    a.cod_produto,
        CASE
            WHEN (((( SELECT c.drp_pertence_mix
               FROM public.cfgsystem c))::text = 'S'::text) AND (NOT a.pertence_mix_filial)) THEN 'DISP DRP'::text
            WHEN (a.estoque <= a.tp_drp) THEN 'DRP'::text
            WHEN ((a.estoque > a.tp_drp) AND (a.estoque <= a.emax_drp)) THEN 'OK'::text
            ELSE 'DISP DRP'::text
        END AS status_drp,
    a.idfornecedor,
    f.razao_social,
    a.item_novo,
    a.estoque_maximo,
    a.multiplo_dist,
    round(((((a.cobertura_drp + a.tempo_ressuprimento_drp))::numeric * (a.consumo_medio_mensal + a.desvio_padrao_consumo)) / (30)::numeric), 4) AS emax_reverso,
    a.primeira_entrada,
    a.idfamilia_produto,
    a.estoque_min,
    a.pertence_mix_filial
   FROM (( SELECT p.filial,
            p.idproduto,
            p.unidade_master AS unidade_compra,
            p.idunidade_medida,
            p.embalagem,
            p.cod_produto,
            p.descricao_produto,
            p.estoque_seguranca,
            p.multiplo_compra AS fator_conversao,
            p.consumo_medio_mensal,
            p.desvio_padrao_consumo,
            (((p.desvio_padrao_consumo / (30)::numeric) * (g.tempo_ressuprimento_drp_reverso)::numeric) + ((p.consumo_medio_mensal / (30)::numeric) * (g.tempo_ressuprimento_drp_reverso)::numeric)) AS cmm_cmd,
                CASE
                    WHEN (round((((COALESCE(p.estoque, (0)::numeric) - COALESCE(p.estoque_bloqueado, (0)::numeric)) - COALESCE(p.estoque_reservado, (0)::numeric)) - COALESCE(p.estoque_similar, (0)::numeric)), 4) < (0)::numeric) THEN (0)::numeric
                    ELSE round((((COALESCE(p.estoque, (0)::numeric) - COALESCE(p.estoque_bloqueado, (0)::numeric)) - COALESCE(p.estoque_reservado, (0)::numeric)) - COALESCE(p.estoque_similar, (0)::numeric)), 4)
                END AS estoque,
            g.cobertura_drp_reverso AS cobertura_drp,
            g.tempo_ressuprimento_drp_reverso AS tempo_ressuprimento_drp,
            (((g.cobertura_drp_reverso / 30))::numeric * p.consumo_medio_mensal) AS demanda_cobertura_drp,
            ((p.consumo_medio_mensal / (30)::numeric) * ((g.cobertura_drp_reverso)::numeric * 0.30)) AS esseg_drp,
            ((p.consumo_medio_mensal / (30)::numeric) * ((g.cobertura_drp_reverso)::numeric * 0.70)) AS tp_drp,
            ((p.consumo_medio_mensal / (30)::numeric) * (g.cobertura_drp_reverso)::numeric) AS emax_drp,
            p.peso_compras,
            p.idfornecedor,
            p.embalagem_master,
                CASE
                    WHEN ((('now'::text)::date - p.data_cadastro) > 180) THEN 'N'::text
                    ELSE 'S'::text
                END AS item_novo,
            p.estoque_maximo,
            COALESCE(NULLIF(pd.multiplo_dist, (0)::numeric), (1)::numeric) AS multiplo_dist,
            COALESCE(NULLIF(pd.primeira_entrada, '1900-01-01'::date), COALESCE(p.data_cadastro, (CURRENT_DATE - 1))) AS primeira_entrada,
            p.idfamilia_produto,
            pd.estoque_min,
            (pd.idproduto IS NOT NULL) AS pertence_mix_filial
           FROM ((public.produtos_filial p
             JOIN public.grupo_filial g ON ((p.filial = g.filial)))
             LEFT JOIN public.cfg_produto_distribuicao pd ON (((pd.filial = p.filial) AND ((pd.idproduto)::text = (p.idproduto)::text))))
          WHERE (((p.revenda)::text = 'S'::text) AND ((p.status)::text <> 'FL'::text) AND (p.consumo_medio_mensal > (0)::numeric))) a
     JOIN public.fornecedor f ON ((f.id = a.idfornecedor)));


--
-- PostgreSQL database dump complete
--

\unrestrict KUNgDVQNl0WcS7FhJqV3hiWRDZ9HT4Ghbz8AALuD8HQUQcfo0XNQbQ5H013I7JZ

