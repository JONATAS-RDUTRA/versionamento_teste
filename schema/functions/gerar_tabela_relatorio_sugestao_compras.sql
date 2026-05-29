CREATE OR REPLACE FUNCTION public.gerar_tabela_relatorio_sugestao_compras(grupo_id text, fornecedor_id integer[] DEFAULT NULL::integer[], comprador_id integer[] DEFAULT NULL::integer[], segmento_id integer[] DEFAULT NULL::integer[])
 RETURNS TABLE(id_grupo text, idfornecedor text, razao_social text, idproduto text, descricao_produto text, unidade_compra text, lote_minimo text, estoque text, compra_transito text, media_tres_meses text, media_seis_meses text, media_doze_meses text, qtde_ultima_compra text, data_ultima_compra text, sugestao_compra text)
 LANGUAGE plpgsql
 PARALLEL SAFE
AS $function$
DECLARE
    table_temp text;
    filtro_fornecedor text;
    filtro_comprador text;
    filtro_segmento text;
BEGIN
    table_temp = 'g' || grupo_id || '_tmp_sugestao_compra';

    create temporary table if not exists table_temp as
        SELECT
            pcg.id_grupo::text,
            pcg.idfornecedor::text,
            f.razao_social::text,
            pcg.idproduto::text,
            pcg.descricao_produto::text,
            pcg.unidade_compra::text,
            pcg.lote_minimo::text,
            pcg.estoque::text,
            pcg.compra_transito::text,
            (COALESCE(sum(c.qtde) FILTER (WHERE c.emissao >= (current_date - 90)), 0) / 3)::text AS media_tres_meses,
            (COALESCE(sum(c.qtde) FILTER (WHERE c.emissao >= (current_date - 180)), 0) / 6)::text AS media_seis_meses,
            (COALESCE(sum(c.qtde) FILTER (WHERE c.emissao >= (current_date - 365)), 0) / 12)::text AS media_doze_meses,
            COALESCE(max(r.qtde), 0)::text AS qtde_ultima_compra,
            max(r.data_solicitacao)::text AS data_ultima_compra,
            COALESCE(vw.sugestao, 0)::text AS sugestao_compra
        FROM
            produtos_compras_grupo pcg
            JOIN fornecedor f ON f.id::text = pcg.idfornecedor::text
            LEFT JOIN vw_lista_compras_dinamica_grupo vw ON vw.id_grupo = pcg.id_grupo AND vw.idproduto = pcg.idproduto
            LEFT JOIN consumos c ON c.idproduto = pcg.idproduto
            LEFT JOIN requisicoes r ON r.idproduto = pcg.idproduto
        WHERE
            pcg.id_grupo::int = grupo_id::int
            AND c.emissao >= (current_date - 365)
            AND (pcg.idfornecedor::int = ANY(fornecedor_id) or fornecedor_id is null)
            AND (pcg.idfamilia_produto::int = ANY(segmento_id) or segmento_id is null)
            AND (pcg.idcomprador::int = ANY(comprador_id) or comprador_id is null)
        GROUP BY
            pcg.id_grupo,
            pcg.idfornecedor,
            f.razao_social,
            pcg.idproduto,
            vw.idproduto,
            pcg.descricao_produto,
            pcg.unidade_compra,
            pcg.lote_minimo,
            pcg.estoque,
            pcg.compra_transito,
            vw.sugestao
        ORDER BY
            vw.idproduto;

    RETURN query select * from table_temp;

    DROP TABLE IF EXISTS table_temp;

    RETURN;

END;
$function$

