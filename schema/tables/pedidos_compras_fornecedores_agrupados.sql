--
-- PostgreSQL database dump
--

\restrict XyIMcLIqduRmjyCFXwShH9zjXIVVhAyueTTDdDlghr84iCXEiTGwdL1sswryYph

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
-- Name: pedidos_compras_fornecedores_agrupados; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."pedidos_compras_fornecedores_agrupados" (
    "id" integer NOT NULL,
    "id_pedido" bigint NOT NULL,
    "id_fornecedor" integer NOT NULL
);


--
-- Name: pedidos_compras_fornecedores_agrupados_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."pedidos_compras_fornecedores_agrupados_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pedidos_compras_fornecedores_agrupados_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."pedidos_compras_fornecedores_agrupados_id_seq" OWNED BY "public"."pedidos_compras_fornecedores_agrupados"."id";


--
-- Name: pedidos_compras_fornecedores_agrupados id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."pedidos_compras_fornecedores_agrupados" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."pedidos_compras_fornecedores_agrupados_id_seq"'::"regclass");


--
-- Name: pedidos_compras_fornecedores_agrupados pk_pedidos_compras_fornecedores_agrupados; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."pedidos_compras_fornecedores_agrupados"
    ADD CONSTRAINT "pk_pedidos_compras_fornecedores_agrupados" PRIMARY KEY ("id");


--
-- Name: pedidos_compras_fornecedores_agrupados fk_fornecedor; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."pedidos_compras_fornecedores_agrupados"
    ADD CONSTRAINT "fk_fornecedor" FOREIGN KEY ("id_fornecedor") REFERENCES "public"."fornecedor"("id");


--
-- Name: pedidos_compras_fornecedores_agrupados fk_pedidos_compra; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."pedidos_compras_fornecedores_agrupados"
    ADD CONSTRAINT "fk_pedidos_compra" FOREIGN KEY ("id_pedido") REFERENCES "public"."pedidos_compras"("idpedido");


--
-- PostgreSQL database dump complete
--

\unrestrict XyIMcLIqduRmjyCFXwShH9zjXIVVhAyueTTDdDlghr84iCXEiTGwdL1sswryYph

