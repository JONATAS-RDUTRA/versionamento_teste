CREATE OR REPLACE FUNCTION public.get_tmr_filial(p_filial numeric, idprod character varying)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$
    declare
        tmr numeric;
        ressup_manual varchar;
        ressup_dia numeric;
    begin

        select
            ressuprimento_manual,
            ressuprimento_manual_dias
            into
            ressup_manual,
            ressup_dia
        from produtos_filial pf
        where filial = p_filial and idproduto = idprod;

        if ressup_manual='S' then return ressup_dia;
        else
            select (round(cast(get_temp_ressup_filial(p_filial, idProd) as numeric) + cast(get_stddev_ressup_filial(p_filial, idProd) as numeric), 2) * 30) into tmr;
            return tmr;
        end if;
    end;
    $function$

