--
-- PostgreSQL database dump
--

\restrict e7iRatQWa3NKbbhhvqegWitOBYQC5cBpEM7nTYeCd1A01bSEgcZ1frBz09pcYth

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
-- Name: analise_mercadorias_forecast_grupo_filial; Type: MATERIALIZED VIEW; Schema: public; Owner: -
--

CREATE MATERIALIZED VIEW public.analise_mercadorias_forecast_grupo_filial AS
 SELECT id_grupo,
    idfornecedor,
    fornecedor,
    idcomprador,
    comprador,
    filial,
    idproduto,
    descricao_produto,
    iddepartamento,
    departamento,
    ((ponto_pedido)::double precision * (fator_conversao)::double precision) AS ponto_pedido,
    ((estoque_futuro)::double precision * (fator_conversao)::double precision) AS estoque_futuro,
    ((estoque_maximo)::double precision * (fator_conversao)::double precision) AS estoque_maximo,
    ((estoque)::double precision * (fator_conversao)::double precision) AS estoque,
    tempo_ressuprimento,
    desvio_padrao_ressuprimento,
    ((consumo_medio_mensal)::double precision * (fator_conversao)::double precision) AS consumo_medio_mensal,
    public.gerar_lote_embalagem((lote_compras * (fator_conversao)::numeric), (lote_minimo * (fator_conversao)::numeric)) AS lote_compras,
    (lote_compras * (fator_conversao)::numeric) AS lote_compras_bruto,
    fator_conversao,
    unidade_compra,
    lote_minimo,
    nivel_servico,
    peso_compras
   FROM ( SELECT previsao.idfornecedor,
            previsao.fornecedor,
            previsao.idcomprador,
            previsao.comprador,
            previsao.filial,
            previsao.idproduto,
            previsao.descricao_produto,
            previsao.ponto_pedido,
            previsao.estoque_futuro,
            previsao.estoque_maximo,
            previsao.estoque,
            previsao.tempo_ressuprimento,
            previsao.desvio_padrao_ressuprimento,
            previsao.consumo_medio_mensal,
            round(((((previsao.estoque_maximo)::double precision + ((previsao.consumo_medio_mensal * (previsao.tempo_ressuprimento + previsao.desvio_padrao_ressuprimento)))::double precision) - (previsao.estoque)::double precision))::numeric, 2) AS lote_compras,
            previsao.fator_conversao,
            previsao.unidade_compra,
            previsao.lote_minimo,
            previsao.id_grupo,
            previsao.iddepartamento,
            previsao.descricao_departamento AS departamento,
            previsao.nivel_servico,
            previsao.peso_compras
           FROM ( SELECT p.filial,
                    p.id_grupo,
                    p.idfornecedor,
                    f.razao_social AS fornecedor,
                    p.idcomprador,
                    c.nome_completo AS comprador,
                    p.idproduto,
                    p.descricao_produto,
                    dep.iddepartamento,
                    dep.descricao_departamento,
                    p.ponto_pedido,
                    public.get_forecast_filial((p.filial)::numeric, p.idproduto, (( SELECT f_1.tempo_forecast
                           FROM public.fornecedor f_1
                          WHERE (f_1.id = p.idfornecedor)))::numeric) AS estoque_futuro,
                    p.estoque_maximo,
                    p.estoque,
                    p.tempo_ressuprimento,
                    p.desvio_padrao_ressuprimento,
                    p.consumo_medio_mensal,
                    p.unidade_compra,
                    p.lote_minimo,
                    1 AS fator_conversao,
                    p.arvore_decisao,
                    p.nivel_servico,
                    p.peso_compras
                   FROM (((public.vw_grupo_compras_produtos_filial p
                     JOIN public.fornecedor f ON ((f.id = p.idfornecedor)))
                     JOIN public.comprador c ON ((c.id = p.idcomprador)))
                     JOIN public.departamentos dep ON ((dep.iddepartamento = p.idfamilia_produto)))
                  WHERE ((p.lote_compras = (0)::numeric) AND (p.consumo_medio_mensal > (0)::numeric) AND (p.compra_transito = (0)::numeric) AND ((p.revenda)::text = 'S'::text) AND ((p.status)::text <> 'FL'::text))) previsao
          WHERE ((previsao.estoque_futuro)::double precision <= (previsao.ponto_pedido)::double precision)) a
  WHERE (public.gerar_lote_embalagem((lote_compras * (fator_conversao)::numeric), lote_minimo) > (0)::numeric)
  WITH NO DATA;


--
-- Name: analise_mercadorias_forecast_grupo_fil_id_grupo_forn; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX analise_mercadorias_forecast_grupo_fil_id_grupo_forn ON public.analise_mercadorias_forecast_grupo_filial USING btree (id_grupo, filial, idfornecedor);


--
-- Name: analise_mercadorias_forecast_grupo_fil_id_grupo_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX analise_mercadorias_forecast_grupo_fil_id_grupo_idx ON public.analise_mercadorias_forecast_grupo_filial USING btree (id_grupo, filial, idproduto);


--
-- PostgreSQL database dump complete
--

\unrestrict e7iRatQWa3NKbbhhvqegWitOBYQC5cBpEM7nTYeCd1A01bSEgcZ1frBz09pcYth

