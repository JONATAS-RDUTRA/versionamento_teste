--
-- PostgreSQL database dump
--

\restrict 5REQbJewUpvDgYQJb6oKztkejSOHTRMOhTm6KCmxdIJEfaS8H7DXNEc6IMqC9ym

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
-- Name: analise_diagnostico_estoque_grupo_diario; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."analise_diagnostico_estoque_grupo_diario" (
    "idgrupo" bigint NOT NULL,
    "descricao_grupo" character varying(60),
    "idsegmento" integer,
    "descricao_segmento" "text",
    "idfornecedor" bigint,
    "descricao_fornecedor" "text",
    "idproduto" character varying(36) NOT NULL,
    "descricao_produto" "text",
    "data_cadastro" "date",
    "preco_custo" numeric,
    "preco_venda" numeric,
    "data_ult_saida" "date",
    "qtde_dias_sem_vender" integer,
    "estoque" numeric,
    "esseg" numeric,
    "pp" numeric,
    "emax" numeric,
    "consumo_medio_mensal" numeric,
    "consumo_medio_diario" numeric,
    "classificacao_financeira" "text",
    "classificacao_popularidade" "text",
    "classificacao_criticidade" "text",
    "classificacao_comprabilidade" "text",
    "nivel_servico" character varying,
    "tempo_medio_apanhe" numeric,
    "estoque_transito" numeric,
    "id_solicitacao" "text",
    "data_solicitacao" "date",
    "data_previsao" "date",
    "ativo_para_venda" "text",
    "fora_de_linha" "text",
    "tempo_ressuprimento_meses" numeric,
    "tempo_ressuprimento_dias" numeric,
    "cobertura_emax" numeric,
    "emax_em_preco_custo" numeric,
    "cobertura_estoque" numeric,
    "estoque_em_preco_custo" numeric,
    "estoque_em_preco_venda" numeric,
    "cmm_em_preco_venda" numeric,
    "cmm_em_preco_custo" numeric,
    "estoque_em_excesso" numeric,
    "estoque_em_excesso_em_preco_custo" numeric,
    "data_analise_demanda_real" "date",
    "sugestao_compra" double precision,
    "sugestao_compra_preco_custo" double precision,
    "qtde_dias_cobertura_parametrizada" integer,
    "markup" numeric,
    "frequencia_saida" "text",
    "faturamento" "text",
    "status_produto" "text",
    "grupo_intervalo_cobertura" "text",
    "histograma" "text",
    "idade" "text",
    "data_cobertura_instatanea" "date",
    "status_demanda" "text",
    "demanda_real" numeric,
    "dif_data" integer,
    "faturamento_real" numeric,
    "diferenca" numeric,
    "cobertura_parametrizavel" numeric,
    "estoque_parametrizavel" numeric,
    "estoque_parametrizavel_preco_custo" numeric,
    "total_estoque_para_aumentar" numeric,
    "total_estoque_para_reduzir" numeric,
    "total_estoque_para_aumentar_preco_custo" numeric,
    "total_estoque_para_reduzir_preco_custo" numeric,
    "emax_parametrizavel" numeric,
    "estoque_em_excesso_parametrizavel" numeric,
    "estoque_em_excesso_parametrizavel_em_preco_custo" numeric,
    "consumo_transito" numeric,
    "consumo_transito_preco_custo" numeric,
    "estoque_residual" numeric,
    "estoque_futuro_preco_custo" numeric,
    "data" "date" NOT NULL,
    "idcomprador" bigint,
    "descricao_comprador" character varying(100),
    "estoque_minimo" numeric,
    "data_primeira_entrada" "date",
    "data_ultima_entrada" "date",
    "classificacao_rentabilidade" character(1),
    "idsecao" character varying(25),
    "descricao_secao" character varying(45),
    "produto_combinado" boolean DEFAULT false NOT NULL,
    "cod_produto" character varying(30) DEFAULT ''::character varying
);


--
-- Name: analise_diagnostico_estoque_grupo_diario analise_diagnostico_estoque_grupo_diario_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."analise_diagnostico_estoque_grupo_diario"
    ADD CONSTRAINT "analise_diagnostico_estoque_grupo_diario_pk" PRIMARY KEY ("idgrupo", "idproduto", "data");


--
-- Name: analise_diagnostico_estoque_grupo_diario_histograma_data_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "analise_diagnostico_estoque_grupo_diario_histograma_data_idx" ON "public"."analise_diagnostico_estoque_grupo_diario" USING "btree" ("histograma", "data");


--
-- Name: analise_diagnostico_estoque_grupo_diario_idade_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "analise_diagnostico_estoque_grupo_diario_idade_idx" ON "public"."analise_diagnostico_estoque_grupo_diario" USING "btree" ("btrim"("idade"));


--
-- Name: analise_diagnostico_estoque_grupo_diario_idgrupo_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "analise_diagnostico_estoque_grupo_diario_idgrupo_idx" ON "public"."analise_diagnostico_estoque_grupo_diario" USING "btree" ("idgrupo", "idproduto");


--
-- PostgreSQL database dump complete
--

\unrestrict 5REQbJewUpvDgYQJb6oKztkejSOHTRMOhTm6KCmxdIJEfaS8H7DXNEc6IMqC9ym

