--
-- PostgreSQL database dump
--

\restrict ZYW2fahqPMf6nYHnsT30iOaiPivbGbU9i0PfNSZeZbdhVNbvltO6ZxWbJ2dNgyz

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
-- Name: produtos_compras_categorias; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."produtos_compras_categorias" (
    "id_grupo" bigint NOT NULL,
    "iddepartamento" character varying(25) NOT NULL,
    "idsecao" character varying(25) NOT NULL,
    "idcategoria" character varying(25) NOT NULL,
    "descricao_categoria" character varying(60),
    "idcomprador" bigint,
    "estoque" numeric,
    "estoque_bloqueado" numeric DEFAULT 0,
    "estoque_avaria" numeric DEFAULT 0,
    "estoque_reservado" numeric DEFAULT 0,
    "cobertura_estoque" numeric DEFAULT 0,
    "estoque_seguranca" numeric DEFAULT 0,
    "ponto_pedido" numeric DEFAULT 0,
    "estoque_maximo" numeric DEFAULT 0,
    "consumo_medio_mensal" numeric DEFAULT 0,
    "desvio_padrao_consumo" numeric DEFAULT 0,
    "tempo_medio_ressuprimento" numeric DEFAULT 35,
    "tempo_ressuprimento" numeric DEFAULT 1.17,
    "desvio_padrao_ressuprimento" numeric DEFAULT 0,
    "coeficiente_variacao" "text",
    "compra_transito" numeric DEFAULT 0,
    "arvore_decisao" "text",
    "nivel_servico" character varying,
    "peso_compras" numeric DEFAULT 0,
    "lote_minimo" numeric DEFAULT 1,
    "lote_compras_bruto" numeric DEFAULT 0,
    "lote_compras" numeric DEFAULT 0,
    "perfil_demanda" "text",
    "tempo_medio_apanhe" numeric DEFAULT 0,
    "unidade_compra" character varying(5) NOT NULL,
    "processamento" timestamp without time zone,
    "cobertura_manual_categoria" integer DEFAULT 0,
    "custo_unitario" numeric(12,4),
    "preco_medio_compra" numeric(12,4),
    "idunidade_medida" character varying(3) DEFAULT ''::character varying NOT NULL,
    "ultimo_preco_compra" numeric(12,4) DEFAULT 0
);


--
-- Name: produtos_compras_categorias produtos_compras_cat_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."produtos_compras_categorias"
    ADD CONSTRAINT "produtos_compras_cat_pk" PRIMARY KEY ("id_grupo", "idcategoria");


--
-- PostgreSQL database dump complete
--

\unrestrict ZYW2fahqPMf6nYHnsT30iOaiPivbGbU9i0PfNSZeZbdhVNbvltO6ZxWbJ2dNgyz

