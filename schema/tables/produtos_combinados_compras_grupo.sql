--
-- PostgreSQL database dump
--

\restrict rwG8yUgwJRIhEhwn55QmVfEFEbvrZKLO5OszYhFdhOTZQn0kNM5p9m2sRLvk5uh

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
-- Name: produtos_combinados_compras_grupo; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."produtos_combinados_compras_grupo" (
    "id_grupo" bigint NOT NULL,
    "id_produto_combinado" character varying(36) NOT NULL,
    "descricao_produto" character varying(150),
    "produtos" character varying[],
    "compradores" bigint[],
    "fornecedores" bigint[],
    "familias_produtos" bigint[],
    "secoes" character varying[],
    "revenda" "text",
    "status" "text",
    "estoque" numeric,
    "cobertura_estoque" numeric,
    "estoque_seguranca" numeric,
    "ponto_pedido" numeric,
    "estoque_maximo" numeric,
    "consumo_medio_mensal" numeric,
    "desvio_padrao_consumo" numeric,
    "tempo_medio_ressuprimento" numeric,
    "tempo_ressuprimento" numeric,
    "desvio_padrao_ressuprimento" numeric,
    "coeficiente_variacao" "text",
    "compra_transito" numeric,
    "lote_minimo" numeric,
    "lote_compras_bruto" numeric,
    "arvore_decisao" "text",
    "nivel_servico" character varying,
    "peso_compras" numeric,
    "unidade_compra" "text",
    "lote_embalagem" numeric,
    "sob_encomenda" integer,
    "lote_compras" numeric,
    "preco_compra" numeric,
    "custo_unitario" numeric,
    "valor_unitario" numeric,
    "estoque_bloqueado" numeric,
    "perfil_demanda" "text",
    "tempo_medio_apanhe" numeric,
    "embalagem" "text",
    "idunidade_medida" "text",
    "ressuprimento_manual" character varying(1),
    "ressuprimento_manual_dias" numeric,
    "cod_produto" "text",
    "codigo_barras" character varying(25),
    "fator_conversao" integer,
    "fator_atuacao" numeric,
    "projecao_rentabilidade" numeric,
    "estoque_avaria" numeric,
    "peso" numeric,
    "altura" numeric,
    "largura" numeric,
    "comprimento" numeric,
    "data_ultima_requisicao" "date",
    "estoque_reservado" numeric,
    "multiplo_compra" numeric(12,6),
    "unidade_master" "text",
    "tipo_fator_conversao" "text",
    "compra_transito_entregue" double precision,
    "detalhamento_tecnico" "text",
    "estoque_minimo" numeric,
    "classificacao_rentabilidade" "text",
    "estoque_seguranca_estetico" numeric,
    "ponto_pedido_estetico" numeric,
    "estoque_maximo_estetico" numeric,
    "flag" character varying(1),
    "estoque_pendente" numeric(12,4) DEFAULT 0 NOT NULL,
    "litragem" numeric(12,4),
    "valor_liquido" numeric(12,4) DEFAULT 0 NOT NULL,
    "numero_original" character varying(50),
    "baixa_movimentacao" boolean DEFAULT false NOT NULL
);


--
-- Name: COLUMN "produtos_combinados_compras_grupo"."estoque_pendente"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."produtos_combinados_compras_grupo"."estoque_pendente" IS 'Saldo de venda futura';


--
-- Name: produtos_combinados_compras_grupo produtos_combinados_compras_grupo_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."produtos_combinados_compras_grupo"
    ADD CONSTRAINT "produtos_combinados_compras_grupo_pkey" PRIMARY KEY ("id_grupo", "id_produto_combinado");


--
-- PostgreSQL database dump complete
--

\unrestrict rwG8yUgwJRIhEhwn55QmVfEFEbvrZKLO5OszYhFdhOTZQn0kNM5p9m2sRLvk5uh

