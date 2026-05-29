--
-- PostgreSQL database dump
--

\restrict YJCeVWHpcJtO2787fPQVhVm3j7rb9EuWO4B781MNSGLyHoEanxFeY3Bp7Lxj20s

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
-- Name: vw_grupo_compras_produtos_mt; Type: MATERIALIZED VIEW; Schema: public; Owner: -
--

CREATE MATERIALIZED VIEW public.vw_grupo_compras_produtos_mt AS
 SELECT id_grupo,
    idproduto,
    descricao_produto,
    idcomprador,
    idfornecedor,
    idfamilia_produto,
    revenda,
    status,
    estoque,
    cobertura_estoque,
    estoque_seguranca,
    ponto_pedido,
    estoque_maximo,
    consumo_medio_mensal,
    desvio_padrao_consumo,
    tempo_medio_ressuprimento,
    tempo_ressuprimento,
    desvio_padrao_ressuprimento,
    coeficiente_variacao,
    compra_transito,
    lote_minimo,
    lote_compras_bruto,
    arvore_decisao,
    nivel_servico,
    peso_compras,
    unidade_compra,
    lote_embalagem,
    sob_encomenda,
    lote_compras,
    preco_compra,
    custo_unitario,
    valor_unitario,
    estoque_bloqueado,
    perfil_demanda,
    tempo_medio_apanhe,
    embalagem,
    idunidade_medida,
    ressuprimento_manual,
    ressuprimento_manual_dias,
    cod_produto,
    codigo_barras,
    fator_conversao,
    fator_atuacao,
    multiplo_compra,
    estoque_similar,
    projecao_rentabilidade,
    estoque_avaria,
    peso,
    altura,
    largura,
    comprimento,
    data_ultima_requisicao,
    estoque_reservado,
    unidade_master
   FROM public.vw_grupo_compras_produtos
  WITH NO DATA;


--
-- Name: vw_grupo_compras_produtos_mt_categoria_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX vw_grupo_compras_produtos_mt_categoria_idx ON public.vw_grupo_compras_produtos_mt USING btree (id_grupo, idfamilia_produto);


--
-- Name: vw_grupo_compras_produtos_mt_comprador_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX vw_grupo_compras_produtos_mt_comprador_idx ON public.vw_grupo_compras_produtos_mt USING btree (id_grupo, idcomprador);


--
-- Name: vw_grupo_compras_produtos_mt_fornecedor_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX vw_grupo_compras_produtos_mt_fornecedor_idx ON public.vw_grupo_compras_produtos_mt USING btree (id_grupo, idfornecedor);


--
-- Name: vw_grupo_compras_produtos_mt_id_grupo_pk; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX vw_grupo_compras_produtos_mt_id_grupo_pk ON public.vw_grupo_compras_produtos_mt USING btree (id_grupo, idproduto);


--
-- PostgreSQL database dump complete
--

\unrestrict YJCeVWHpcJtO2787fPQVhVm3j7rb9EuWO4B781MNSGLyHoEanxFeY3Bp7Lxj20s

