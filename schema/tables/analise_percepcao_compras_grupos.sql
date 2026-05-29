--
-- PostgreSQL database dump
--

\restrict 6dQZ4WwRO3BjkYSAY5tIZcv8XL6VdoVtgPW2KhLofTW34gZXErwPKW4e1SKLhUp

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
-- Name: analise_percepcao_compras_grupos; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."analise_percepcao_compras_grupos" (
    "id_grupo" bigint NOT NULL,
    "filial" bigint NOT NULL,
    "data_solicitacao" "date" NOT NULL,
    "ordem_compra" double precision NOT NULL,
    "data_entrada" "date",
    "total_entradas" double precision,
    "sugestao" numeric,
    "idproduto" character varying NOT NULL,
    "descricao_produto" character varying NOT NULL,
    "descricao_familia_produto" character varying,
    "estoque_no_dia_entrada" numeric,
    "estoque_seguranca" numeric,
    "ponto_pedido" numeric,
    "estoque_maximo" numeric,
    "tempo_medio_ressuprimento" numeric,
    "consumo_medio" numeric,
    "estoque_solicitacao" numeric,
    "valor_unitario" numeric,
    "custo_unitario" numeric,
    "nome_comprador" character varying,
    "status_percepcao" "text",
    "qtde_sem_comportamento" character varying,
    "fator_conversao" numeric,
    "idcomprador" bigint,
    "idfornecedor" bigint,
    "nivel_servico" character varying,
    "produto_eh_combinacao" boolean DEFAULT false NOT NULL,
    "flag" character varying(1),
    "produto_eh_categoria_mp_pa" boolean DEFAULT false NOT NULL
);


--
-- PostgreSQL database dump complete
--

\unrestrict 6dQZ4WwRO3BjkYSAY5tIZcv8XL6VdoVtgPW2KhLofTW34gZXErwPKW4e1SKLhUp

