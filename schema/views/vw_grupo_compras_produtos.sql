--
-- PostgreSQL database dump
--

\restrict NKFBhVndEz3lykLSYa2wzyXklmU1qIWPE4xaamjsn6A8ydHkyo5oSpl6ePvLR9t

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
-- Name: vw_grupo_compras_produtos; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.vw_grupo_compras_produtos AS
 SELECT id_grupo,
    idproduto,
    descricao_produto,
    idcomprador,
    idfornecedor,
    idfamilia_produto,
    revenda,
    status,
    estoque,
    COALESCE(round((estoque / NULLIF(consumo_medio_mensal, (0)::numeric)), 4), (0)::numeric) AS cobertura_estoque,
    estoque_seguranca,
    ponto_pedido,
    estoque_maximo,
    consumo_medio_mensal,
    desvio_padrao_consumo,
    tempo_medio_ressuprimento,
    tempo_ressuprimento,
    desvio_padrao_ressuprimento,
    coeficiente_variacao,
    compra_transito,
    lote_minimo,
    lote_compras_bruto,
    arvore_decisao,
    nivel_servico,
    peso_compras,
    unidade_compra,
    lote_embalagem,
        CASE
            WHEN ((lote_compras_bruto > (0)::numeric) AND (lote_embalagem = (0)::numeric)) THEN 1
            ELSE 0
        END AS sob_encomenda,
        CASE
            WHEN ((lote_embalagem > (0)::numeric) AND (COALESCE(round((estoque / NULLIF(consumo_medio_mensal, (0)::numeric)), 4), (0)::numeric) < tempo_ressuprimento) AND (compra_transito = (0)::numeric)) THEN public.gerar_lote_embalagem(estoque_maximo, COALESCE(lote_minimo, (1)::numeric))
            ELSE lote_embalagem
        END AS lote_compras,
    preco_compra,
    custo_unitario,
    valor_unitario,
    estoque_bloqueado,
        CASE
            WHEN (((coeficiente_variacao)::numeric > (0)::numeric) AND ((coeficiente_variacao)::numeric <= (200)::numeric)) THEN 'REPETITIVO'::text
            WHEN (((coeficiente_variacao)::numeric > (200)::numeric) AND ((coeficiente_variacao)::numeric <= (600)::numeric)) THEN 'ESTATISTICO'::text
            ELSE 'OCASIONAL'::text
        END AS perfil_demanda,
    tempo_medio_apanhe,
    embalagem,
    idunidade_medida,
    ressuprimento_manual,
    ressuprimento_manual_dias,
    cod_produto,
    codigo_barras,
    fator_conversao,
    fator_atuacao,
    multiplo_compra,
    estoque_similar,
    projecao_rentabilidade,
    estoque_avaria,
    peso,
    altura,
    largura,
    comprimento,
    ( SELECT max(r.data_solicitacao) AS max
           FROM public.requisicoes r
          WHERE (((r.idproduto)::text = (lote.idproduto)::text) AND (r.idfilial IN ( SELECT gf.filial
                   FROM public.grupo_filial gf
                  WHERE (gf.id_grupo = lote.id_grupo))))) AS data_ultima_requisicao,
    estoque_reservado,
    unidade_master
   FROM ( SELECT a.id_grupo,
            a.idproduto,
            a.descricao_produto,
            a.idcomprador,
            a.idfornecedor,
            a.idfamilia_produto,
            a.revenda,
            a.status,
            a.estoque,
            a.cobertura_estoque,
            a.estoque_seguranca,
            a.ponto_pedido,
            a.estoque_maximo,
            a.consumo_medio_mensal,
            a.desvio_padrao_consumo,
            a.tempo_medio_ressuprimento,
            a.tempo_ressuprimento,
            a.desvio_padrao_ressuprimento,
            a.coeficiente_variacao,
            a.compra_transito,
            a.lote_minimo,
                CASE
                    WHEN (((a.coeficiente_variacao)::numeric > (0)::numeric) AND (a.compra_transito = (0)::numeric) AND (a.estoque <= a.ponto_pedido) AND ((a.revenda)::text = 'S'::text) AND ((a.status)::text <> 'FL'::text)) THEN round(((a.estoque_maximo + (a.consumo_medio_mensal * (a.tempo_ressuprimento + a.desvio_padrao_ressuprimento))) - a.estoque), 2)
                    WHEN (((a.coeficiente_variacao)::numeric = (0)::numeric) AND (a.compra_transito = (0)::numeric) AND (a.estoque <= a.ponto_pedido) AND ((a.revenda)::text = 'S'::text) AND ((a.status)::text <> 'FL'::text)) THEN ceil((a.consumo_medio_mensal / (2)::numeric))
                    ELSE (0)::numeric
                END AS lote_compras_bruto,
            a.arvore_decisao,
            a.nivel_servico,
            a.peso_compras,
            a.unidade_compra,
            public.gerar_lote_embalagem(
                CASE
                    WHEN (((a.coeficiente_variacao)::numeric > (0)::numeric) AND (a.compra_transito = (0)::numeric) AND (a.estoque <= a.ponto_pedido) AND ((a.revenda)::text = 'S'::text) AND ((a.status)::text <> 'FL'::text)) THEN round(((a.estoque_maximo + (a.consumo_medio_mensal * (a.tempo_ressuprimento + a.desvio_padrao_ressuprimento))) - a.estoque), 2)
                    WHEN (((a.coeficiente_variacao)::numeric = (0)::numeric) AND (a.compra_transito = (0)::numeric) AND (a.estoque <= a.ponto_pedido) AND ((a.revenda)::text = 'S'::text) AND ((a.status)::text <> 'FL'::text)) THEN ceil((a.consumo_medio_mensal / (2)::numeric))
                    ELSE (0)::numeric
                END, COALESCE(a.lote_minimo, (1)::numeric)) AS lote_embalagem,
            a.preco_compra,
            a.custo_unitario,
            a.valor_unitario,
            a.estoque_bloqueado,
            a.tempo_medio_apanhe,
            a.embalagem,
            a.idunidade_medida,
            a.ressuprimento_manual,
            a.ressuprimento_manual_dias,
            a.cod_produto,
            a.codigo_barras,
            a.fator_conversao,
            a.fator_atuacao,
            a.multiplo_compra,
            a.estoque_similar,
            a.projecao_rentabilidade,
            a.estoque_avaria,
            a.peso,
            a.altura,
            a.largura,
            a.comprimento,
            a.estoque_reservado,
            a.unidade_master
           FROM ( SELECT g.id_grupo,
                    p.idproduto,
                    p.descricao_produto,
                    p.idcomprador,
                    p.idfornecedor,
                    p.idfamilia_produto,
                    p.revenda,
                    (min((p.status)::text))::character varying(2) AS status,
                    p.unidade_compra,
                    sum((p.estoque * p.fator_conversao)) AS estoque,
                    avg(NULLIF(p.cobertura_estoque, (0)::numeric)) AS cobertura_estoque,
                    sum((p.estoque_seguranca * p.fator_conversao)) AS estoque_seguranca,
                    sum((p.ponto_pedido * p.fator_conversao)) AS ponto_pedido,
                    sum((p.estoque_maximo * p.fator_conversao)) AS estoque_maximo,
                    sum((p.consumo_medio_mensal * p.fator_conversao)) AS consumo_medio_mensal,
                    sum((p.desvio_padrao_consumo * p.fator_conversao)) AS desvio_padrao_consumo,
                    avg(p.tempo_medio_ressuprimento) AS tempo_medio_ressuprimento,
                    avg(p.tempo_ressuprimento) AS tempo_ressuprimento,
                    avg(p.desvio_padrao_ressuprimento) AS desvio_padrao_ressuprimento,
                    (COALESCE(((sum((p.desvio_padrao_consumo * p.fator_conversao)) / NULLIF(sum((p.consumo_medio_mensal * p.fator_conversao)), (0)::numeric)) * (100)::numeric), (0)::numeric))::text AS coeficiente_variacao,
                    public.getcompra_transito_grupo((g.id_grupo)::numeric, p.idproduto) AS compra_transito,
                    max((p.lote_minimo * p.fator_conversao)) AS lote_minimo,
                    (public.get_arvore_decisao_grupo((g.id_grupo)::numeric, p.idproduto))::text AS arvore_decisao,
                    public.getnivelservico(public.get_arvore_decisao_grupo((g.id_grupo)::numeric, p.idproduto)) AS nivel_servico,
                    public.getpesocompras(public.get_arvore_decisao_grupo((g.id_grupo)::numeric, p.idproduto), ("substring"((public.get_arvore_decisao_grupo((g.id_grupo)::numeric, p.idproduto))::text, 3, 1))::numeric) AS peso_compras,
                    COALESCE(avg(NULLIF(p.preco_compra, (0)::numeric)), (0)::numeric) AS preco_compra,
                    COALESCE(avg(NULLIF(p.custo_unitario, (0)::numeric)), (0)::numeric) AS custo_unitario,
                    COALESCE(avg(NULLIF(p.valor_unitario, (0)::numeric)), (0)::numeric) AS valor_unitario,
                    sum((p.estoque_bloqueado * p.fator_conversao)) AS estoque_bloqueado,
                    sum(p.tempo_medio_apanhe) AS tempo_medio_apanhe,
                    p.embalagem,
                    p.idunidade_medida,
                    (max((p.ressuprimento_manual)::text))::character varying(1) AS ressuprimento_manual,
                    COALESCE(max(p.ressuprimento_manual_dias), (0)::numeric) AS ressuprimento_manual_dias,
                    p.cod_produto,
                    p.codigo_barras,
                    avg(p.fator_conversao) AS fator_conversao,
                    avg(p.fator_atuacao) AS fator_atuacao,
                    max(p.multiplo_compra) AS multiplo_compra,
                    sum((p.estoque_similar * p.fator_conversao)) AS estoque_similar,
                    sum(p.projecao_rentabilidade) AS projecao_rentabilidade,
                    sum(p.estoque_avaria) AS estoque_avaria,
                    max(p.peso) AS peso,
                    max(p.altura) AS altura,
                    max(p.largura) AS largura,
                    max(p.comprimento) AS comprimento,
                    sum(COALESCE(p.estoque_reservado, (0)::numeric)) AS estoque_reservado,
                    (max((p.unidade_master)::text))::character varying(20) AS unidade_master
                   FROM (public.produtos_filial p
                     JOIN public.grupo_filial g ON ((p.filial = g.filial)))
                  WHERE (p.classificacao_financeira IS NOT NULL)
                  GROUP BY g.id_grupo, p.idproduto, p.descricao_produto, p.idcomprador, p.idfornecedor, p.idfamilia_produto, p.revenda, p.unidade_compra, p.embalagem, p.idunidade_medida, p.cod_produto, p.codigo_barras
                  ORDER BY p.idproduto, g.id_grupo) a) lote
  WHERE ((revenda)::text = 'S'::text);


--
-- PostgreSQL database dump complete
--

\unrestrict NKFBhVndEz3lykLSYa2wzyXklmU1qIWPE4xaamjsn6A8ydHkyo5oSpl6ePvLR9t

