--
-- PostgreSQL database dump
--

\restrict gmmDaQkQHEGXfBGSnxO8bWuLIX1NlKdQy6gX0k4IYj4zdu4YtapPsCI9PXbl8wp

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

SET default_table_access_method = "heap";

--
-- Name: analise_percepcao_compras_grupos_tmp; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."analise_percepcao_compras_grupos_tmp" (
    "id_grupo" bigint,
    "filial" integer,
    "data_solicitacao" "date",
    "ordem_compra" double precision,
    "data_entrada" "date",
    "total_entradas" double precision,
    "sugestao" numeric(12,4),
    "idproduto" character varying(25),
    "descricao_produto" character varying(60),
    "descricao_familia_produto" character varying(60),
    "estoque_no_dia_entrada" numeric(12,4),
    "estoque_seguranca" numeric(12,4),
    "ponto_pedido" numeric(12,4),
    "estoque_maximo" numeric(12,4),
    "tempo_medio_ressuprimento" numeric(12,4),
    "consumo_medio" numeric(12,4),
    "estoque_solicitacao" numeric(12,4),
    "valor_unitario" numeric(12,4),
    "custo_unitario" numeric(12,4),
    "nome_comprador" character varying(100),
    "status_percepcao" "text",
    "qtde_sem_comportamento" character varying,
    "fator_conversao" numeric(12,6),
    "idcomprador" bigint,
    "idfornecedor" bigint,
    "nivel_servico" character varying(20)
);


--
-- PostgreSQL database dump complete
--

\unrestrict gmmDaQkQHEGXfBGSnxO8bWuLIX1NlKdQy6gX0k4IYj4zdu4YtapPsCI9PXbl8wp

