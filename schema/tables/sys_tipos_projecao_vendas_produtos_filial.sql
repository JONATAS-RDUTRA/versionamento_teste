--
-- PostgreSQL database dump
--

\restrict LFIMaJ0Wi45FcdlqesNwjWHWED0lUuPYNlKdAuLzMpU6dLucwJgasBTcoGlsBo5

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
-- Name: sys_tipos_projecao_vendas_produtos_filial; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."sys_tipos_projecao_vendas_produtos_filial" (
    "filial" integer NOT NULL,
    "idproduto" character varying(25) NOT NULL,
    "tipo" character varying(35) NOT NULL,
    "id_usuario" integer NOT NULL,
    "created_at" timestamp(0) without time zone NOT NULL,
    "updated_at" timestamp(0) without time zone NOT NULL,
    CONSTRAINT "check_tipos_permitidos" CHECK ((("tipo")::"text" = ANY (ARRAY[('media_sazonal'::character varying)::"text", ('suavizacao_exponencial'::character varying)::"text", ('media_aritmetica_simples_trimestre'::character varying)::"text", ('media_aritmetica_simples_semestre'::character varying)::"text", ('media_aritmetica_simples_ano'::character varying)::"text", ('media_geometrica'::character varying)::"text", ('media_movel_ponderada'::character varying)::"text", ('mediana'::character varying)::"text"])))
);


--
-- Name: sys_tipos_projecao_vendas_produtos_filial sys_tipos_projecao_vendas_produtos_filial_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."sys_tipos_projecao_vendas_produtos_filial"
    ADD CONSTRAINT "sys_tipos_projecao_vendas_produtos_filial_pkey" PRIMARY KEY ("filial", "idproduto");


--
-- Name: sys_tipos_projecao_vendas_produtos_filial sys_tipos_projecao_vendas_produtos_filial_usuario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."sys_tipos_projecao_vendas_produtos_filial"
    ADD CONSTRAINT "sys_tipos_projecao_vendas_produtos_filial_usuario_fkey" FOREIGN KEY ("id_usuario") REFERENCES "public"."users"("id");


--
-- PostgreSQL database dump complete
--

\unrestrict LFIMaJ0Wi45FcdlqesNwjWHWED0lUuPYNlKdAuLzMpU6dLucwJgasBTcoGlsBo5

