--
-- PostgreSQL database dump
--

\restrict ydeXB9iuMz3oaTy2g6vr5hjdHpHf2vKuSDlegdAMbuvWa12JRUVR3jghoEs5rxQ

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
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."users" (
    "id" integer NOT NULL,
    "name" character varying(255) NOT NULL,
    "email" character varying(255) NOT NULL,
    "email_verified_at" timestamp without time zone,
    "password" character varying(255) NOT NULL,
    "remember_token" character varying(100),
    "created_at" character varying(30),
    "updated_at" character varying(30),
    "setor" character varying(40),
    "service" character varying(1) DEFAULT 'N'::character varying NOT NULL,
    "hash_acesso" character varying(255),
    "idperfil" integer,
    "visao_gerencial" character varying(1) DEFAULT 'N'::character varying NOT NULL,
    "atualizacao_auto" character varying(1) DEFAULT 'S'::character varying NOT NULL,
    "cod_sistema" character varying(25),
    "ativo" character varying(1) DEFAULT 'S'::character varying NOT NULL,
    "bloquear_hist_faturamento" boolean DEFAULT false,
    "data_inicial_indicador_evolucao_slow_no_moving" character varying(10),
    "data_final_indicador_evolucao_slow_no_moving" character varying(10),
    "ativar_parametrizacao_diagnostico" boolean DEFAULT false,
    "nps_ultima_data_resposta" character varying(30)
);


--
-- Name: COLUMN "users"."data_inicial_indicador_evolucao_slow_no_moving"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."users"."data_inicial_indicador_evolucao_slow_no_moving" IS '1. Primeiro dia do mês fechado, 2. Primeiro dia do mês corrente ou 3. Data específica';


--
-- Name: COLUMN "users"."data_final_indicador_evolucao_slow_no_moving"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."users"."data_final_indicador_evolucao_slow_no_moving" IS '1. Último dia do mês fechado, 2. Último dia do mês corrente ou uma 3. Data espeficica';


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."users_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."users_id_seq" OWNED BY "public"."users"."id";


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."users" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."users_id_seq"'::"regclass");


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_pkey" PRIMARY KEY ("id");


--
-- Name: users fk_user_perfil; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "fk_user_perfil" FOREIGN KEY ("idperfil") REFERENCES "public"."perfil"("idperfil");


--
-- PostgreSQL database dump complete
--

\unrestrict ydeXB9iuMz3oaTy2g6vr5hjdHpHf2vKuSDlegdAMbuvWa12JRUVR3jghoEs5rxQ

