--
-- PostgreSQL database dump
--

\restrict b3Kfsn2BhUeffAJeqB8huTNwf9RnH3YEDo3mVivgeVfDYSrkeIPZgixFWdQwkh1

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
-- Name: produtos_compras_categorias_mp_pa; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."produtos_compras_categorias_mp_pa" (
    "id_grupo" bigint NOT NULL,
    "id_categoria" integer NOT NULL,
    "descricao_categoria" character varying(100) NOT NULL,
    "idcomprador" bigint NOT NULL,
    "estoque_peso" numeric NOT NULL,
    "estoque_mp_peso" numeric NOT NULL,
    "estoque_pa" numeric NOT NULL,
    "estoque_pa_peso" numeric NOT NULL,
    "cobertura_estoque_peso" numeric NOT NULL,
    "estoque_transito_peso" double precision NOT NULL,
    "estoque_bloqueado_peso" numeric NOT NULL,
    "estoque_avaria_peso" numeric NOT NULL,
    "estoque_reservado_peso" numeric NOT NULL,
    "estoque_similar_peso" numeric NOT NULL,
    "estoque_seguranca" numeric NOT NULL,
    "ponto_pedido" numeric NOT NULL,
    "estoque_maximo" numeric NOT NULL,
    "lote_minimo" integer NOT NULL,
    "unidade_compra" "text" NOT NULL,
    "idunidade_medida" "text" NOT NULL,
    "custo_medio_unitario" numeric NOT NULL,
    "preco_medio_compra" numeric NOT NULL,
    "cmm_peso" numeric NOT NULL,
    "cmm_pa" numeric NOT NULL,
    "cmm_pa_peso" numeric NOT NULL,
    "desvio_padrao_consumo_peso" numeric NOT NULL,
    "fator_conversao" numeric NOT NULL,
    "tempo_medio_apanhe" numeric NOT NULL,
    "fes" numeric NOT NULL,
    "peso_compras" numeric NOT NULL,
    "cobertura_manual_categoria" integer NOT NULL,
    "tempo_ressuprimento" numeric NOT NULL,
    "tempo_medio_ressuprimento" integer NOT NULL,
    "prazo_medio_recebimento" numeric(4,1) NOT NULL,
    "desvio_padrao_ressuprimento" integer NOT NULL,
    "coeficiente_variacao" numeric NOT NULL,
    "perfil_demanda" "text" NOT NULL,
    "lote_compras_bruto" numeric NOT NULL,
    "lote_compras" numeric NOT NULL,
    "nivel_servico" character varying NOT NULL,
    "classificacao_financeira" "text" NOT NULL,
    "classificacao_criticidade" "text" NOT NULL,
    "classificacao_comprabilidade" integer NOT NULL,
    "classificacao_popularidade" "text" NOT NULL,
    "arvore_decisao" "text" NOT NULL,
    "processamento" "text" NOT NULL,
    "flag" character(1),
    "ultimo_preco_compra" numeric(12,4) DEFAULT 0 NOT NULL
);


--
-- PostgreSQL database dump complete
--

\unrestrict b3Kfsn2BhUeffAJeqB8huTNwf9RnH3YEDo3mVivgeVfDYSrkeIPZgixFWdQwkh1

