--
-- PostgreSQL database dump
--

\restrict jNsicteHnA4yifidzhAqUcte4Ig4tL2MfQhIcw6aMnUvYqys10SvrwftSMwR97q

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

SET default_table_access_method = heap;

--
-- Name: sys_analise_diagnostico_drp_estoque_filial; Type: MATERIALIZED VIEW; Schema: public; Owner: -
--

CREATE MATERIALIZED VIEW public.sys_analise_diagnostico_drp_estoque_filial AS
 WITH vendas_ultimo_trimestre AS (
         SELECT c.filial,
            c.idproduto,
            sum(c.qtde) AS qtdn_vendido,
            sum((c.qtde * (c.valor_unit)::double precision)) AS valor_vendido
           FROM public.consumos c
          WHERE ((c.emissao >= (CURRENT_DATE - 90)) AND (c.emissao <= CURRENT_DATE))
          GROUP BY c.filial, c.idproduto
        ), produtos_em_separacao AS (
         SELECT v_1.filial_destino,
            v_1.idproduto,
            sum(v_1.qtde_item) AS qtdn_separacao
           FROM public.produtos_separacao v_1
          GROUP BY v_1.filial_destino, v_1.idproduto
        ), v1 AS (
         SELECT v_1.data,
            gf.id_grupo AS idgrupo,
            v_1.filial,
            COALESCE(concat('Filial ', v_1.filial, ' - ', f.nome_fantasia), (v_1.filial)::text) AS descricao_filial,
            v_1.idproduto,
            v_1.descricao_produto,
            v_1.idcomprador,
            COALESCE(v_1.descricao_comprador, 'N/A'::character varying) AS descricao_comprador,
            v_1.idsegmento,
            v_1.descricao_segmento,
            v_1.idfornecedor,
            v_1.descricao_fornecedor,
            v_1.consumo_medio_mensal,
            v_1.cmm_em_preco_venda,
            v_1.demanda_real,
            trunc(COALESCE(drp.emax_drp, (0)::numeric), 4) AS emax,
            COALESCE((drp.emax_drp * v_1.preco_custo), (0)::numeric) AS emax_em_preco_custo,
            COALESCE((v_1.emax * v_1.preco_custo), (0)::numeric) AS emax_em_preco_custo_compras,
            COALESCE(drp.esseg_drp, (0)::numeric) AS esseg,
            COALESCE(drp.estoque_min, (0)::numeric) AS estoque_minimo,
            COALESCE(drp.tp_drp, (0)::numeric) AS pp,
            v_1.fora_de_linha,
            v_1.ativo_para_venda,
            GREATEST(trunc(((p.estoque + p.estoque_transito_drp) - (p.estoque_similar + p.estoque_bloqueado)), 4), (0)::numeric) AS estoque,
            COALESCE(trunc(((((p.estoque + p.estoque_transito_drp) - (((p.estoque_reservado + p.estoque_bloqueado) + p.estoque_avaria) + p.estoque_similar)) / NULLIF(v_1.consumo_medio_mensal, (0)::numeric)) * (30)::numeric), 0), (0)::numeric) AS cobertura_estoque,
            COALESCE(((COALESCE(drp.emax_drp, (0)::numeric) / NULLIF(v_1.consumo_medio_mensal, (0)::numeric)) * (30)::numeric), (0)::numeric) AS cobertura_emax,
            COALESCE(((COALESCE(v_1.emax, (0)::numeric) / NULLIF(v_1.consumo_medio_mensal, (0)::numeric)) * (30)::numeric), (0)::numeric) AS cobertura_emax_compras,
            v_1.preco_custo,
            v_1.preco_venda,
            v_1.cmm_em_preco_custo,
            COALESCE((((p.estoque + p.estoque_transito_drp) - (((p.estoque_reservado + p.estoque_bloqueado) + p.estoque_avaria) + p.estoque_similar)) * v_1.preco_custo), (0)::numeric) AS estoque_em_preco_custo,
            COALESCE((((p.estoque + p.estoque_transito_drp) - (((p.estoque_reservado + p.estoque_bloqueado) + p.estoque_avaria) + p.estoque_similar)) * v_1.preco_venda), (0)::numeric) AS estoque_em_preco_venda,
            v_1.idade,
            v_1.histograma,
            v_1.data_ult_saida,
            v_1.frequencia_saida,
            v_1.faturamento,
            COALESCE(v_1.classificacao_rentabilidade, 'N'::bpchar) AS classificacao_rentabilidade,
            v_1.tempo_medio_apanhe,
            (EXISTS ( SELECT c1.filial,
                    c1.idproduto,
                    c1.cobertura_estoque,
                    c1.estoque_min,
                    c1.estoque_max,
                    c1.created_at,
                    c1.updated_at,
                    c1.multiplo_dist,
                    c1.primeira_entrada
                   FROM public.cfg_produto_distribuicao c1
                  WHERE ((c1.filial = v_1.filial) AND ((c1.idproduto)::text = (v_1.idproduto)::text)))) AS pertence_ao_mix,
            v_1.data_primeira_entrada,
            v_1.data_ultima_entrada,
                CASE
                    WHEN ((CURRENT_DATE - v_1.data_primeira_entrada) < 90) THEN '1. Menor que 90 dias'::text
                    WHEN ((CURRENT_DATE - v_1.data_primeira_entrada) <= 180) THEN '2. Entre 90 dias a 180 dias'::text
                    WHEN ((CURRENT_DATE - v_1.data_primeira_entrada) > 180) THEN '3. Acima de 180 dias'::text
                    ELSE '4. Sem entradas'::text
                END AS classificacao_primeira_entrada,
                CASE
                    WHEN ((CURRENT_DATE - v_1.data_ultima_entrada) < 90) THEN '1. Menor que 90 dias'::text
                    WHEN ((CURRENT_DATE - v_1.data_ultima_entrada) <= 180) THEN '2. Entre 90 dias a 180 dias'::text
                    WHEN ((CURRENT_DATE - v_1.data_ultima_entrada) > 180) THEN '3. Acima de 180 dias'::text
                    ELSE '4. Sem entradas'::text
                END AS classificacao_ultima_entrada,
                CASE
                    WHEN (((v_1.data - v_1.data_ultima_entrada) <= 90) AND (COALESCE(( SELECT sum(COALESCE(sf.estoque, (0)::numeric)) AS sum
                       FROM public.saldo_filiais sf
                      WHERE ((sf.filial = v_1.filial) AND ((sf.idproduto)::text = (v_1.idproduto)::text) AND (sf.data < v_1.data_ultima_entrada) AND (sf.data >= (v_1.data_ultima_entrada - 30)))), (0)::numeric) = (0)::numeric)) THEN 'SIM'::text
                    ELSE 'NAO'::text
                END AS produto_resgatado,
            v_1.esseg AS esseg_compras,
            v_1.pp AS pp_compras,
            v_1.emax AS emax_compras,
                CASE
                    WHEN ((p.aplicacao_produto)::text = 'S'::text) THEN 'Showroom'::text
                    WHEN ((p.aplicacao_produto)::text = 'E'::text) THEN 'Eletromoveis'::text
                    WHEN ((p.aplicacao_produto)::text = 'A'::text) THEN 'Autosserviço'::text
                    ELSE 'Não cadastrado'::text
                END AS tipo_produto,
            COALESCE(trunc((drp.tempo_ressuprimento_drp)::numeric, 0), (0)::numeric) AS tempo_ressuprimento_drp,
            v_1.status_produto,
            COALESCE(drp.sugestao_drp, (0)::numeric) AS sugestao_movimentacao
           FROM ((((public.analise_diagnostico_estoque_filial v_1
             JOIN public.produtos_filial p ON (((p.filial = v_1.filial) AND ((p.idproduto)::text = (v_1.idproduto)::text))))
             JOIN public.grupo_filial gf ON ((gf.filial = v_1.filial)))
             LEFT JOIN public.filial f ON ((f.idfilial = v_1.filial)))
             LEFT JOIN public.vw_analise_drp_parametrizada drp ON (((drp.filial = v_1.filial) AND ((drp.idproduto)::text = (v_1.idproduto)::text))))
        ), v2 AS (
         SELECT v_1.data,
            v_1.idgrupo,
            v_1.filial,
            v_1.descricao_filial,
            v_1.idproduto,
            v_1.descricao_produto,
            v_1.idcomprador,
            v_1.descricao_comprador,
            v_1.idsegmento,
            v_1.descricao_segmento,
            v_1.idfornecedor,
            v_1.descricao_fornecedor,
            v_1.consumo_medio_mensal,
            v_1.cmm_em_preco_venda,
            v_1.demanda_real,
            v_1.emax,
            v_1.emax_em_preco_custo,
            v_1.emax_em_preco_custo_compras,
            v_1.esseg,
            v_1.estoque_minimo,
            v_1.pp,
            v_1.fora_de_linha,
            v_1.ativo_para_venda,
            v_1.estoque,
            v_1.cobertura_estoque,
            v_1.cobertura_emax,
            v_1.cobertura_emax_compras,
            v_1.preco_custo,
            v_1.preco_venda,
            v_1.cmm_em_preco_custo,
            v_1.estoque_em_preco_custo,
            v_1.estoque_em_preco_venda,
            v_1.idade,
            v_1.histograma,
            v_1.data_ult_saida,
            v_1.frequencia_saida,
            v_1.faturamento,
            v_1.classificacao_rentabilidade,
            v_1.tempo_medio_apanhe,
            v_1.pertence_ao_mix,
            v_1.data_primeira_entrada,
            v_1.data_ultima_entrada,
            v_1.classificacao_primeira_entrada,
            v_1.classificacao_ultima_entrada,
            v_1.produto_resgatado,
            v_1.esseg_compras,
            v_1.pp_compras,
            v_1.emax_compras,
            v_1.tipo_produto,
            v_1.tempo_ressuprimento_drp,
            v_1.status_produto,
            v_1.sugestao_movimentacao,
            trunc(((v_1.consumo_medio_mensal * v_1.tempo_ressuprimento_drp) / 30.0), 0) AS consumo_transito,
                CASE
                    WHEN ((v_1.pertence_ao_mix IS TRUE) AND (v_1.estoque > v_1.emax) AND (v_1.estoque_minimo = (0)::numeric)) THEN '1. Excesso & Sem Estético'::text
                    WHEN ((v_1.pertence_ao_mix IS TRUE) AND (v_1.estoque > v_1.emax) AND (v_1.estoque > v_1.estoque_minimo)) THEN '2. Excesso & Saldo > Estético'::text
                    WHEN ((v_1.pertence_ao_mix IS TRUE) AND (v_1.consumo_medio_mensal > (0)::numeric) AND (v_1.estoque > v_1.emax) AND (v_1.estoque = v_1.estoque_minimo)) THEN '3. Excesso & Saldo = Estético'::text
                    WHEN ((v_1.pertence_ao_mix IS TRUE) AND (v_1.consumo_medio_mensal = (0)::numeric) AND (v_1.estoque > v_1.pp) AND (v_1.estoque = v_1.estoque_minimo)) THEN '3. Excesso & Saldo = Estético'::text
                    WHEN ((v_1.pertence_ao_mix IS TRUE) AND (v_1.consumo_medio_mensal > (0)::numeric) AND (v_1.estoque > v_1.emax) AND (v_1.estoque < v_1.estoque_minimo)) THEN '4. Excesso & Saldo < Estético'::text
                    WHEN ((v_1.pertence_ao_mix IS TRUE) AND (v_1.consumo_medio_mensal = (0)::numeric) AND (v_1.estoque > v_1.pp) AND (v_1.estoque < v_1.estoque_minimo)) THEN '4. Excesso & Saldo < Estético'::text
                    WHEN ((v_1.pertence_ao_mix IS TRUE) AND (v_1.consumo_medio_mensal > (0)::numeric) AND (v_1.estoque > v_1.pp) AND (v_1.estoque <= v_1.emax) AND ((v_1.estoque - ((v_1.consumo_medio_mensal * v_1.tempo_ressuprimento_drp) / (30)::numeric)) > v_1.pp) AND (v_1.estoque > v_1.estoque_minimo)) THEN '5. Adequado & Saldo > Estético'::text
                    WHEN ((v_1.pertence_ao_mix IS TRUE) AND (v_1.consumo_medio_mensal > (0)::numeric) AND (v_1.estoque > v_1.pp) AND (v_1.estoque <= v_1.emax) AND ((v_1.estoque - ((v_1.consumo_medio_mensal * v_1.tempo_ressuprimento_drp) / (30)::numeric)) > v_1.pp) AND (v_1.estoque = v_1.estoque_minimo)) THEN '6. Adequado & Saldo = Estético'::text
                    WHEN ((v_1.pertence_ao_mix IS TRUE) AND (v_1.consumo_medio_mensal > (0)::numeric) AND (v_1.estoque > v_1.pp) AND (v_1.estoque <= v_1.emax) AND ((v_1.estoque - ((v_1.consumo_medio_mensal * v_1.tempo_ressuprimento_drp) / (30)::numeric)) > v_1.pp) AND (v_1.estoque < v_1.estoque_minimo)) THEN '7. Adequado & Saldo < Estético'::text
                    WHEN ((v_1.pertence_ao_mix IS TRUE) AND (v_1.consumo_medio_mensal > (0)::numeric) AND (v_1.estoque > v_1.pp) AND (v_1.estoque <= v_1.emax) AND ((v_1.estoque - ((v_1.consumo_medio_mensal * v_1.tempo_ressuprimento_drp) / (30)::numeric)) <= v_1.pp)) THEN '8. Em Ponto de pedido Futuro'::text
                    WHEN ((v_1.pertence_ao_mix IS TRUE) AND (v_1.consumo_medio_mensal = (0)::numeric) AND (v_1.estoque > (0)::numeric) AND (v_1.estoque <= v_1.pp) AND (v_1.cobertura_estoque = (0)::numeric)) THEN '9. Baixa Exposição a Ruptura'::text
                    WHEN ((v_1.pertence_ao_mix IS TRUE) AND (v_1.consumo_medio_mensal > (0)::numeric) AND (v_1.estoque > (0)::numeric) AND (v_1.estoque <= v_1.pp) AND (v_1.cobertura_estoque > v_1.tempo_ressuprimento_drp)) THEN '9. Baixa Exposição a Ruptura'::text
                    WHEN ((v_1.pertence_ao_mix IS TRUE) AND (v_1.consumo_medio_mensal > (0)::numeric) AND (v_1.estoque > (0)::numeric) AND (v_1.estoque <= v_1.pp) AND (v_1.cobertura_estoque <= v_1.tempo_ressuprimento_drp)) THEN '10. Elevada Exposição a Ruptura'::text
                    WHEN ((v_1.pertence_ao_mix IS TRUE) AND (v_1.consumo_medio_mensal > (0)::numeric) AND (v_1.estoque = (0)::numeric)) THEN '11. Ruptura'::text
                    WHEN ((v_1.pertence_ao_mix IS TRUE) AND (v_1.consumo_medio_mensal = (0)::numeric) AND (v_1.estoque = (0)::numeric) AND (v_1.estoque_minimo > (0)::numeric)) THEN '11. Ruptura'::text
                    WHEN ((v_1.pertence_ao_mix IS FALSE) AND (v_1.estoque > (0)::numeric)) THEN '12. Solicitar Reversa'::text
                    ELSE '13. Não Analisar'::text
                END AS status_balanceamento
           FROM v1 v_1
        ), v3 AS (
         SELECT v_1.data,
            v_1.idgrupo,
            v_1.filial,
            v_1.descricao_filial,
            v_1.idproduto,
            v_1.descricao_produto,
            v_1.idcomprador,
            v_1.descricao_comprador,
            v_1.idsegmento,
            v_1.descricao_segmento,
            v_1.idfornecedor,
            v_1.descricao_fornecedor,
            v_1.consumo_medio_mensal,
            v_1.cmm_em_preco_venda,
            v_1.demanda_real,
            v_1.emax,
            v_1.emax_em_preco_custo,
            v_1.emax_em_preco_custo_compras,
            v_1.esseg,
            v_1.estoque_minimo,
            v_1.pp,
            v_1.fora_de_linha,
            v_1.ativo_para_venda,
            v_1.estoque,
            v_1.cobertura_estoque,
            v_1.cobertura_emax,
            v_1.cobertura_emax_compras,
            v_1.preco_custo,
            v_1.preco_venda,
            v_1.cmm_em_preco_custo,
            v_1.estoque_em_preco_custo,
            v_1.estoque_em_preco_venda,
            v_1.idade,
            v_1.histograma,
            v_1.data_ult_saida,
            v_1.frequencia_saida,
            v_1.faturamento,
            v_1.classificacao_rentabilidade,
            v_1.tempo_medio_apanhe,
            v_1.pertence_ao_mix,
            v_1.data_primeira_entrada,
            v_1.data_ultima_entrada,
            v_1.classificacao_primeira_entrada,
            v_1.classificacao_ultima_entrada,
            v_1.produto_resgatado,
            v_1.esseg_compras,
            v_1.pp_compras,
            v_1.emax_compras,
            v_1.tipo_produto,
            v_1.tempo_ressuprimento_drp,
            v_1.status_produto,
            v_1.sugestao_movimentacao,
            v_1.consumo_transito,
            v_1.status_balanceamento,
                CASE
                    WHEN ((COALESCE(v_1.estoque, (0)::numeric) - COALESCE(v_1.consumo_transito, (0)::numeric)) < (0)::numeric) THEN (0)::numeric
                    ELSE (v_1.estoque - v_1.consumo_transito)
                END AS saldo_residual
           FROM v2 v_1
        )
 SELECT CURRENT_DATE AS data,
    v.idgrupo,
    v.filial,
    v.descricao_filial,
    v.idcomprador,
    v.descricao_comprador,
    v.idsegmento,
    v.descricao_segmento,
    v.idfornecedor,
    v.descricao_fornecedor,
    v.status_balanceamento,
    v.idproduto,
    v.descricao_produto,
        CASE
            WHEN v.pertence_ao_mix THEN 'SIM'::text
            ELSE 'NAO'::text
        END AS pertence_ao_mix,
    COALESCE(vut.qtdn_vendido, (0)::double precision) AS media_ultimo_trimestre,
    v.consumo_medio_mensal,
    v.estoque,
    v.demanda_real,
    v.esseg,
    v.esseg_compras,
    v.pp,
    v.pp_compras,
    v.emax,
    v.emax_compras,
    v.estoque_minimo,
    v.fora_de_linha,
    v.ativo_para_venda,
    v.tempo_ressuprimento_drp,
    v.status_produto,
    v.cobertura_estoque,
    COALESCE(((v.estoque_minimo / NULLIF(v.consumo_medio_mensal, (0)::numeric)) * (30)::numeric), (0)::numeric) AS cobertura_estoque_estetico,
    v.cobertura_emax,
    v.cobertura_emax_compras,
    v.preco_custo,
    v.preco_venda,
    v.cmm_em_preco_custo,
    v.estoque_em_preco_custo,
    COALESCE((v.demanda_real * v.preco_custo), (0)::numeric) AS demanda_possivel_em_preco_custo,
    COALESCE((v.estoque_minimo * v.preco_custo), (0)::numeric) AS estoque_estetico_em_preco_custo,
    v.emax_em_preco_custo,
    v.emax_em_preco_custo_compras,
    v.cmm_em_preco_venda,
    v.estoque_em_preco_venda,
    COALESCE((v.demanda_real * v.preco_venda), (0)::numeric) AS demanda_possivel_em_preco_venda,
    COALESCE(((v.consumo_medio_mensal - v.demanda_real) * v.preco_venda), (0)::numeric) AS diferenca_projecao_vendas_demanda_possivel_em_preco_venda,
    v.idade,
    v.data_primeira_entrada,
    v.data_ultima_entrada,
    v.classificacao_primeira_entrada,
    v.classificacao_ultima_entrada,
    v.histograma,
    v.data_ult_saida,
    v.produto_resgatado,
    v.frequencia_saida,
    v.faturamento,
    v.classificacao_rentabilidade,
    v.tempo_medio_apanhe,
    COALESCE(ps.qtdn_separacao, (0)::numeric) AS total_transferencia_filial,
    COALESCE((ps.qtdn_separacao * v.preco_custo), (0)::numeric) AS total_transferencia_filial_em_preco_custo,
    v.tipo_produto,
    v.consumo_transito,
    v.saldo_residual,
    v.sugestao_movimentacao,
    trunc((v.sugestao_movimentacao * v.preco_custo), 2) AS sugestao_movimentacao_em_preco_custo,
        CASE
            WHEN (COALESCE(v.sugestao_movimentacao, (0)::numeric) = (0)::numeric) THEN v.estoque
            ELSE trunc((v.sugestao_movimentacao + v.saldo_residual), 2)
        END AS saldo_futuro,
    trunc((
        CASE
            WHEN (COALESCE(v.sugestao_movimentacao, (0)::numeric) = (0)::numeric) THEN v.estoque
            ELSE trunc((v.sugestao_movimentacao + v.saldo_residual), 2)
        END * v.preco_custo), 2) AS saldo_futuro_em_preco_custo
   FROM ((v3 v
     LEFT JOIN vendas_ultimo_trimestre vut ON (((vut.filial = v.filial) AND ((vut.idproduto)::text = (v.idproduto)::text))))
     LEFT JOIN produtos_em_separacao ps ON (((ps.filial_destino = v.filial) AND ((ps.idproduto)::text = (v.idproduto)::text))))
  WITH NO DATA;


--
-- PostgreSQL database dump complete
--

\unrestrict jNsicteHnA4yifidzhAqUcte4Ig4tL2MfQhIcw6aMnUvYqys10SvrwftSMwR97q

