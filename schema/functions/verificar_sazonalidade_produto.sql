CREATE OR REPLACE FUNCTION public.verificar_sazonalidade_produto(param_idproduto character varying)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
            DECLARE
                results record;
                retorno boolean default false;
            begin
                for results in (
                    select distinct
                        q.ano,
                        q.recorrencia,
                        substring(unnest(string_to_array(q.datas_inicio, '#')) FROM 1 FOR 6) as init,
                        substring(unnest(string_to_array(q.datas_final, '#')) FROM 1 FOR 6) as finish
                    from (
                        select
                            s.ano,
                            s.recorrencia,
                            replace(replace(replace(replace(s.dia_mes_inicial, '["', ''), '"]', ''), '\', ''), '","', '#') as datas_inicio,
                            replace(replace(replace(replace(s.dia_mes_final, '["', ''), '"]', ''), '\', ''), '","', '#') as datas_final
                        from
                            sazonalidades_produtos s
                        where
                            s.idproduto = param_idproduto
                        ) as q
                    )
                    loop
                        if (
                            (
                                current_date >= date(concat(results.init, extract (year from current_date)))
                                and current_date <= date(concat(results.finish, extract (year from current_date)))
                                and results.recorrencia = '1'
                            ) OR (
                                current_date >= date(concat(results.init, extract (year from current_date)))
                                and current_date <= date(concat(results.finish, extract (year from current_date)))
                                and results.recorrencia = '0'
                                and results.ano = extract (year from current_date)::varchar
                            ) OR ( retorno )
                        ) then
                            retorno = true;
                        else
                            retorno = false;
                        end if;
                    end loop;

                return retorno;
            end;
    $function$

