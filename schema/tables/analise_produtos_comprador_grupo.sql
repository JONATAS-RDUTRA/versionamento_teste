--
-- PostgreSQL database dump
--

\restrict 0NcFSifJdBvJEWpi4ptvru32Gy4sgZzEv9NNXHeZdlZanB6b31PqFIZjHDAqI5x

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
-- Name: analise_produtos_comprador_grupo; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."analise_produtos_comprador_grupo" (
    "data_referencia" "date" NOT NULL,
    "ano" integer NOT NULL,
    "mes" integer NOT NULL,
    "id_grupo" bigint NOT NULL,
    "idfornecedor" integer NOT NULL,
    "idcomprador" integer NOT NULL,
    "pedidos_em_valor" numeric DEFAULT 0 NOT NULL,
    "entregue_em_valor" numeric DEFAULT 0 NOT NULL,
    "pendente_em_valor" numeric DEFAULT 0 NOT NULL,
    "sku_total_saldo" integer DEFAULT 0 NOT NULL,
    "sku_com_estoque" integer DEFAULT 0 NOT NULL,
    "valor_estoque" numeric DEFAULT 0 NOT NULL,
    "sku_excesso" integer DEFAULT 0 NOT NULL,
    "valor_excesso" numeric DEFAULT 0 NOT NULL,
    "valor_ruptura" numeric DEFAULT 0 NOT NULL,
    "sku_zerado" integer DEFAULT 0 NOT NULL,
    "valor_saving" numeric DEFAULT 0 NOT NULL,
    "sku_percepcao_compra_com_ruptura" integer DEFAULT 0 NOT NULL,
    "sku_percepcao_compra_exposto_ruptura" integer DEFAULT 0 NOT NULL,
    "sku_percepcao_compra_ponto_pedido" integer DEFAULT 0 NOT NULL,
    "sku_percepcao_compra_prematuridade" integer DEFAULT 0 NOT NULL,
    "sku_percepcao_compra_sem_comportamento" integer DEFAULT 0 NOT NULL
);


--
-- Name: analise_produtos_comprador_grupo analise_produtos_comprador_grupo_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."analise_produtos_comprador_grupo"
    ADD CONSTRAINT "analise_produtos_comprador_grupo_pk" PRIMARY KEY ("ano", "mes", "id_grupo", "idfornecedor", "idcomprador");


--
-- PostgreSQL database dump complete
--

\unrestrict 0NcFSifJdBvJEWpi4ptvru32Gy4sgZzEv9NNXHeZdlZanB6b31PqFIZjHDAqI5x

