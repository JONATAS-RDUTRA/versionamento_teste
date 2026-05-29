--
-- PostgreSQL database dump
--

\restrict LrGlwmded0llHAxHacQX80FFxyN1btZ0FSnbTdNy9VRwhKKGJKG18FHpsDLoK03

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
-- Name: vw_analise_pa_mp; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.vw_analise_pa_mp AS
 SELECT id_fornecedor_materia_prima,
    id_produto_materia_prima,
    ( SELECT DISTINCT pf.descricao_produto
           FROM public.produtos_filial pf
          WHERE ((pf.filial = ANY (ARRAY[15, 16])) AND ((pf.idproduto)::text = (a.id_produto_materia_prima)::text) AND ((pf.revenda)::text = 'S'::text))) AS idfornecedor,
    idproduto_pa,
    descricao_produto,
        CASE
            WHEN (multiplo_compra = (1)::numeric) THEN unidade_master
            ELSE unidade_compra
        END AS unidade_medida,
    tempo_medio_ressuprimento,
    multiplo_compra,
    estoque,
    estoque_seguranca,
    ponto_pedido,
    estoque_maximo,
    consumo_medio_mensal,
    desvio_padrao_consumo,
    consumo_mp_unit,
    consumo_materia_prima_per,
    ( SELECT sum(pf.estoque) AS sum
           FROM public.produtos_filial pf
          WHERE ((pf.filial = ANY (ARRAY[15, 16])) AND ((pf.idproduto)::text = (a.id_produto_materia_prima)::text) AND ((pf.revenda)::text = 'S'::text))) AS total_estoque_mp
   FROM ( SELECT pp.id_fornecedor_materia_prima,
            pp.id_produto_materia_prima,
            pf.idfornecedor,
            pf.idproduto AS idproduto_pa,
            pf.descricao_produto,
            pf.unidade_compra,
            pf.unidade_master,
            pf.tempo_medio_ressuprimento,
            pf.multiplo_compra,
            sum(pf.estoque) AS estoque,
            sum(pf.estoque_seguranca) AS estoque_seguranca,
            sum(pf.ponto_pedido) AS ponto_pedido,
            sum(pf.estoque_maximo) AS estoque_maximo,
            sum(pf.consumo_medio_mensal) AS consumo_medio_mensal,
            sum(pf.desvio_padrao_consumo) AS desvio_padrao_consumo,
            pp.qtde AS consumo_mp_unit,
            round((sum(pf.consumo_medio_mensal) * pp.qtde), 2) AS consumo_materia_prima_per
           FROM (public.produtos_filial pf
             JOIN public.produtos_pa pp ON (((pf.idproduto)::text = (pp.id_produto)::text)))
          WHERE (((pf.idproduto)::text IN ( SELECT DISTINCT pp_1.id_produto
                   FROM public.produtos_pa pp_1)) AND ((pf.status)::text <> 'FL'::text) AND ((pf.revenda)::text = 'S'::text) AND (pf.filial = ANY (ARRAY[15, 16])))
          GROUP BY pf.idfornecedor, pf.idproduto, pf.descricao_produto, pf.unidade_compra, pf.unidade_master, pf.tempo_medio_ressuprimento, pf.multiplo_compra, pp.id_fornecedor_materia_prima, pp.id_produto_materia_prima, pp.qtde
          ORDER BY pp.id_produto_materia_prima) a;


--
-- PostgreSQL database dump complete
--

\unrestrict LrGlwmded0llHAxHacQX80FFxyN1btZ0FSnbTdNy9VRwhKKGJKG18FHpsDLoK03

