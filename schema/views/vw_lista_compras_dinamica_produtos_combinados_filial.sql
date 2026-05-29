--
-- PostgreSQL database dump
--

\restrict WKF8SW1oQBHPwaMycfqA8cYDHtKEvuYA28skTFal4TujAyiHi8jhEoatwuHp0le

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
-- Name: vw_lista_compras_dinamica_produtos_combinados_filial; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.vw_lista_compras_dinamica_produtos_combinados_filial AS
 SELECT v.id_grupo,
    v.filial,
    v.id_produto_combinado,
    'CP'::text AS tipo,
    'RESSUPRIR'::text AS status_suprimento_sku,
    ceil(v.lote_compras) AS sugestao,
    ( SELECT COALESCE((max(hgcg.data) - ('now'::text)::date), 0) AS tempo
           FROM public.hist_gatilho_compras_grupo hgcg
          WHERE ((hgcg.grupo = (v.id_grupo)::numeric) AND ((hgcg.idproduto)::text = ANY ((v.produtos)::text[])) AND ((hgcg.tipo)::text = 'CP'::text) AND ((hgcg.status)::text = 'A'::text))) AS tempo_gatilho
   FROM public.produtos_combinados_compras_filial v
  WHERE ((v.lote_compras > (0)::numeric) AND (v.sob_encomenda = 0) AND (v.revenda = 'S'::text) AND (v.revenda <> 'FL'::text))
UNION
 SELECT v.id_grupo,
    v.filial,
    v.id_produto_combinado,
    'TR'::text AS tipo,
    v.status AS status_suprimento_sku,
    ceil(v.lote_compras) AS sugestao,
    ( SELECT COALESCE((max(hgcg.data) - ('now'::text)::date), 0) AS tempo
           FROM public.hist_gatilho_compras_grupo hgcg
          WHERE ((hgcg.grupo = (v.id_grupo)::numeric) AND ((hgcg.idproduto)::text = ANY ((v1.produtos)::text[])) AND ((hgcg.tipo)::text = 'CP'::text) AND ((hgcg.status)::text = 'A'::text))) AS tempo_gatilho
   FROM (public.produtos_combinados_transito_filial v
     JOIN public.produtos_combinados_compras_filial v1 ON (((v1.id_grupo = v.id_grupo) AND (v1.filial = v.filial) AND ((v1.id_produto_combinado)::text = (v.id_produto_combinado)::text))))
  WHERE (v.lote_compras > (0)::double precision)
UNION
 SELECT v.id_grupo,
    v.filial,
    v.id_produto_combinado,
    'FC'::text AS tipo,
    'OK'::text AS status_suprimento_sku,
    ceil(v.lote_compras) AS sugestao,
    ( SELECT COALESCE((max(hgcg.data) - ('now'::text)::date), 0) AS tempo
           FROM public.hist_gatilho_compras_grupo hgcg
          WHERE ((hgcg.grupo = (v.id_grupo)::numeric) AND ((hgcg.idproduto)::text = ANY ((v1.produtos)::text[])) AND ((hgcg.tipo)::text = 'CP'::text) AND ((hgcg.status)::text = 'A'::text))) AS tempo_gatilho
   FROM (public.produtos_combinados_forecast_filial v
     JOIN public.produtos_combinados_compras_filial v1 ON (((v1.id_grupo = v.id_grupo) AND (v1.filial = v.filial) AND ((v1.id_produto_combinado)::text = (v.id_produto_combinado)::text))));


--
-- PostgreSQL database dump complete
--

\unrestrict WKF8SW1oQBHPwaMycfqA8cYDHtKEvuYA28skTFal4TujAyiHi8jhEoatwuHp0le

