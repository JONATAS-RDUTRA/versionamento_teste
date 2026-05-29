CREATE OR REPLACE FUNCTION public.processar_tempo_cobertura_compras()
 RETURNS void
 LANGUAGE plpgsql
AS $function$
            DECLARE
                filial_red record;
            BEGIN
                FOR filial_red IN (
                    SELECT
                        gf.id_grupo,
                        gf.filial,
                        t.pqr,
                        t.xyz,
                        t.id_user,
                        t.tempo_cobertura,
                        t.tempo_cobertura_esseg
                    FROM tempo_cobertura_compras_geral t
                    INNER JOIN grupo_filial gf ON TRUE
                    WHERE t.deleted_at IS NULL
                )
                LOOP
                    UPDATE
                        public.tempo_cobertura_compras
                    SET
                        tempo_cobertura = filial_red.tempo_cobertura,
                        tempo_cobertura_esseg = filial_red.tempo_cobertura_esseg,
                        updated_at = current_timestamp
                    WHERE
                        id_grupo = filial_red.id_grupo
                        AND filial = filial_red.filial
                        AND pqr = filial_red.pqr
                        AND xyz = filial_red.xyz
                        AND deleted_at IS NULL;

                    IF (NOT FOUND) THEN
                        INSERT INTO tempo_cobertura_compras (
                            id_grupo, filial, id_user, pqr, xyz,
                            tempo_cobertura, tempo_cobertura_esseg,
                            created_at, updated_at, aplicado)
                        VALUES (
                            filial_red.id_grupo,
                            filial_red.filial,
                            filial_red.id_user,
                            filial_red.pqr,
                            filial_red.xyz,
                            filial_red.tempo_cobertura,
                            filial_red.tempo_cobertura_esseg,
                            current_timestamp,
                            current_timestamp,
                            current_timestamp
                        );
                    END IF;
                END LOOP;
            END;
            $function$

