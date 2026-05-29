--
-- PostgreSQL database dump
--

\restrict nU3tWn9zp5fYYQL373BYUXShI9mLUXvIg3rEpV95SzE6LKceTKXy07eom8ONquZ

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
-- Name: grupo_filiais_drp; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."grupo_filiais_drp" (
    "id_grupo" integer,
    "filial" integer
);


--
-- PostgreSQL database dump complete
--

\unrestrict nU3tWn9zp5fYYQL373BYUXShI9mLUXvIg3rEpV95SzE6LKceTKXy07eom8ONquZ

