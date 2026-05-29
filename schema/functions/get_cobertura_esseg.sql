CREATE OR REPLACE FUNCTION public.get_cobertura_esseg(p_filial integer, p_produto character varying)
 RETURNS double precision
 LANGUAGE plpgsql
AS $function$
    DECLARE
        cobertura int;
        tipo record;
    BEGIN
        SELECT
            pf.classificacao_criticidade AS xyz,
            pf.classificacao_popularidade AS pqr,
            pf.idfamilia_produto,
            pf.idfornecedor,
            pf.idproduto,
            pf.status_tempo_esseg AS status
        INTO tipo
        FROM produtos_filial pf
        WHERE
            pf.filial = p_filial
            AND pf.idproduto = p_produto;

        IF tipo.status = 1 THEN

            SELECT tempo_cobertura_esseg
            INTO cobertura
            FROM tempo_cobertura_compras_geral tccg
            WHERE
                pqr = tipo.pqr
                AND xyz = tipo.xyz
            GROUP BY tempo_cobertura_esseg ;

        ELSEIF tipo.status = 2 THEN

            SELECT tempo_cobertura_esseg
            INTO cobertura
            FROM tempo_cobertura_compras_segmentos tccs
            WHERE idfamilia_produto = tipo.idfamilia_produto
            GROUP BY tempo_cobertura_esseg ;

        ELSEIF tipo.status = 3 THEN

            SELECT tempo_cobertura_esseg
            INTO cobertura
            FROM tempo_cobertura_compras_fornecedor tccf
            WHERE idfornecedor = tipo.idfornecedor
            GROUP BY tempo_cobertura_esseg ;

        ELSEIF tipo.status = 4 THEN

            SELECT tempo_cobertura_esseg
            INTO cobertura
            FROM tempo_cobertura_compras_produtos tccp
            WHERE idproduto::TEXT = tipo.idproduto::TEXT
            GROUP BY tempo_cobertura_esseg ;

        ELSE

            cobertura = 0;

        END IF;

        RETURN COALESCE (cobertura, 0);

    END;

    $function$

