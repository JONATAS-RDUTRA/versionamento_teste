--
-- PostgreSQL database dump
--

\restrict 8yO5coUi2IdH9eefgc7aOKLVLeLgmhIpuSu2eqQRDhinBZqVDDhpgKfr3AWfOe1

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
-- Name: vw_aderencia; Type: MATERIALIZED VIEW; Schema: public; Owner: -
--

CREATE MATERIALIZED VIEW public.vw_aderencia AS
 WITH compras_efetuadas_erp AS (
         SELECT r.data_solicitacao,
            ( SELECT max(c.emissao) AS max
                   FROM (public.consumos c
                     JOIN public.grupo_filial sgf ON ((sgf.filial = c.filial)))
                  WHERE ((c.emissao <= r.data_solicitacao) AND (sgf.id_grupo = gf.id_grupo) AND ((c.idproduto)::text = (r.idproduto)::text))
                 LIMIT 1) AS data_ultima_venda,
            gf.id_grupo AS idgrupo,
            r.idfilial,
            string_agg((r.id_solicitacao)::text, ','::text) AS ids_solicitacao,
            r.idproduto,
            sum(r.qtde) AS soma_qtde_erp,
            avg(r.pcompra) AS preco_carrinho_erp,
            r.entrada_bonificada,
            false AS produto_eh_combinacao
           FROM (public.requisicoes r
             JOIN public.grupo_filial gf ON ((gf.filial = r.idfilial)))
          WHERE (NOT ((r.idproduto)::text IN ( SELECT DISTINCT spci.idproduto
                   FROM (public.sys_produtos_combinados spc
                     JOIN public.sys_produtos_combinados_itens spci ON (((spci.id_produto_combinado)::text = (spc.id)::text)))
                  WHERE (spc.deleted_at IS NULL))))
          GROUP BY r.data_solicitacao, r.entrada_bonificada, gf.id_grupo, r.idfilial, r.idproduto
        UNION ALL
         SELECT r.data_solicitacao,
            ( SELECT max(c.emissao) AS max
                   FROM (public.consumos c
                     JOIN public.grupo_filial sgf ON ((sgf.filial = c.filial)))
                  WHERE ((c.emissao <= r.data_solicitacao) AND (sgf.id_grupo = gf.id_grupo) AND ((c.idproduto)::text IN ( SELECT spci_1.idproduto
                           FROM public.sys_produtos_combinados_itens spci_1
                          WHERE ((spci_1.id_produto_combinado)::text = (spc.id)::text))))
                 LIMIT 1) AS data_ultima_venda,
            gf.id_grupo AS idgrupo,
            r.idfilial,
            string_agg(DISTINCT (r.id_solicitacao)::text, ', '::text) AS ids_solicitacao,
            (spc.id)::text AS idproduto,
            sum(r.qtde) AS soma_qtde_erp,
            avg(r.pcompra) AS preco_carrinho_erp,
            r.entrada_bonificada,
            true AS produto_eh_combinacao
           FROM (((public.requisicoes r
             JOIN public.grupo_filial gf ON ((gf.filial = r.idfilial)))
             JOIN public.sys_produtos_combinados_itens spci ON (((spci.idproduto)::text = (r.idproduto)::text)))
             JOIN public.sys_produtos_combinados spc ON (((spc.id)::text = (spci.id_produto_combinado)::text)))
          WHERE (spc.deleted_at IS NULL)
          GROUP BY r.data_solicitacao, r.entrada_bonificada, gf.id_grupo, r.idfilial, spc.id
        ), pedidos_systock AS (
         SELECT pc.data_emissao,
            pc.grupo AS idgrupo,
            pci.idproduto,
            (pc.idpedido)::text AS ids_pedido,
            pci.sugerido AS soma_sugerido_systock,
            pci.qtde_pedido AS soma_qtde_systock,
            (pci.preco_custo)::text AS preco_carrinho_systock,
            false AS produto_eh_combinacao
           FROM (public.pedidos_compras_itens pci
             JOIN public.pedidos_compras pc ON ((pc.idpedido = pci.idpedido)))
          WHERE (NOT ((pci.idproduto)::text IN ( SELECT DISTINCT spci.idproduto
                   FROM (public.sys_produtos_combinados spc
                     JOIN public.sys_produtos_combinados_itens spci ON (((spci.id_produto_combinado)::text = (spc.id)::text)))
                  WHERE (spc.deleted_at IS NULL))))
        UNION ALL
         SELECT pc.data_emissao,
            pc.grupo AS idgrupo,
            spc.id AS idproduto,
            (pc.idpedido)::text AS ids_pedido,
            pci.sugerido AS soma_sugerido_systock,
            pci.qtde_pedido AS soma_qtde_systock,
            (pci.preco_custo)::text AS preco_carrinho_systock,
            true AS produto_eh_combinacao
           FROM (((public.pedidos_compras_itens pci
             JOIN public.pedidos_compras pc ON ((pc.idpedido = pci.idpedido)))
             JOIN public.sys_produtos_combinados_itens spci ON (((spci.idproduto)::text = (pci.idproduto)::text)))
             JOIN public.sys_produtos_combinados spc ON ((((spc.id)::text = (spci.id_produto_combinado)::text) AND (spc.deleted_at IS NULL))))
        ), produtos_por_data_compra AS (
         SELECT sf.data,
            gf.id_grupo AS idgrupo,
            sf.idproduto,
            sum(sf.estoque) AS estoque,
            sum(sf.emax) AS emax,
            sum(sf.ppd) AS pp,
            sum(sf.esseg) AS esseg,
            avg(sf.tempo_ressuprimento) AS tr_em_mes,
            sum(sf.cmm) AS cmm,
            false AS produto_eh_combinacao
           FROM (public.saldo_filiais sf
             JOIN public.grupo_filial gf ON ((gf.filial = sf.filial)))
          WHERE (sf.data IN ( SELECT cee_1.data_solicitacao
                   FROM compras_efetuadas_erp cee_1
                  WHERE (cee_1.produto_eh_combinacao IS FALSE)))
          GROUP BY sf.data, gf.id_grupo, sf.idproduto
        UNION ALL
         SELECT sf.data,
            gf.id_grupo AS idgrupo,
            spc.id AS idproduto,
            sum(sf.estoque) AS estoque,
            sum(sf.emax) AS emax,
            sum(sf.ppd) AS pp,
            sum(sf.esseg) AS esseg,
            avg(sf.tempo_ressuprimento) AS tr_em_mes,
            sum(sf.cmm) AS cmm,
            true AS produto_eh_combinacao
           FROM (((public.saldo_filiais sf
             JOIN public.grupo_filial gf ON ((gf.filial = sf.filial)))
             JOIN public.sys_produtos_combinados_itens spci ON (((spci.idproduto)::text = (sf.idproduto)::text)))
             JOIN public.sys_produtos_combinados spc ON ((((spc.id)::text = (spci.id_produto_combinado)::text) AND (spc.deleted_at IS NULL))))
          WHERE (sf.data IN ( SELECT cee_1.data_solicitacao
                   FROM compras_efetuadas_erp cee_1
                  WHERE (cee_1.produto_eh_combinacao IS TRUE)))
          GROUP BY sf.data, gf.id_grupo, spc.id
        )
 SELECT v1.idgrupo,
    v1.descricao_grupo,
    COALESCE(cee.idfilial, 0) AS filial,
    COALESCE(
        CASE
            WHEN (cee.idfilial = 0) THEN 'Todas'::character varying
            ELSE ( SELECT f2.nome_fantasia
               FROM public.filial f2
              WHERE (f2.idfilial = cee.idfilial))
        END, 'Todas'::character varying) AS descricao_filial,
    v1.idsegmento,
    v1.descricao_segmento,
        CASE
            WHEN cee.produto_eh_combinacao THEN (0)::bigint
            ELSE v1.idfornecedor
        END AS idfornecedor,
        CASE
            WHEN cee.produto_eh_combinacao THEN ''::text
            ELSE v1.descricao_fornecedor
        END AS descricao_fornecedor,
    v1.idcomprador,
    v1.descricao_comprador,
    cee.idproduto,
    v1.descricao_produto,
        CASE
            WHEN (ppdc.estoque = (0)::numeric) THEN '5. Em Ruptura'::text
            WHEN (ppdc.estoque > ppdc.emax) THEN '1. Excesso'::text
            WHEN ((ppdc.estoque <= ppdc.emax) AND (ppdc.estoque > ppdc.pp)) THEN '2. Adequado'::text
            WHEN ((ppdc.estoque <= ppdc.pp) AND (GREATEST(ceil((ppdc.estoque / NULLIF(ppdc.cmm, (0)::numeric))), (0)::numeric) >= ppdc.tr_em_mes)) THEN '3. Baixa Exposição a Ruptura'::text
            WHEN ((ppdc.estoque <= ppdc.pp) AND (GREATEST(ceil((ppdc.estoque / NULLIF(ppdc.cmm, (0)::numeric))), (0)::numeric) < ppdc.tr_em_mes)) THEN '4. Elevada Exposição a Ruptura'::text
            ELSE NULL::text
        END AS status_produto,
        CASE
            WHEN ((cee.data_solicitacao - cee.data_ultima_venda) IS NULL) THEN '0. Sem histórico de vendas'::text
            WHEN ((cee.data_solicitacao - cee.data_ultima_venda) <= 30) THEN '1. Até 1 mês sem vender'::text
            WHEN ((cee.data_solicitacao - cee.data_ultima_venda) <= 60) THEN '2. De 1 a 2 meses sem vender'::text
            WHEN ((cee.data_solicitacao - cee.data_ultima_venda) <= 90) THEN '3. De 2 a 3 meses sem vender'::text
            WHEN ((cee.data_solicitacao - cee.data_ultima_venda) <= 180) THEN '4. De 3 a 6 meses sem vender'::text
            WHEN ((cee.data_solicitacao - cee.data_ultima_venda) <= 270) THEN '5. De 6 a 9 meses sem vender'::text
            WHEN ((cee.data_solicitacao - cee.data_ultima_venda) <= 360) THEN '6. De 9 a 12 meses sem vender'::text
            ELSE '7. Acima de 12 meses sem vender'::text
        END AS histograma,
    ppdc.estoque,
    ppdc.cmm,
    ps.ids_pedido AS codigo_pedido_compras_erp,
    cee.ids_solicitacao,
    ps.data_emissao,
    cee.data_solicitacao,
    COALESCE((ps.soma_sugerido_systock)::numeric, (0)::numeric) AS sugestao_compras_systock,
    COALESCE((ps.soma_qtde_systock)::numeric, (0)::numeric) AS carrinho_compras_systock,
    cee.soma_qtde_erp AS compras_erp,
    COALESCE((ps.preco_carrinho_systock)::numeric, (0)::numeric) AS preco_carrinho_compras_systock,
    (COALESCE((cee.preco_carrinho_erp)::numeric, (0)::numeric))::text AS preco_compra_erp,
    (COALESCE(( SELECT avg(r.pcompra) AS avg
           FROM (public.requisicoes r
             JOIN public.grupo_filial gf ON ((gf.filial = r.idfilial)))
          WHERE ((r.data_solicitacao < cee.data_ultima_venda) AND ((r.idproduto)::text = (cee.idproduto)::text) AND (gf.id_grupo = cee.idgrupo))
          GROUP BY r.data_solicitacao, gf.id_grupo, r.idproduto
          ORDER BY r.data_solicitacao DESC
         LIMIT 1), (0)::double precision))::text AS penultimo_preco_compras_erp,
    1 AS meta,
    to_char((cee.data_solicitacao)::timestamp with time zone, 'YYYY'::text) AS ano,
    to_char((cee.data_solicitacao)::timestamp with time zone, 'MM'::text) AS mes,
    cee.produto_eh_combinacao,
    cee.entrada_bonificada,
    row_number() OVER (PARTITION BY cee.ids_solicitacao, cee.idproduto ORDER BY cee.ids_solicitacao, ps.ids_pedido) AS rn
   FROM (((compras_efetuadas_erp cee
     JOIN public.analise_diagnostico_estoque_grupo v1 ON (((v1.idgrupo = cee.idgrupo) AND ((v1.idproduto)::text = (cee.idproduto)::text) AND (v1.produto_combinado = cee.produto_eh_combinacao))))
     JOIN produtos_por_data_compra ppdc ON (((ppdc.idgrupo = cee.idgrupo) AND (ppdc.data = cee.data_solicitacao) AND ((ppdc.idproduto)::text = (cee.idproduto)::text) AND (ppdc.produto_eh_combinacao = cee.produto_eh_combinacao))))
     LEFT JOIN pedidos_systock ps ON ((((ps.idproduto)::text = (cee.idproduto)::text) AND (ps.idgrupo = cee.idgrupo) AND ((ps.data_emissao, ps.idgrupo, (ps.idproduto)::text) = ( SELECT ps_sub.data_emissao,
            ps_sub.idgrupo,
            ps_sub.idproduto
           FROM pedidos_systock ps_sub
          WHERE ((ps_sub.data_emissao <= cee.data_solicitacao) AND (ps_sub.data_emissao >= (cee.data_solicitacao - 7)) AND (ps_sub.idgrupo = cee.idgrupo) AND ((ps_sub.idproduto)::text = (cee.idproduto)::text))
          ORDER BY ps_sub.data_emissao DESC
         LIMIT 1)))))
  WITH NO DATA;


--
-- PostgreSQL database dump complete
--

\unrestrict 8yO5coUi2IdH9eefgc7aOKLVLeLgmhIpuSu2eqQRDhinBZqVDDhpgKfr3AWfOe1

