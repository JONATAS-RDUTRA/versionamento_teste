--
-- PostgreSQL database dump
--

\restrict vrEgOWjj4ur2GIF5PPYi5DbsjLV8eXX0JahJzV7I4RLU07x9KREWc1MyO8qEQxh

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
-- Name: users_api; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."users_api" (
    "id" integer NOT NULL,
    "id_usuario" integer NOT NULL,
    "token" character varying(256) NOT NULL,
    "data_validade" "date"
);


--
-- Name: users_api_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."users_api_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_api_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."users_api_id_seq" OWNED BY "public"."users_api"."id";


--
-- Name: users_api id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."users_api" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."users_api_id_seq"'::"regclass");


--
-- Name: users_api pk_users_api; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."users_api"
    ADD CONSTRAINT "pk_users_api" PRIMARY KEY ("id");


--
-- Name: users_api_token_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "users_api_token_idx" ON "public"."users_api" USING "btree" ("token");


--
-- Name: users_api fk_id_usuario_users_api; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."users_api"
    ADD CONSTRAINT "fk_id_usuario_users_api" FOREIGN KEY ("id_usuario") REFERENCES "public"."users"("id");


--
-- PostgreSQL database dump complete
--

\unrestrict vrEgOWjj4ur2GIF5PPYi5DbsjLV8eXX0JahJzV7I4RLU07x9KREWc1MyO8qEQxh

