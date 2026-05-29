--
-- PostgreSQL database dump
--

\restrict xmoWdUy45HQqOsgfhKOYWzeY5YUMrmAMSscY0azs2uJ9qEeg0qw9kLCpfOx8k9v

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
-- Name: vw_requisicoes; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.vw_requisicoes AS
 SELECT requisicoes.id_solicitacao,
    requisicoes.idproduto,
    requisicoes.data_solicitacao,
    requisicoes.data_liberacao,
    requisicoes.data_entrega AS data_entrada,
    requisicoes.ordem_compra,
        CASE
            WHEN ((COALESCE(requisicoes.data_entrega, COALESCE(NULL::date, ((requisicoes.data_solicitacao + (((ceil(produtos.tempo_medio_ressuprimento) + ceil(produtos.desvio_padrao_ressuprimento)) || ' day'::text))::interval))::date)) - requisicoes.data_solicitacao) > 0) THEN (COALESCE(requisicoes.data_entrega, COALESCE(NULL::date, ((requisicoes.data_solicitacao + (((ceil(produtos.tempo_medio_ressuprimento) + ceil(produtos.desvio_padrao_ressuprimento)) || ' day'::text))::interval))::date)) - requisicoes.data_solicitacao)
            ELSE NULL::integer
        END AS tempo_ressuprimento,
    requisicoes.descricao_produto,
    requisicoes.qtde,
    requisicoes.unidade_medida,
        CASE
            WHEN ((requisicoes.qtde_pendente = (0)::double precision) AND (requisicoes.data_entrega IS NULL)) THEN 0
            WHEN (requisicoes.data_entrega IS NULL) THEN (('now'::text)::date - COALESCE(NULL::date, ((requisicoes.data_solicitacao + (((ceil(produtos.tempo_medio_ressuprimento) + ceil(produtos.desvio_padrao_ressuprimento)) || ' day'::text))::interval))::date))
            ELSE 0
        END AS atraso,
    requisicoes.data_previsao,
    requisicoes.data_faturamento,
        CASE
            WHEN ((requisicoes.data_faturamento - requisicoes.data_solicitacao) < 0) THEN 0
            ELSE (requisicoes.data_faturamento - requisicoes.data_solicitacao)
        END AS tempo_faturamento,
    COALESCE(NULL::date, ((requisicoes.data_solicitacao + (((ceil(produtos.tempo_medio_ressuprimento) + ceil(produtos.desvio_padrao_ressuprimento)) || ' day'::text))::interval))::date) AS data_prevista_cal,
    requisicoes.qtde_entregue,
    requisicoes.qtde_pendente,
    (requisicoes.data_entrega - requisicoes.data_solicitacao) AS tempo_entrega,
    requisicoes.pcompra,
    (requisicoes.qtde * requisicoes.pcompra) AS tcompra,
    requisicoes.pcompraant,
    requisicoes.pliquido,
    NULLIF(round(((((requisicoes.pcompra / NULLIF(requisicoes.pcompraant, (0)::double precision)) - (1)::double precision) * (100)::double precision))::numeric, 2), (0)::numeric) AS indicador_preco,
    requisicoes.idfilial AS filial,
    requisicoes.item,
    requisicoes.qtde_faturada
   FROM (public.requisicoes
     JOIN public.vw_produtos_tempo_ressuprimento produtos ON (((produtos.filial = requisicoes.idfilial) AND ((produtos.idproduto)::text = (requisicoes.idproduto)::text))))
  ORDER BY requisicoes.id_solicitacao, requisicoes.data_solicitacao;


--
-- PostgreSQL database dump complete
--

\unrestrict xmoWdUy45HQqOsgfhKOYWzeY5YUMrmAMSscY0azs2uJ9qEeg0qw9kLCpfOx8k9v

