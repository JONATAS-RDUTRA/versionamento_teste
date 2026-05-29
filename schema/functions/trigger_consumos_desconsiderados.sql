CREATE OR REPLACE FUNCTION public.trigger_consumos_desconsiderados()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    declare
    begin 

        if exists(
            select 1
            from consumos_desconsiderados cd 
            where (cd.filial, cd.idconsumo, cd.emissao, cd.idproduto, cd.item, cd.status, cd.horariomov) = (new.filial, new.idconsumo, new.emissao, new.idproduto, new.item, new.status, new.horariomov)
        )
        then 
            new.qtde = 0;
        end if;
    RETURN NEW;
    end
    $function$

