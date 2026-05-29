--
-- PostgreSQL database dump
--

\restrict kcvC81caZyWlejYoDv4HuiCUmsQmUgFaLpd1iCjahNXgoxmmK1U7Z8Bv59NIEho

-- Dumped from database version 16.13 (Ubuntu 16.13-1.pgdg24.04+1)
-- Dumped by pg_dump version 16.13 (Ubuntu 16.13-1.pgdg24.04+1)

-- Started on 2026-05-29 11:24:28 -04

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
-- TOC entry 238 (class 1259 OID 54082)
-- Name: produtos_filial; Type: TABLE; Schema: public; Owner: systock
--

CREATE TABLE public.produtos_filial (
    filial integer NOT NULL,
    idproduto character varying(25) DEFAULT ''::character varying NOT NULL,
    cod_produto character varying(30) DEFAULT ''::character varying,
    descricao_produto character varying(60),
    idunidade_medida character varying(3) DEFAULT ''::character varying NOT NULL,
    idfamilia_produto integer,
    idarea_responsavel integer,
    aplicacao_produto character varying(255),
    posicao_almoxarifado character varying(20),
    iddeposito integer DEFAULT 1,
    valor_unitario numeric(12,4),
    classificacao_financeira character varying(1),
    classificacao_criticidade character varying(1),
    classificacao_comprabilidade integer,
    classificacao_popularidade character varying(1),
    peso_compras integer,
    manter_estoque character varying(1),
    espaco_amostral character varying(20),
    arvore_decisao character varying(20),
    nivel_servico character varying(20),
    consumo_medio_mensal numeric(12,4),
    desvio_padrao_ressuprimento numeric(12,4),
    desvio_padrao_consumo numeric(12,4),
    estoque numeric(12,4) DEFAULT 0,
    estoque_seguranca numeric(12,4) DEFAULT 0,
    ponto_pedido numeric(12,4),
    estoque_maximo numeric(12,4) DEFAULT 0,
    desvio_padrao_poisson numeric(17,4),
    taxa_media_poisson numeric(17,4),
    lote_medio_poisson numeric(17,4),
    estoque_seguranca_poisson numeric(17,4) DEFAULT 0,
    ponto_pedido_poisson numeric(17,4),
    estoque_maximo_poisson numeric(17,4) DEFAULT 0,
    status_suprimento_sku character varying(20),
    lote_minimo numeric(12,4),
    lote_minimo_compras numeric(12,4),
    lote_compras numeric(12,4),
    cobertura_estoque numeric(12,4),
    giro_estoque character varying(20),
    tempo_ressuprimento numeric(12,4),
    tempo_medio_ressuprimento numeric(12,4),
    perfil_demanda character varying(20),
    tempo_medio_apanhe numeric(12,4),
    fes numeric(12,4),
    coeficiente_variacao character varying(20),
    ultima_riquisicao_entrada character varying(20),
    data_ultima_riquisicao date,
    ultimo_pedido_compra character varying(20),
    data_ultima_compra date,
    status_ultima_compra character varying(40),
    fabricantes_aceitos text,
    detalhamento_tecnico text,
    codigo_barras character varying(25),
    favorito character varying(1) DEFAULT 'N'::character varying NOT NULL,
    custo_unitario numeric(12,4) DEFAULT 0 NOT NULL,
    ressuprimento_manual character varying(1) DEFAULT 'N'::character varying NOT NULL,
    ressuprimento_manual_dias numeric(10,2),
    idcomprador bigint,
    idfornecedor bigint,
    estoque_bloqueado numeric(12,4) DEFAULT 0,
    revenda character varying(1),
    status character varying(2),
    fator_conversao numeric(12,6) DEFAULT 1 NOT NULL,
    unidade_compra character varying(20),
    processamento timestamp without time zone DEFAULT now() NOT NULL,
    preco_compra numeric(12,4) DEFAULT 0 NOT NULL,
    nivel_estoque numeric(12,4) DEFAULT 0 NOT NULL,
    tempo_gatilho integer DEFAULT 0 NOT NULL,
    estoque_drp numeric(12,4) DEFAULT 0 NOT NULL,
    status_drp character varying,
    saldo_necessidade_drp numeric(12,4) DEFAULT 0 NOT NULL,
    embalagem character varying(20),
    importado character varying(1) DEFAULT 'N'::character varying NOT NULL,
    data_cadastro date,
    marca character varying(60),
    embalagem_master numeric(12,4) DEFAULT 1,
    tipo_ressuprimento character varying(1) DEFAULT 'F'::character varying NOT NULL,
    estoque_temp numeric(12,4) DEFAULT 0 NOT NULL,
    est_max_transf numeric(12,4) DEFAULT 0 NOT NULL,
    estoque_similar numeric(12,4) DEFAULT 0 NOT NULL,
    fator_atuacao numeric(12,4) DEFAULT 1 NOT NULL,
    tipo_fator_atuacao character varying(1) DEFAULT 'F'::character varying NOT NULL,
    est_min_transf numeric(12,4) DEFAULT 1 NOT NULL,
    unidade_master character varying(20),
    multiplo_compra numeric(12,6) DEFAULT 1 NOT NULL,
    preco_medio_venda numeric(12,4),
    heranca character varying(25),
    tipo_heranca integer,
    cadastro_heranca date,
    estoque_reservado numeric(12,4) DEFAULT 0,
    total_estoque_custo numeric(12,4),
    total_estoque_venda numeric(12,4),
    fator_markup numeric(12,4),
    projecao_venda numeric(12,4),
    projecao_rentabilidade numeric(12,4),
    classificacao_rentabilidade character varying(2),
    grupo_compra integer,
    end_bairro integer,
    end_rua integer,
    end_predio integer,
    end_andar integer,
    end_apto integer,
    limite_inferior numeric(12,4) DEFAULT 0,
    limite_superior numeric(12,4) DEFAULT 0,
    estoque_avaria numeric(12,4) DEFAULT 0,
    peso numeric(12,4) DEFAULT 0,
    altura numeric(12,4) DEFAULT 0,
    largura numeric(12,4) DEFAULT 0,
    comprimento numeric(12,4) DEFAULT 0,
    flag_sob_encomenda character varying(1) DEFAULT 'N'::character varying,
    cobertura_manual_produto integer DEFAULT 0,
    estoque_transito_drp numeric(12,4) DEFAULT 0,
    tipo_produto character varying(2) DEFAULT 'PA'::character varying,
    tipo_fator_conversao character(1) DEFAULT 'D'::bpchar NOT NULL,
    processar_analise character varying(1) DEFAULT 'S'::character varying,
    idcategoria character varying(25),
    iddepartamento character varying(25),
    estoque_minimo numeric(12,4) DEFAULT 0 NOT NULL,
    idsecao character varying(25),
    litragem numeric(12,4),
    idlinhaprod bigint,
    status_tempo_esseg integer DEFAULT 0,
    endereco_estoque character varying(25),
    estoque_pendente numeric(12,4),
    estoque_distribuicao numeric,
    moeda character varying(2) DEFAULT 'R'::character varying NOT NULL,
    status_original character varying(2),
    valor_liquido numeric(12,4) DEFAULT 0 NOT NULL,
    estoque_origem numeric(12,4) DEFAULT 0 NOT NULL,
    idmarca character varying(25),
    ipi_entrada_percentual numeric(12,4) DEFAULT 0 NOT NULL,
    sub_tributaria_entrada_percentual numeric(12,4) DEFAULT 0 NOT NULL,
    sub_tributaria_entrada_acumulada_percentual numeric(12,4) DEFAULT 0 NOT NULL,
    numero_original character varying(50),
    status_produto character varying(60),
    cod_comercial character varying(30),
    multiplo_distribuicao numeric(12,4) DEFAULT 1,
    estoque_recebimento numeric(12,4) DEFAULT 0,
    data_ult_entrada_transf date,
    idcomprador_systock bigint,
    controlado_por_lote character varying(1) DEFAULT 'N'::character varying NOT NULL,
    valor_ultima_entrada_sem_st numeric(12,6) DEFAULT 0 NOT NULL,
    valor_ultima_compra numeric(12,6) DEFAULT 0 NOT NULL,
    lastro_palete numeric(12,6) DEFAULT 0 NOT NULL,
    altura_palete numeric(12,6) DEFAULT 0 NOT NULL,
    ncm character varying(25) DEFAULT NULL::character varying,
    data_ultima_saida date,
    cmm_filial_retira numeric(12,4),
    desvio_padrao_cons_ret numeric(12,4),
    CONSTRAINT revenda_s_ou_n CHECK (((revenda)::text = ANY (ARRAY[('S'::character varying)::text, ('N'::character varying)::text]))),
    CONSTRAINT status_a_ou_fl CHECK (((status)::text = ANY (ARRAY[('A'::character varying)::text, ('FL'::character varying)::text]))),
    CONSTRAINT tempo_medio_ressuprimento_maior_que_zero CHECK ((tempo_medio_ressuprimento > (0)::numeric)),
    CONSTRAINT tempo_ressuprimento_maior_que_zero CHECK ((tempo_ressuprimento > (0)::numeric))
)
WITH (autovacuum_vacuum_scale_factor='0.58039');


ALTER TABLE public.produtos_filial OWNER TO systock;

--
-- TOC entry 4701 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN produtos_filial.filial; Type: COMMENT; Schema: public; Owner: systock
--

COMMENT ON COLUMN public.produtos_filial.filial IS 'Filial do produto';


--
-- TOC entry 4702 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN produtos_filial.idproduto; Type: COMMENT; Schema: public; Owner: systock
--

COMMENT ON COLUMN public.produtos_filial.idproduto IS 'Produto';


--
-- TOC entry 4703 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN produtos_filial.cod_produto; Type: COMMENT; Schema: public; Owner: systock
--

COMMENT ON COLUMN public.produtos_filial.cod_produto IS 'Código  fornecedor  do produto';


--
-- TOC entry 4704 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN produtos_filial.descricao_produto; Type: COMMENT; Schema: public; Owner: systock
--

COMMENT ON COLUMN public.produtos_filial.descricao_produto IS 'Nome do produto';


--
-- TOC entry 4705 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN produtos_filial.idfamilia_produto; Type: COMMENT; Schema: public; Owner: systock
--

COMMENT ON COLUMN public.produtos_filial.idfamilia_produto IS 'Departamemto do produto';


--
-- TOC entry 4706 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN produtos_filial.valor_unitario; Type: COMMENT; Schema: public; Owner: systock
--

COMMENT ON COLUMN public.produtos_filial.valor_unitario IS 'Valor de venda do produto';


--
-- TOC entry 4707 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN produtos_filial.consumo_medio_mensal; Type: COMMENT; Schema: public; Owner: systock
--

COMMENT ON COLUMN public.produtos_filial.consumo_medio_mensal IS 'CMV';


--
-- TOC entry 4708 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN produtos_filial.estoque_seguranca; Type: COMMENT; Schema: public; Owner: systock
--

COMMENT ON COLUMN public.produtos_filial.estoque_seguranca IS 'ESEG';


--
-- TOC entry 4709 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN produtos_filial.ponto_pedido; Type: COMMENT; Schema: public; Owner: systock
--

COMMENT ON COLUMN public.produtos_filial.ponto_pedido IS 'PP';


--
-- TOC entry 4710 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN produtos_filial.estoque_maximo; Type: COMMENT; Schema: public; Owner: systock
--

COMMENT ON COLUMN public.produtos_filial.estoque_maximo IS 'EMAX';


--
-- TOC entry 4711 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN produtos_filial.data_ultima_riquisicao; Type: COMMENT; Schema: public; Owner: systock
--

COMMENT ON COLUMN public.produtos_filial.data_ultima_riquisicao IS 'Data do último pedido de compra';


--
-- TOC entry 4712 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN produtos_filial.ultimo_pedido_compra; Type: COMMENT; Schema: public; Owner: systock
--

COMMENT ON COLUMN public.produtos_filial.ultimo_pedido_compra IS 'Número do último pedido de compra';


--
-- TOC entry 4713 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN produtos_filial.data_ultima_compra; Type: COMMENT; Schema: public; Owner: systock
--

COMMENT ON COLUMN public.produtos_filial.data_ultima_compra IS 'Data da última compra';


--
-- TOC entry 4714 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN produtos_filial.custo_unitario; Type: COMMENT; Schema: public; Owner: systock
--

COMMENT ON COLUMN public.produtos_filial.custo_unitario IS 'Custo do produto';


--
-- TOC entry 4715 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN produtos_filial.ressuprimento_manual; Type: COMMENT; Schema: public; Owner: systock
--

COMMENT ON COLUMN public.produtos_filial.ressuprimento_manual IS 'Sim ou Não na tela de detalhamento';


--
-- TOC entry 4716 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN produtos_filial.ressuprimento_manual_dias; Type: COMMENT; Schema: public; Owner: systock
--

COMMENT ON COLUMN public.produtos_filial.ressuprimento_manual_dias IS 'Pode defnir na tela de detalhamento';


--
-- TOC entry 4717 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN produtos_filial.idcomprador; Type: COMMENT; Schema: public; Owner: systock
--

COMMENT ON COLUMN public.produtos_filial.idcomprador IS 'Código do Comprador';


--
-- TOC entry 4718 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN produtos_filial.idfornecedor; Type: COMMENT; Schema: public; Owner: systock
--

COMMENT ON COLUMN public.produtos_filial.idfornecedor IS 'Código do Fornecedor';


--
-- TOC entry 4719 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN produtos_filial.revenda; Type: COMMENT; Schema: public; Owner: systock
--

COMMENT ON COLUMN public.produtos_filial.revenda IS 'Verifica se está ativo para venda';


--
-- TOC entry 4720 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN produtos_filial.status; Type: COMMENT; Schema: public; Owner: systock
--

COMMENT ON COLUMN public.produtos_filial.status IS 'Verifica se está fora de linha ou ativo';


--
-- TOC entry 4721 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN produtos_filial.preco_compra; Type: COMMENT; Schema: public; Owner: systock
--

COMMENT ON COLUMN public.produtos_filial.preco_compra IS 'Preço de Compra do produto';


--
-- TOC entry 4722 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN produtos_filial.importado; Type: COMMENT; Schema: public; Owner: systock
--

COMMENT ON COLUMN public.produtos_filial.importado IS 'Verifica se o produto é Importado ou não';


--
-- TOC entry 4723 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN produtos_filial.marca; Type: COMMENT; Schema: public; Owner: systock
--

COMMENT ON COLUMN public.produtos_filial.marca IS 'Marca do produto';


--
-- TOC entry 4724 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN produtos_filial.grupo_compra; Type: COMMENT; Schema: public; Owner: systock
--

COMMENT ON COLUMN public.produtos_filial.grupo_compra IS 'Grupo de compra do produto';


--
-- TOC entry 4725 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN produtos_filial.flag_sob_encomenda; Type: COMMENT; Schema: public; Owner: systock
--

COMMENT ON COLUMN public.produtos_filial.flag_sob_encomenda IS 'Verifica se o produto é sob encomenda';


--
-- TOC entry 4726 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN produtos_filial.idcategoria; Type: COMMENT; Schema: public; Owner: systock
--

COMMENT ON COLUMN public.produtos_filial.idcategoria IS 'Código Categoria do Porduto';


--
-- TOC entry 4727 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN produtos_filial.iddepartamento; Type: COMMENT; Schema: public; Owner: systock
--

COMMENT ON COLUMN public.produtos_filial.iddepartamento IS 'Departamento do produto';


--
-- TOC entry 4728 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN produtos_filial.estoque_minimo; Type: COMMENT; Schema: public; Owner: systock
--

COMMENT ON COLUMN public.produtos_filial.estoque_minimo IS 'Estoque Estético';


--
-- TOC entry 4729 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN produtos_filial.idsecao; Type: COMMENT; Schema: public; Owner: systock
--

COMMENT ON COLUMN public.produtos_filial.idsecao IS 'Código de Seção do produto';


--
-- TOC entry 4730 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN produtos_filial.litragem; Type: COMMENT; Schema: public; Owner: systock
--

COMMENT ON COLUMN public.produtos_filial.litragem IS 'LITRAGEM DO ITEM';


--
-- TOC entry 4731 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN produtos_filial.idlinhaprod; Type: COMMENT; Schema: public; Owner: systock
--

COMMENT ON COLUMN public.produtos_filial.idlinhaprod IS 'ID LINHA DO PRODUTO';


--
-- TOC entry 4732 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN produtos_filial.status_tempo_esseg; Type: COMMENT; Schema: public; Owner: systock
--

COMMENT ON COLUMN public.produtos_filial.status_tempo_esseg IS '1 - CURVAS 2 - DEPARTAMENTO/SEGMENTO 3 - FORNECEDOR 4 - PRODUTO';


--
-- TOC entry 4733 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN produtos_filial.estoque_pendente; Type: COMMENT; Schema: public; Owner: systock
--

COMMENT ON COLUMN public.produtos_filial.estoque_pendente IS 'Saldo de venda futura';


--
-- TOC entry 4734 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN produtos_filial.moeda; Type: COMMENT; Schema: public; Owner: systock
--

COMMENT ON COLUMN public.produtos_filial.moeda IS 'R - Real , D - Dolar , UE - Euro, ST - Sem Tabela';


--
-- TOC entry 4735 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN produtos_filial.idmarca; Type: COMMENT; Schema: public; Owner: systock
--

COMMENT ON COLUMN public.produtos_filial.idmarca IS 'Marca do produto';


--
-- TOC entry 4736 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN produtos_filial.numero_original; Type: COMMENT; Schema: public; Owner: systock
--

COMMENT ON COLUMN public.produtos_filial.numero_original IS 'Número Original do produto - Winthor';


--
-- TOC entry 4737 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN produtos_filial.status_produto; Type: COMMENT; Schema: public; Owner: systock
--

COMMENT ON COLUMN public.produtos_filial.status_produto IS 'CARACTERISTICAS DO PRODUTO';


--
-- TOC entry 4738 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN produtos_filial.cod_comercial; Type: COMMENT; Schema: public; Owner: systock
--

COMMENT ON COLUMN public.produtos_filial.cod_comercial IS 'REFERENCIA COMERCIAL DO PRODUTO';


--
-- TOC entry 4739 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN produtos_filial.multiplo_distribuicao; Type: COMMENT; Schema: public; Owner: systock
--

COMMENT ON COLUMN public.produtos_filial.multiplo_distribuicao IS 'MULTIPLO DE DISTRIBUICAO DA MERCADORIA';


--
-- TOC entry 4740 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN produtos_filial.estoque_recebimento; Type: COMMENT; Schema: public; Owner: systock
--

COMMENT ON COLUMN public.produtos_filial.estoque_recebimento IS 'ESTOQUE EM RECEBIMENTO NA LOGISTICA';


--
-- TOC entry 4741 (class 0 OID 0)
-- Dependencies: 238
-- Name: COLUMN produtos_filial.data_ult_entrada_transf; Type: COMMENT; Schema: public; Owner: systock
--

COMMENT ON COLUMN public.produtos_filial.data_ult_entrada_transf IS 'DATA DA ULTIMA ENTRADA DE TRANSFERENCIA';


--
-- TOC entry 4501 (class 2606 OID 55898)
-- Name: produtos_filial prod_fil_pkey; Type: CONSTRAINT; Schema: public; Owner: systock
--

ALTER TABLE ONLY public.produtos_filial
    ADD CONSTRAINT prod_fil_pkey PRIMARY KEY (filial, idproduto);


--
-- TOC entry 4496 (class 1259 OID 56078)
-- Name: fk_prod_fil_familia_produtos_idx; Type: INDEX; Schema: public; Owner: systock
--

CREATE INDEX fk_prod_fil_familia_produtos_idx ON public.produtos_filial USING btree (idfamilia_produto);


--
-- TOC entry 4497 (class 1259 OID 56102)
-- Name: prod_fil_filial_idx; Type: INDEX; Schema: public; Owner: systock
--

CREATE INDEX prod_fil_filial_idx ON public.produtos_filial USING btree (filial);


--
-- TOC entry 4498 (class 1259 OID 56103)
-- Name: prod_fil_idcomprador_idx; Type: INDEX; Schema: public; Owner: systock
--

CREATE INDEX prod_fil_idcomprador_idx ON public.produtos_filial USING btree (idcomprador);


--
-- TOC entry 4499 (class 1259 OID 56104)
-- Name: prod_fil_idfornecedor_idx; Type: INDEX; Schema: public; Owner: systock
--

CREATE INDEX prod_fil_idfornecedor_idx ON public.produtos_filial USING btree (idfornecedor);


--
-- TOC entry 4502 (class 1259 OID 84186)
-- Name: produtos_filial_cod_produto_idx; Type: INDEX; Schema: public; Owner: systock
--

CREATE INDEX produtos_filial_cod_produto_idx ON public.produtos_filial USING btree (cod_produto);


--
-- TOC entry 4503 (class 1259 OID 84187)
-- Name: produtos_filial_codigo_barras_idx; Type: INDEX; Schema: public; Owner: systock
--

CREATE INDEX produtos_filial_codigo_barras_idx ON public.produtos_filial USING btree (codigo_barras);


--
-- TOC entry 4504 (class 1259 OID 56112)
-- Name: produtos_filial_forn_filial_idx; Type: INDEX; Schema: public; Owner: systock
--

CREATE INDEX produtos_filial_forn_filial_idx ON public.produtos_filial USING btree (idfornecedor, filial);


--
-- TOC entry 4505 (class 1259 OID 56113)
-- Name: produtos_filial_heranca_idx; Type: INDEX; Schema: public; Owner: systock
--

CREATE INDEX produtos_filial_heranca_idx ON public.produtos_filial USING btree (filial, heranca);


--
-- TOC entry 4506 (class 1259 OID 56114)
-- Name: produtos_filial_idproduto_idx; Type: INDEX; Schema: public; Owner: systock
--

CREATE INDEX produtos_filial_idproduto_idx ON public.produtos_filial USING btree (idproduto);


--
-- TOC entry 4508 (class 2620 OID 56164)
-- Name: produtos_filial produtos_filial_trg; Type: TRIGGER; Schema: public; Owner: systock
--

CREATE TRIGGER produtos_filial_trg BEFORE UPDATE ON public.produtos_filial FOR EACH ROW EXECUTE FUNCTION public.trigger_produtos_filial();


--
-- TOC entry 4507 (class 2606 OID 56415)
-- Name: produtos_filial produtos_filial_idmarca_foreign; Type: FK CONSTRAINT; Schema: public; Owner: systock
--

ALTER TABLE ONLY public.produtos_filial
    ADD CONSTRAINT produtos_filial_idmarca_foreign FOREIGN KEY (idmarca) REFERENCES public.marcas(id) ON DELETE CASCADE;


-- Completed on 2026-05-29 11:24:28 -04

--
-- PostgreSQL database dump complete
--

\unrestrict kcvC81caZyWlejYoDv4HuiCUmsQmUgFaLpd1iCjahNXgoxmmK1U7Z8Bv59NIEho

