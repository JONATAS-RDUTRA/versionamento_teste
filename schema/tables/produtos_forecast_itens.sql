--
-- PostgreSQL database dump
--

\restrict 4Kmre831UP0MIWpWMjnZo7zIbNAZ6gXBZ1bEFa0YMGg6qquRpwclAJ5C1pS5WNX

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
-- Name: produtos_forecast_itens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."produtos_forecast_itens" (
    "idproduto" character varying(35) NOT NULL,
    "tempo_forecast" integer NOT NULL
);


--
-- Name: produtos_forecast_itens produtos_forecast_itens_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."produtos_forecast_itens"
    ADD CONSTRAINT "produtos_forecast_itens_pk" PRIMARY KEY ("idproduto");


--
-- PostgreSQL database dump complete
--

\unrestrict 4Kmre831UP0MIWpWMjnZo7zIbNAZ6gXBZ1bEFa0YMGg6qquRpwclAJ5C1pS5WNX

