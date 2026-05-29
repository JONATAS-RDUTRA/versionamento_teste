--
-- PostgreSQL database dump
--

\restrict e83M9TRa8QVxdybE2350O6oo7L0HlI4EbGzfa3DnOaghzobAe5H0cWkdScJqPVF

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
-- Name: analise_mercadorias_transito_grupo; Type: MATERIALIZED VIEW; Schema: public; Owner: -
--

CREATE MATERIALIZED VIEW public.analise_mercadorias_transito_grupo AS
 SELECT id_grupo,
    idfornecedor,
    fornecedor,
    idcomprador,
    comprador,
    idproduto,
    descricao_produto,
    iddepartamento,
    departamento,
    compra_transito,
    (consumo_transito * fator_conversao) AS consumo_transito,
    (saldo_futuro * fator_conversao) AS saldo_futuro,
    (estoque_maximo * (fator_conversao)::double precision) AS estoque_maximo,
    (ponto_pedido * (fator_conversao)::double precision) AS ponto_pedido,
    (consumo_medio_mensal * (fator_conversao)::double precision) AS consumo_medio_mensal,
    tempo_ressuprimento,
    desvio_padrao_ressuprimento,
    ((estoque)::double precision * (fator_conversao)::double precision) AS estoque,
    status,
        CASE
            WHEN ((status = 'PREVISÃO FUTURA EM EXCESSO'::text) AND (abs((lote_compras * (fator_conversao)::double precision)) > (compra_transito)::double precision)) THEN ((compra_transito * ('-1'::integer)::numeric))::double precision
            ELSE (public.gerar_lote_embalagem(((lote_compras * (fator_conversao)::double precision))::numeric, ((lote_minimo)::numeric * fator_conversao)))::double precision
        END AS lote_compras,
    fator_conversao,
    unidade_compra,
    data_ultima_riquisicao,
    (('now'::text)::date - data_ultima_riquisicao) AS tempo_pedido,
    nivel_servico,
    peso_compras,
        CASE
            WHEN (((('now'::text)::date - data_ultima_riquisicao) - 20) < 0) THEN NULL::integer
            ELSE ((('now'::text)::date - data_ultima_riquisicao) - 20)
        END AS gatilho_transito
   FROM ( SELECT analise_entrada.idfornecedor,
            analise_entrada.fornecedor,
            analise_entrada.idcomprador,
            analise_entrada.comprador,
            analise_entrada.idproduto,
            analise_entrada.descricao_produto,
            analise_entrada.compra_transito,
            analise_entrada.consumo_transito,
            analise_entrada.saldo_futuro,
            analise_entrada.estoque_maximo,
            analise_entrada.ponto_pedido,
            analise_entrada.consumo_medio_mensal,
            analise_entrada.tempo_ressuprimento,
            analise_entrada.desvio_padrao_ressuprimento,
            analise_entrada.estoque,
            analise_entrada.fator_conversao,
            analise_entrada.unidade_compra,
            analise_entrada.lote_minimo,
            analise_entrada.data_ultima_riquisicao,
            analise_entrada.id_grupo,
            analise_entrada.iddepartamento,
            analise_entrada.descricao_departamento AS departamento,
            analise_entrada.nivel_servico,
            analise_entrada.peso_compras,
                CASE
                    WHEN ((analise_entrada.status_compra = (0)::numeric) AND ((('now'::text)::date - analise_entrada.data_ultima_riquisicao) > 20) AND ((analise_entrada.saldo_futuro)::double precision > analise_entrada.estoque_maximo)) THEN 'PREVISÃO FUTURA EM EXCESSO'::text
                    WHEN ((analise_entrada.status_compra = (0)::numeric) AND ((('now'::text)::date - analise_entrada.data_ultima_riquisicao) > 20) AND ((analise_entrada.saldo_futuro)::double precision > analise_entrada.ponto_pedido) AND ((analise_entrada.saldo_futuro)::double precision <= analise_entrada.estoque_maximo) AND (((analise_entrada.saldo_futuro)::double precision - (analise_entrada.consumo_medio_mensal * (0.5)::double precision)) > analise_entrada.ponto_pedido)) THEN 'PREVISÃO FUTURA ADEQUADA'::text
                    WHEN ((analise_entrada.status_compra = (0)::numeric) AND ((('now'::text)::date - analise_entrada.data_ultima_riquisicao) > 20) AND ((analise_entrada.saldo_futuro)::double precision > analise_entrada.ponto_pedido) AND ((analise_entrada.saldo_futuro)::double precision <= analise_entrada.estoque_maximo) AND (((analise_entrada.saldo_futuro)::double precision - (analise_entrada.consumo_medio_mensal * (0.5)::double precision)) <= analise_entrada.ponto_pedido)) THEN 'PREVISÃO COM SUTIL EXPOSIÇÃO A RUPTURA'::text
                    WHEN ((analise_entrada.status_compra = (0)::numeric) AND ((('now'::text)::date - analise_entrada.data_ultima_riquisicao) > 20) AND ((analise_entrada.saldo_futuro)::double precision <= analise_entrada.ponto_pedido)) THEN 'PREVISÃO COM ELEVADA EXPOSIÇÃO A RUPTURA'::text
                    WHEN ((analise_entrada.status_compra = (0)::numeric) AND ((('now'::text)::date - analise_entrada.data_ultima_riquisicao) < 20)) THEN 'PRODUTO EM TRANSITO'::text
                    ELSE 'PRIMEIRA COMPRA'::text
                END AS status,
                CASE
                    WHEN ((analise_entrada.status_compra = (0)::numeric) AND ((('now'::text)::date - analise_entrada.data_ultima_riquisicao) > 20) AND ((analise_entrada.saldo_futuro)::double precision > analise_entrada.estoque_maximo)) THEN (analise_entrada.estoque_maximo - (analise_entrada.saldo_futuro)::double precision)
                    WHEN ((analise_entrada.status_compra = (0)::numeric) AND ((('now'::text)::date - analise_entrada.data_ultima_riquisicao) > 20) AND ((analise_entrada.saldo_futuro)::double precision > analise_entrada.ponto_pedido) AND ((analise_entrada.saldo_futuro)::double precision <= analise_entrada.estoque_maximo) AND (((analise_entrada.saldo_futuro)::double precision - (analise_entrada.consumo_medio_mensal * (0.5)::double precision)) > analise_entrada.ponto_pedido)) THEN (0)::double precision
                    WHEN ((analise_entrada.status_compra = (0)::numeric) AND ((('now'::text)::date - analise_entrada.data_ultima_riquisicao) > 20) AND ((analise_entrada.saldo_futuro)::double precision > analise_entrada.ponto_pedido) AND ((analise_entrada.saldo_futuro)::double precision <= analise_entrada.estoque_maximo) AND (((analise_entrada.saldo_futuro)::double precision - (analise_entrada.consumo_medio_mensal * (0.5)::double precision)) <= analise_entrada.ponto_pedido)) THEN (round(((analise_entrada.estoque_maximo - (analise_entrada.saldo_futuro)::double precision))::numeric, 2))::double precision
                    WHEN ((analise_entrada.status_compra = (0)::numeric) AND ((('now'::text)::date - analise_entrada.data_ultima_riquisicao) > 20) AND ((analise_entrada.saldo_futuro)::double precision <= analise_entrada.ponto_pedido)) THEN (round(((analise_entrada.estoque_maximo - (analise_entrada.saldo_futuro)::double precision))::numeric, 2))::double precision
                    ELSE (0)::double precision
                END AS lote_compras
           FROM ( SELECT b.id_grupo,
                    b.idfornecedor,
                    b.fornecedor,
                    b.idcomprador,
                    b.comprador,
                    b.idproduto,
                    b.descricao_produto,
                    b.iddepartamento,
                    b.descricao_departamento,
                    b.fator_conversao,
                    b.unidade_compra,
                    max(b.lote_minimo) AS lote_minimo,
                    max(b.data_ultima_riquisicao) AS data_ultima_riquisicao,
                    b.arvore_decisao,
                    b.nivel_servico,
                    b.peso_compras,
                    avg(b.compra_transito) AS compra_transito,
                    sum(b.consumo_transito) AS consumo_transito,
                    sum(b.saldo_futuro) AS saldo_futuro,
                    avg(b.amplitude_atual) AS amplitude_atual,
                    sum(b.estoque_maximo) AS estoque_maximo,
                    sum(b.ponto_pedido) AS ponto_pedido,
                    sum(b.consumo_medio_mensal) AS consumo_medio_mensal,
                    avg(b.tempo_ressuprimento) AS tempo_ressuprimento,
                    avg(b.desvio_padrao_ressuprimento) AS desvio_padrao_ressuprimento,
                    avg(b.estoque) AS estoque,
                    avg(b.status_compra) AS status_compra
                   FROM ( SELECT g.id_grupo,
                            p.filial,
                            fornecedor.id AS idfornecedor,
                            fornecedor.razao_social AS fornecedor,
                            comprador.id AS idcomprador,
                            comprador.nome_completo AS comprador,
                            p.idproduto,
                            p.descricao_produto,
                            dep.iddepartamento,
                            dep.descricao_departamento,
                            public.getcompra_transito_grupo((g.id_grupo)::numeric, p.idproduto) AS compra_transito,
                            public.getconsumo_transito_filial((p.filial)::numeric, p.idproduto) AS consumo_transito,
                            public.getsaldohorizontefuturo_projetado_grupo((p.filial)::numeric, p.idproduto, (g.id_grupo)::numeric) AS saldo_futuro,
                            public.amplitude_transito_atual_filial((p.filial)::numeric, p.idproduto) AS amplitude_atual,
                            COALESCE((p.estoque_maximo)::double precision, (0)::double precision) AS estoque_maximo,
                            COALESCE((p.ponto_pedido)::double precision, (0)::double precision) AS ponto_pedido,
                                CASE
                                    WHEN ((p.perfil_demanda)::text = 'OCASIONAL'::text) THEN ((p.consumo_medio_mensal)::double precision / (2)::double precision)
                                    ELSE (p.consumo_medio_mensal)::double precision
                                END AS consumo_medio_mensal,
                            p.tempo_ressuprimento,
                            p.desvio_padrao_ressuprimento,
                            public.get_estoque_grupo((g.id_grupo)::numeric, p.idproduto) AS estoque,
                            ( SELECT
CASE
 WHEN (count(*) > 0) THEN 0
 ELSE 1
END AS "case"
                                   FROM public.entrada_mercadorias
                                  WHERE ((entrada_mercadorias.data_entrada <= ('now'::text)::date) AND ((entrada_mercadorias.idproduto)::text = (p.idproduto)::text) AND (entrada_mercadorias.qtde > (0)::double precision))) AS status_compra,
                            p.fator_conversao,
                            p.unidade_compra,
                            COALESCE((p.lote_minimo)::double precision, (1)::double precision) AS lote_minimo,
                            p.data_ultima_riquisicao,
                            (public.get_arvore_decisao_grupo((g.id_grupo)::numeric, p.idproduto))::text AS arvore_decisao,
                            public.getnivelservico(public.get_arvore_decisao_grupo((g.id_grupo)::numeric, p.idproduto)) AS nivel_servico,
                            public.getpesocompras(public.get_arvore_decisao_grupo((g.id_grupo)::numeric, p.idproduto), ("substring"((public.get_arvore_decisao_grupo((g.id_grupo)::numeric, p.idproduto))::text, 3, 1))::numeric) AS peso_compras
                           FROM ((((public.produtos_filial p
                             LEFT JOIN public.comprador ON ((comprador.id = p.idcomprador)))
                             LEFT JOIN public.fornecedor ON ((fornecedor.id = p.idfornecedor)))
                             JOIN public.grupo_filial g ON ((g.filial = p.filial)))
                             JOIN public.departamentos dep ON ((dep.iddepartamento = p.idfamilia_produto)))
                          WHERE (((p.revenda)::text = 'S'::text) AND ((p.status)::text <> 'FL'::text) AND ((p.status_suprimento_sku)::text ~~ '%AGUARDANDO%'::text) AND (public.getcompra_transito_grupo((g.id_grupo)::numeric, p.idproduto) > (0)::numeric))) b
                  GROUP BY b.id_grupo, b.idfornecedor, b.fornecedor, b.idcomprador, b.comprador, b.idproduto, b.descricao_produto, b.descricao_departamento, b.fator_conversao, b.unidade_compra, b.arvore_decisao, b.nivel_servico, b.peso_compras, b.iddepartamento) analise_entrada
          WHERE (analise_entrada.compra_transito > (0)::numeric)) a
  ORDER BY (('now'::text)::date - data_ultima_riquisicao)
  WITH NO DATA;


--
-- Name: analise_mercadorias_transito_grupo_id_grupo_forn; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX analise_mercadorias_transito_grupo_id_grupo_forn ON public.analise_mercadorias_transito_grupo USING btree (id_grupo, idfornecedor);


--
-- Name: analise_mercadorias_transito_grupo_id_grupo_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX analise_mercadorias_transito_grupo_id_grupo_idx ON public.analise_mercadorias_transito_grupo USING btree (id_grupo, idproduto);


--
-- PostgreSQL database dump complete
--

\unrestrict e83M9TRa8QVxdybE2350O6oo7L0HlI4EbGzfa3DnOaghzobAe5H0cWkdScJqPVF

