--
-- PostgreSQL database dump
--

\restrict WAdCHyGXkklQnVUDde9ARV0oGiXfjFYL7hX25225KwDVcRGSpDb4clrWTt07fSU

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
-- Name: vw_lista_compras_dinamica_grupo_mt; Type: MATERIALIZED VIEW; Schema: public; Owner: -
--

CREATE MATERIALIZED VIEW public.vw_lista_compras_dinamica_grupo_mt AS
 SELECT id_grupo,
    idfornecedor,
    idcomprador,
    iddepartamento,
    idfamilia_produto,
    tipo,
    nivel_servico,
    status,
    idproduto,
    descricao_produto,
    unidade_compra,
    estoque,
    sugestao,
    status_suprimento_sku,
    peso_compras,
    tempo_gatilho
   FROM public.vw_lista_compras_dinamica_grupo
  WITH NO DATA;


--
-- Name: vw_lista_compras_dinamica_grupo_mt_id_grupo_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX vw_lista_compras_dinamica_grupo_mt_id_grupo_idx ON public.vw_lista_compras_dinamica_grupo_mt USING btree (id_grupo, idfornecedor, idproduto, tipo);


--
-- PostgreSQL database dump complete
--

\unrestrict WAdCHyGXkklQnVUDde9ARV0oGiXfjFYL7hX25225KwDVcRGSpDb4clrWTt07fSU

