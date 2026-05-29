CREATE OR REPLACE FUNCTION public.verificar_cobertura_personalizada_produto_filial(p_filial integer, p_idproduto character varying)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
DECLARE
    cadastro_produto record;
BEGIN
    SELECT 
        NULLIF(max(pf.cobertura_manual_produto), 0) AS cobertura_manual_produto,
        max(pf.idfornecedor) AS idfornecedor, 
        max(pf.idfamilia_produto) AS idfamilia_produto,
        (sum(estoque_maximo)::NUMERIC / NULLIF(sum(consumo_medio_mensal)::NUMERIC, 0)) * 30 AS cobertura_emax
        INTO cadastro_produto
    FROM produtos_filial pf 
    WHERE pf.filial = p_filial AND pf.idproduto = p_idproduto;

    IF (cadastro_produto.cobertura_manual_produto IS NULL) THEN
        RETURN FALSE;
    END IF;

    /* 
     * ESSE CASO PODE ACONTECER POR DOIS MOTIVOS: 
     * - PP >= EMAX
     * - PERFIL_DEMANDA = 'OCASIONAL'
    */
    IF (round(cadastro_produto.cobertura_emax) <> round(cadastro_produto.cobertura_manual_produto)) THEN
        RETURN TRUE;
    END IF;
    

    RETURN EXISTS (
        SELECT tempo_cobertura FROM tempo_cobertura_compras_produtos tp WHERE tp.idproduto = p_idproduto
        UNION 
        SELECT tempo_cobertura FROM tempo_cobertura_compras_fornecedor tf WHERE tf.idfornecedor = cadastro_produto.idfornecedor
        UNION
        SELECT tempo_cobertura FROM tempo_cobertura_compras_segmentos ts WHERE ts.idfamilia_produto = cadastro_produto.idfamilia_produto
    );
END
$function$

