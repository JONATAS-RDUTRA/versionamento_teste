--
-- PostgreSQL database dump
--

\restrict RC9GGoNJuUDGMVw1PWTBi42A6W3IA6iXheNJp7X6pA7ZO4sveWmdjK2tXbFVusB

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
-- Name: cfgsystem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."cfgsystem" (
    "id" integer NOT NULL,
    "razao_social" character varying(120),
    "cnpj" character varying(25),
    "licencas" integer NOT NULL,
    "data_verificacao" "date",
    "prox_verificacao" "date",
    "contrato" character varying(25),
    "data_inicio" "date",
    "data_fim" "date",
    "hash_validacao" character varying(50),
    "filial_compra" character varying(1) DEFAULT 'N'::character varying NOT NULL,
    "fator_atuacao" character varying(1) DEFAULT 'N'::character varying NOT NULL,
    "compra_unificada" character varying(1) DEFAULT 'N'::character varying NOT NULL,
    "tempo_forecast" integer DEFAULT 15 NOT NULL,
    "verificar_compra_mista" character varying(1) DEFAULT 'S'::character varying NOT NULL,
    "logo_cliente" character varying(1000) DEFAULT 'systock.png'::character varying NOT NULL,
    "filtro_comprador" character varying(1) DEFAULT 'N'::character varying NOT NULL,
    "multiplo_compras" character varying(1) DEFAULT 'N'::character varying,
    "filtro_segmento" character varying(1) DEFAULT 'N'::character varying NOT NULL,
    "converter_emb_master" character varying(1) DEFAULT 'N'::character varying NOT NULL,
    "id_erp" integer DEFAULT 4 NOT NULL,
    "validar_compra_oportunidade" character varying(1) DEFAULT 'N'::character varying NOT NULL,
    "versao_bd_systock" character varying(15),
    "fracionar_pedido" character varying(1) DEFAULT 'N'::character varying,
    "email_aviso_licenca" boolean DEFAULT false NOT NULL,
    "integracao_protheus" character varying(1) DEFAULT 'N'::character varying NOT NULL,
    "casas_decimais_carrinho" integer DEFAULT 4 NOT NULL,
    "tipo_drp" integer DEFAULT 1 NOT NULL,
    "exportacao_protheus_drp" character varying(1) DEFAULT 'N'::character varying NOT NULL,
    "drp_multipla_selecao_filiais" character varying(1) DEFAULT 'S'::character varying NOT NULL,
    "compra_multifiliais" character varying(1) DEFAULT 'N'::character varying NOT NULL,
    "drp_mapeamento_distribuicao_por_categpria" character varying(1) DEFAULT 'N'::character varying NOT NULL,
    "drp_separacao_pelo_multiplo_compra" character varying(1) DEFAULT 'N'::character varying NOT NULL,
    "integracao_sankhya" character varying(1) DEFAULT 'N'::character varying NOT NULL,
    "drp_formula_estoque_disponivel" "text" DEFAULT '((p.estoque + p.estoque_transito_drp)-(p.estoque_reservado + p.estoque_bloqueado + p.estoque_avaria + p.estoque_similar))'::"text" NOT NULL,
    "compras_analise_por_departamentos" boolean DEFAULT false,
    "ativar_grupo_economico_compra" boolean DEFAULT false NOT NULL,
    "data_ult_integracao" character varying(30),
    "ativar_mix_produto" character varying(1) DEFAULT 'N'::character varying NOT NULL,
    "url_chat_bot" character varying(100),
    "qtde_dias_log_historico_diagnostico" integer DEFAULT 15 NOT NULL,
    "drp_pertence_mix" character varying(1) DEFAULT 'N'::character varying NOT NULL,
    "exportacao_winthor_drp" character(1) DEFAULT 'N'::"bpchar" NOT NULL,
    "drp_exportacao_automatica_pedidos_robo" boolean DEFAULT true,
    "preco_compra_grupo" boolean DEFAULT false,
    "estetico_por_pp" boolean DEFAULT false NOT NULL,
    "sugerir_lote_fechado_em_completar_compra" boolean DEFAULT false,
    "tipo_de_calculo" integer DEFAULT 1 NOT NULL,
    "integracao_exportacao_cisspoder_integrim" boolean DEFAULT false NOT NULL,
    "ativar_filtro_tipo_produto_rd" boolean DEFAULT false,
    "lote_minimo_a_partir_de" boolean DEFAULT false NOT NULL,
    "carrinhos_compras_por_filtros_selecionados" boolean DEFAULT false NOT NULL,
    "ativar_filtro_produtos_inativos_tela_compras" boolean DEFAULT false NOT NULL,
    "ativar_exibicao_filial_cd_tela_compras" boolean DEFAULT false NOT NULL,
    "integracao_exportacao_gemco" boolean DEFAULT false NOT NULL,
    "drp_ativar_edicao_qtde_carrinho" boolean DEFAULT false NOT NULL,
    "diagnostico_clientes_periodicidade_emails" numeric DEFAULT 7 NOT NULL,
    "data_ultima_atualizacao_emails_diagnostico_clientes" timestamp without time zone,
    "drp_reverso_formula_estoque_disponivel" character varying(250) DEFAULT '((prod.estoque - prod.emax_reverso) - ((prod.estoque - prod.emax_reverso) % coalesce(nullif(prod.fator_conversao, 0), 1)))'::character varying NOT NULL,
    "compras_completar_compra_por_ponto_pedido_cd" character varying(1) DEFAULT 'N'::character varying,
    "tipo_fator_producao" integer DEFAULT 1 NOT NULL,
    "compras_xml_cisspoder_multiplicar_pelo_lote_minimo" boolean DEFAULT false NOT NULL,
    "compras_analise_por_lote" boolean DEFAULT false NOT NULL,
    "qtde_dias_log_historico_diagnostico_drp" integer DEFAULT 7 NOT NULL,
    "integracao_exportacao_citel" boolean DEFAULT false NOT NULL,
    "drp_exportacao_nativa_winthor" boolean DEFAULT false NOT NULL,
    "integracao_exportacao_nerus" boolean DEFAULT false NOT NULL,
    "habilitar_validade_lote" boolean DEFAULT false,
    "exportacao_drp_padre_cicero" boolean DEFAULT false,
    "exportacao_casa_tudo_sacolao" boolean DEFAULT false,
    "usar_filial_cd_no_lugar_da_matriz" boolean DEFAULT false,
    "exportacao_nativa_winthor_sequencia_numpedrca" integer DEFAULT 101000100 NOT NULL,
    "compras_exportacao_nativa_winthor" boolean DEFAULT false NOT NULL,
    "drp_exportacao_nativa_winthor_qtunit_igual_um" boolean DEFAULT false NOT NULL,
    "exportacao_compras_padre_cicero" boolean DEFAULT false,
    "ativar_exibicao_campo_numero_original" boolean DEFAULT false NOT NULL,
    "ocultar_produtos_sob_encomenda_do_completar_compra" boolean DEFAULT false NOT NULL,
    "drp_fracionamento_pedidos_por_filiais_origem_destino_unicos" boolean DEFAULT false NOT NULL,
    "drp_fracionamento_pedidos_qtd_produtos" integer DEFAULT 0 NOT NULL,
    "drp_fracionamento_pedidos_peso" integer DEFAULT 0 NOT NULL,
    "ocultar_colunas_do_relatorio_drp_cb" boolean DEFAULT false NOT NULL,
    "ativar_exibicao_id_produto_similar" boolean DEFAULT false NOT NULL,
    "compras_carrinho_ativar_consolidacao_pedidos_em_relatorios" boolean DEFAULT false NOT NULL,
    "integracao_sankhya_exibir_fornecedor" boolean DEFAULT false NOT NULL,
    "integracao_rms_drp_via_arquivo" boolean DEFAULT false NOT NULL,
    "exportacao_pedido_compra_gravia" boolean DEFAULT false NOT NULL,
    "dashboard_pedidos_pendentes_ocultar_nivel_marca" boolean DEFAULT false NOT NULL,
    "config_grupo_compra_padrao" integer DEFAULT 1 NOT NULL,
    "compras_tela_exportacao_api_pedidos_systock" boolean DEFAULT false NOT NULL,
    "diagnostico_ocultar_nivel_fornecedor" boolean DEFAULT false NOT NULL,
    "carteira_comprador_ativar_limitacao_visualizacao" boolean DEFAULT false,
    "similaridade_com_agregar_estoque_igual_em_ambas_direcoes" boolean DEFAULT false NOT NULL,
    "integracao_sankhya_usando_api_gateway" boolean DEFAULT false NOT NULL,
    "ocultar_considerar_estoque_grupo_na_compra_por_filial" boolean DEFAULT false NOT NULL,
    "compras_exibir_grupo_compras_usuario" boolean DEFAULT false NOT NULL,
    "compras_tela_exportacao_api_andra" boolean DEFAULT false NOT NULL,
    "compras_conversao_embalagem_master_padrao" boolean DEFAULT false NOT NULL,
    "mix_produtos_filial_ativar_limitacao_visualizacao" boolean DEFAULT false,
    "compra_visualizar_webcotacao_ativo" boolean DEFAULT false,
    "ocultar_flag_apenas_qtde_pendente_maior_que_zero" boolean DEFAULT true,
    "zendesk_4697_trocar_codigo_fornecedor_por_codigo_barras" boolean DEFAULT false NOT NULL,
    "ignorar_movimentacao_filtro_linhas" boolean DEFAULT false,
    "relatorio_analise_vendas_incluir_por_produto" boolean DEFAULT false,
    "integracao_exportacao_dunorte" boolean DEFAULT false NOT NULL,
    "drp_selecionar_outras_filiais_distribuicao_reversa" boolean DEFAULT false NOT NULL,
    "ativar_personalizacao_colunas_sys_data_table" boolean DEFAULT false NOT NULL,
    CONSTRAINT "cfg_compra_multifiliais_check" CHECK ((("compra_multifiliais")::"text" = ANY (ARRAY[('N'::character varying)::"text", ('S'::character varying)::"text"]))),
    CONSTRAINT "cfgsystem_casas_decimais_carrinho_check" CHECK ((("casas_decimais_carrinho" >= 1) AND ("casas_decimais_carrinho" <= 4)))
);


--
-- Name: COLUMN "cfgsystem"."tipo_drp"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."cfgsystem"."tipo_drp" IS '1 - Esseg, 2 - Cmm, 3 - Cmm ou porcentagem(Cmm para loja e 5% do cmm quando por filial CD), 4 - Estoque estetico, 5 - Quem for maior entre o esseg e estoque estetico';


--
-- Name: COLUMN "cfgsystem"."ativar_mix_produto"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."cfgsystem"."ativar_mix_produto" IS 'S - na tela de multifilial só será exibido produto nas filiais contidas na tebal cfg_produto_distribuicao, N - na tela de multifilial será exibido todas as filiais';


--
-- Name: COLUMN "cfgsystem"."tipo_de_calculo"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."cfgsystem"."tipo_de_calculo" IS '1 - SYTOCK, 2 - WERMON(QUEIROZ)';


--
-- Name: cfgsystem_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."cfgsystem_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cfgsystem_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."cfgsystem_id_seq" OWNED BY "public"."cfgsystem"."id";


--
-- Name: cfgsystem id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cfgsystem" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."cfgsystem_id_seq"'::"regclass");


--
-- Name: cfgsystem cfgsystem_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cfgsystem"
    ADD CONSTRAINT "cfgsystem_pk" PRIMARY KEY ("id");


--
-- Name: cfgsystem cfgsystem_sistemas_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cfgsystem"
    ADD CONSTRAINT "cfgsystem_sistemas_fk" FOREIGN KEY ("id_erp") REFERENCES "public"."integracao_sistemas"("id");


--
-- PostgreSQL database dump complete
--

\unrestrict RC9GGoNJuUDGMVw1PWTBi42A6W3IA6iXheNJp7X6pA7ZO4sveWmdjK2tXbFVusB

