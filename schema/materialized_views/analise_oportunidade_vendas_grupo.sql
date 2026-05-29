--
-- PostgreSQL database dump
--

\restrict yoTfKqBNuymZBq84NFhHRRkSkllvFZGoo5vGQneYeiAbYr9zgfm17dBYkJFHSuN

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
-- Name: analise_oportunidade_vendas_grupo; Type: MATERIALIZED VIEW; Schema: public; Owner: -
--

CREATE MATERIALIZED VIEW public.analise_oportunidade_vendas_grupo AS
 WITH movimento AS (
         SELECT totais.filial,
            totais.idproduto,
            totais.ano,
            totais.trimestre,
            totais.mes,
            totais.cod_trimestre,
            avg(totais.media_trimestre) AS media_trimestre,
            avg(totais.media_diaria_trimestre) AS media_diaria_trimestre,
            sum(totais.saidas) AS total_saida_trimestre,
            avg(totais.coeficiente_variacao) AS cof_variacao,
            sum(totais.p) AS ganho,
            sum(totais.n) AS perda
           FROM ( SELECT saldos.filial,
                    saldos.idproduto,
                    saldos.ano,
                    saldos.trimestre,
                    saldos.mes,
                    saldos.cod_trimestre,
                    saldos.media_trimestre,
                    saldos.media_diaria_trimestre,
                    saldos.saidas,
                        CASE
                            WHEN ((saldos.saidas - saldos.media_diaria_trimestre) > (0)::numeric) THEN (saldos.saidas - saldos.media_diaria_trimestre)
                            ELSE (0)::numeric
                        END AS p,
                        CASE
                            WHEN ((saldos.saidas - saldos.media_diaria_trimestre) < (0)::numeric) THEN (saldos.saidas - saldos.media_diaria_trimestre)
                            ELSE (0)::numeric
                        END AS n,
                    saldos.coeficiente_variacao
                   FROM public.saldo_filiais saldos
                  WHERE ((saldos.data >= (date_trunc('month'::text, ((('now'::text)::date - 365))::timestamp with time zone))::date) AND (saldos.data <= ((date_trunc('month'::text, (('now'::text)::date)::timestamp with time zone))::date - 1)))) totais
          GROUP BY totais.filial, totais.ano, totais.trimestre, totais.mes, totais.idproduto, totais.cod_trimestre
        )
 SELECT gf.id_grupo,
    movimento.filial,
    movimento.idproduto,
    produtos.descricao_produto,
    movimento.ano,
    movimento.trimestre,
    movimento.mes,
    movimento.cod_trimestre,
    movimento.media_trimestre,
    movimento.media_diaria_trimestre,
    movimento.total_saida_trimestre,
    movimento.cof_variacao,
    (produtos.valor_unitario * produtos.fator_conversao) AS valor_unitario,
    produtos.idfamilia_produto,
    familia_produtos.descricao_familia_produto,
        CASE
            WHEN ((movimento.total_saida_trimestre - movimento.media_trimestre) > (0)::numeric) THEN (movimento.total_saida_trimestre - movimento.media_trimestre)
            ELSE (0)::numeric
        END AS ganho_mensal,
        CASE
            WHEN ((movimento.total_saida_trimestre - movimento.media_trimestre) < (0)::numeric) THEN (movimento.total_saida_trimestre - movimento.media_trimestre)
            ELSE (0)::numeric
        END AS ganho_perda,
        CASE
            WHEN ((movimento.total_saida_trimestre - movimento.media_trimestre) < (0)::numeric) THEN ((movimento.total_saida_trimestre - movimento.media_trimestre) * (produtos.valor_unitario * produtos.fator_conversao))
            ELSE (0)::numeric
        END AS total_mensal_perda,
        CASE
            WHEN ((movimento.total_saida_trimestre - movimento.media_trimestre) > (0)::numeric) THEN ((movimento.total_saida_trimestre - movimento.media_trimestre) * (produtos.valor_unitario * produtos.fator_conversao))
            ELSE (0)::numeric
        END AS total_mensal_ganho,
    produtos.fator_conversao,
    produtos.nivel_servico
   FROM (((movimento
     JOIN public.produtos_filial produtos ON (((produtos.filial = movimento.filial) AND ((produtos.idproduto)::text = (movimento.idproduto)::text))))
     JOIN public.familia_produtos ON ((familia_produtos.idfamilia_produto = produtos.idfamilia_produto)))
     JOIN public.grupo_filial gf ON ((gf.filial = produtos.filial)))
  WHERE ((produtos.revenda)::text = 'S'::text)
  ORDER BY gf.id_grupo, movimento.idproduto, movimento.filial, movimento.ano, movimento.trimestre, movimento.mes
  WITH NO DATA;


--
-- PostgreSQL database dump complete
--

\unrestrict yoTfKqBNuymZBq84NFhHRRkSkllvFZGoo5vGQneYeiAbYr9zgfm17dBYkJFHSuN

