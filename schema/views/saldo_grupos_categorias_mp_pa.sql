--
-- PostgreSQL database dump
--

\restrict JfzQ8V13KzeMOuncbfJZ90ngeCEHiBzHp0bBgwirfdg1Kz3fWz2NtGdeQ2V0W55

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

--
-- Name: saldo_grupos_categorias_mp_pa; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.saldo_grupos_categorias_mp_pa AS
 WITH produtos_pa AS (
         WITH produtos_categoria_pa AS (
                 SELECT pa_2.id_categoria,
                    pa_2.id_produto_pa,
                    sum(pp.peso_pa) AS peso_pa
                   FROM (public.produtos_categoria_mp_pa pa_2
                     JOIN public.produtos_pa pp ON ((((pp.id_produto)::text = (pa_2.id_produto_pa)::text) AND ((pp.id_produto_materia_prima)::text = (pa_2.id_produto_mp)::text))))
                  GROUP BY pa_2.id_categoria, pa_2.id_produto_pa
                )
         SELECT pa_1.data,
            gf.id_grupo,
            cmp.id AS id_categoria,
            cmp.nome AS descricao_categoria,
            sum((pa_1.estoque *
                CASE
                    WHEN (( SELECT cfgsystem.tipo_fator_producao
                       FROM public.cfgsystem
                     LIMIT 1) = 1) THEN pf.peso
                    ELSE pcmp.peso_pa
                END)) AS estoque,
            sum((pa_1.esseg *
                CASE
                    WHEN (( SELECT cfgsystem.tipo_fator_producao
                       FROM public.cfgsystem
                     LIMIT 1) = 1) THEN pf.peso
                    ELSE pcmp.peso_pa
                END)) AS estoque_seguranca,
            sum((pa_1.ppd *
                CASE
                    WHEN (( SELECT cfgsystem.tipo_fator_producao
                       FROM public.cfgsystem
                     LIMIT 1) = 1) THEN pf.peso
                    ELSE pcmp.peso_pa
                END)) AS ponto_pedido,
            sum((pa_1.emax *
                CASE
                    WHEN (( SELECT cfgsystem.tipo_fator_producao
                       FROM public.cfgsystem
                     LIMIT 1) = 1) THEN pf.peso
                    ELSE pcmp.peso_pa
                END)) AS estoque_maximo,
            sum((pa_1.cmm *
                CASE
                    WHEN (( SELECT cfgsystem.tipo_fator_producao
                       FROM public.cfgsystem
                     LIMIT 1) = 1) THEN pf.peso
                    ELSE pcmp.peso_pa
                END)) AS consumo_medio
           FROM ((((public.categorias_mp_pa cmp
             JOIN produtos_categoria_pa pcmp ON ((pcmp.id_categoria = cmp.id)))
             JOIN public.saldo_filiais pa_1 ON (((pa_1.idproduto)::text = (pcmp.id_produto_pa)::text)))
             JOIN public.produtos_filial pf ON (((pf.filial = pa_1.filial) AND ((pf.idproduto)::text = (pa_1.idproduto)::text))))
             JOIN public.grupo_filial gf ON ((gf.filial = pa_1.filial)))
          GROUP BY pa_1.data, gf.id_grupo, cmp.id
        ), produtos_mp AS (
         WITH produtos_categoria_mp AS (
                 SELECT DISTINCT mp_2.id_categoria,
                    mp_2.id_produto_mp
                   FROM public.produtos_categoria_mp_pa mp_2
                )
         SELECT sg.data,
            sg.id_grupo,
            mp_1.id_categoria,
            sum(sg.estoque) AS estoque,
            sum(sg.esseg) AS estoque_seguranca,
            sum(sg.ppd) AS ponto_pedido,
            sum(sg.emax) AS estoque_maximo,
            sum(sg.cmm) AS consumo_medio
           FROM (public.saldo_grupos sg
             JOIN produtos_categoria_mp mp_1 ON (((mp_1.id_produto_mp)::text = (sg.idproduto)::text)))
          GROUP BY sg.data, sg.id_grupo, mp_1.id_categoria
        )
 SELECT mp.data,
    mp.id_grupo,
    mp.id_categoria,
    (pa.estoque + mp.estoque) AS estoque,
    (pa.estoque_seguranca + mp.estoque_seguranca) AS estoque_seguranca,
    (pa.ponto_pedido + mp.ponto_pedido) AS ponto_pedido,
    (pa.estoque_maximo + mp.estoque_maximo) AS estoque_maximo,
    (pa.consumo_medio + mp.consumo_medio) AS consumo_medio
   FROM (produtos_pa pa
     JOIN produtos_mp mp ON (((mp.id_grupo = pa.id_grupo) AND (mp.id_categoria = pa.id_categoria) AND (mp.data = pa.data))));


--
-- PostgreSQL database dump complete
--

\unrestrict JfzQ8V13KzeMOuncbfJZ90ngeCEHiBzHp0bBgwirfdg1Kz3fWz2NtGdeQ2V0W55

