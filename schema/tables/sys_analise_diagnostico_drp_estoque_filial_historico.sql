--
-- PostgreSQL database dump
--

\restrict MUbMKSwatAjJ7H5b3iiuHbYHW2Bsy68z6kb9xOUjeprMYi8KltBy5wOLjseTXya

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
-- Name: sys_analise_diagnostico_drp_estoque_filial_historico; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."sys_analise_diagnostico_drp_estoque_filial_historico" (
    "data" "date" NOT NULL,
    "idgrupo" bigint NOT NULL,
    "filial" bigint NOT NULL,
    "descricao_filial" "text",
    "idcomprador" bigint NOT NULL,
    "descricao_comprador" character varying(100) NOT NULL,
    "idsegmento" integer NOT NULL,
    "descricao_segmento" "text" NOT NULL,
    "idfornecedor" bigint NOT NULL,
    "descricao_fornecedor" "text" NOT NULL,
    "status_balanceamento" "text" NOT NULL,
    "idproduto" character varying(25) NOT NULL,
    "descricao_produto" "text" NOT NULL,
    "pertence_ao_mix" "text" NOT NULL,
    "media_ultimo_trimestre" double precision NOT NULL,
    "consumo_medio_mensal" numeric NOT NULL,
    "estoque" numeric NOT NULL,
    "demanda_real" numeric NOT NULL,
    "esseg" numeric NOT NULL,
    "esseg_compras" numeric NOT NULL,
    "pp" numeric NOT NULL,
    "pp_compras" numeric NOT NULL,
    "emax" numeric NOT NULL,
    "emax_compras" numeric NOT NULL,
    "estoque_minimo" numeric NOT NULL,
    "fora_de_linha" "text" NOT NULL,
    "ativo_para_venda" "text" NOT NULL,
    "tempo_ressuprimento_drp" numeric NOT NULL,
    "status_produto" "text" NOT NULL,
    "cobertura_estoque" numeric NOT NULL,
    "cobertura_estoque_estetico" numeric NOT NULL,
    "cobertura_emax" numeric NOT NULL,
    "cobertura_emax_compras" numeric NOT NULL,
    "preco_custo" numeric NOT NULL,
    "preco_venda" numeric NOT NULL,
    "cmm_em_preco_custo" numeric NOT NULL,
    "estoque_em_preco_custo" numeric NOT NULL,
    "demanda_possivel_em_preco_custo" numeric NOT NULL,
    "estoque_estetico_em_preco_custo" numeric NOT NULL,
    "emax_em_preco_custo" numeric NOT NULL,
    "emax_em_preco_custo_compras" numeric NOT NULL,
    "cmm_em_preco_venda" numeric NOT NULL,
    "estoque_em_preco_venda" numeric NOT NULL,
    "demanda_possivel_em_preco_venda" numeric NOT NULL,
    "diferenca_projecao_vendas_demanda_possivel_em_preco_venda" numeric NOT NULL,
    "idade" "text" NOT NULL,
    "data_primeira_entrada" "date",
    "data_ultima_entrada" "date",
    "classificacao_primeira_entrada" "text",
    "classificacao_ultima_entrada" "text",
    "histograma" "text" NOT NULL,
    "data_ult_saida" "date",
    "produto_resgatado" "text" NOT NULL,
    "frequencia_saida" "text" NOT NULL,
    "faturamento" "text" NOT NULL,
    "classificacao_rentabilidade" character(1) NOT NULL,
    "tempo_medio_apanhe" numeric NOT NULL,
    "total_transferencia_filial" numeric NOT NULL,
    "total_transferencia_filial_em_preco_custo" numeric NOT NULL,
    "tipo_produto" "text" NOT NULL,
    "consumo_transito" numeric NOT NULL,
    "saldo_residual" numeric NOT NULL,
    "sugestao_movimentacao" numeric NOT NULL,
    "sugestao_movimentacao_em_preco_custo" numeric NOT NULL,
    "saldo_futuro" numeric NOT NULL,
    "saldo_futuro_em_preco_custo" numeric NOT NULL
);


--
-- Name: sys_analise_diagnostico_drp_estoque_filial_historico sys_analise_diagnostico_drp_estoque_filial_historico_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."sys_analise_diagnostico_drp_estoque_filial_historico"
    ADD CONSTRAINT "sys_analise_diagnostico_drp_estoque_filial_historico_pkey" PRIMARY KEY ("data", "filial", "idproduto");


--
-- PostgreSQL database dump complete
--

\unrestrict MUbMKSwatAjJ7H5b3iiuHbYHW2Bsy68z6kb9xOUjeprMYi8KltBy5wOLjseTXya

