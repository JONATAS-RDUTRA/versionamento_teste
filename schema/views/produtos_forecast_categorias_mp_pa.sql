--
-- PostgreSQL database dump
--

\restrict GVnZ5arzbcW7FZHPDmLXXtqbKUez1woMlzRdRelaVmD57sgUtgGygnQcowOQDhG

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
-- Name: produtos_forecast_categorias_mp_pa; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.produtos_forecast_categorias_mp_pa AS
 SELECT id_grupo,
    id_categoria,
    descricao_categoria,
    idcomprador,
    cmm_peso,
    cmm_pa,
    cmm_pa_peso,
    desvio_padrao_consumo_peso,
    desvio_padrao_ressuprimento,
    estoque_peso,
    estoque_mp_peso,
    estoque_pa,
    estoque_pa_peso,
    estoque_bloqueado_peso,
    estoque_avaria_peso,
    estoque_reservado_peso,
    estoque_similar_peso,
    estoque_seguranca,
    ponto_pedido,
    estoque_maximo,
    saldo_futuro,
    tempo_ressuprimento,
    tempo_medio_ressuprimento,
    lote_minimo,
    nivel_servico,
    lote_compras_bruto,
    processamento,
    public.gerar_lote_embalagem(lote_compras_bruto, (lote_minimo)::numeric) AS lote_compras
   FROM ( SELECT v.id_grupo,
            v.id_categoria,
            v.descricao_categoria,
            v.idcomprador,
            v.cmm_peso,
            v.cmm_pa,
            v.cmm_pa_peso,
            v.desvio_padrao_consumo_peso,
            v.desvio_padrao_ressuprimento,
            v.estoque_peso,
            v.estoque_mp_peso,
            v.estoque_pa,
            v.estoque_pa_peso,
            v.estoque_bloqueado_peso,
            v.estoque_avaria_peso,
            v.estoque_reservado_peso,
            v.estoque_similar_peso,
            v.estoque_seguranca,
            v.ponto_pedido,
            v.estoque_maximo,
            (v.estoque_peso - ((v.cmm_peso / (30)::numeric) * (COALESCE(c.tempo_forecast))::numeric)) AS saldo_futuro,
            v.tempo_ressuprimento,
            v.tempo_medio_ressuprimento,
            v.lote_minimo,
            v.nivel_servico,
            round(((v.estoque_maximo + (v.cmm_peso * (v.tempo_ressuprimento + (v.desvio_padrao_ressuprimento)::numeric))) - v.estoque_peso), 2) AS lote_compras_bruto,
            v.processamento
           FROM (public.produtos_compras_categorias_mp_pa v
             JOIN public.categorias_mp_pa c ON ((c.id = v.id_categoria)))
          WHERE ((v.lote_compras = (0)::numeric) AND (v.cmm_peso > (0)::numeric) AND (v.estoque_transito_peso = ((0)::numeric)::double precision))) a
  WHERE ((saldo_futuro <= ponto_pedido) AND (lote_compras_bruto > (0)::numeric));


--
-- PostgreSQL database dump complete
--

\unrestrict GVnZ5arzbcW7FZHPDmLXXtqbKUez1woMlzRdRelaVmD57sgUtgGygnQcowOQDhG

