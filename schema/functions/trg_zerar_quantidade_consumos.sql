CREATE OR REPLACE FUNCTION public.trg_zerar_quantidade_consumos()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
            BEGIN
              IF EXISTS (
                SELECT 1
                FROM consumos_desconsiderados d
                WHERE d.filial = NEW.filial
                  AND d.idconsumo = NEW.idconsumo
                  AND d.emissao = NEW.emissao
                  AND d.idproduto = NEW.idproduto
                  AND d.item = NEW.item
                  AND d.status = NEW.status
                  AND d.horariomov = NEW.horariomov
              ) THEN
                NEW.qtde := 0;
              END IF;

              RETURN NEW;
            END;
            $function$

