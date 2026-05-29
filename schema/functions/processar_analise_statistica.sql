CREATE OR REPLACE FUNCTION public.processar_analise_statistica()
 RETURNS void
 LANGUAGE plpgsql
 PARALLEL SAFE
AS $function$
    declare
        rec_prod record;
        qt_1 numeric;
        qt_3 numeric;
        vl_iqr numeric;
        lim_inf numeric;
        lim_sup numeric;
    begin

    --Amostra 180 dias

    alter table public.produtos_filial DISABLE TRIGGER all;

    for rec_prod in (select filial,idproduto from produtos_filial pf  order by filial,idproduto)
      loop


       select q1,q3,iqr,coalesce(nullif(floor((q1-(1.5*iqr))),0),media) linf , coalesce(nullif(ceil((q3+(1.5*iqr))),0),media) lisup
        into qt_1,qt_3,vl_iqr,lim_inf,lim_sup
       from (
       select
       avg(saidas) media,
       percentile_cont(0.25) within group (order by u.saidas) q1,
       percentile_cont(0.5) within group (order by u.saidas) q2,
       percentile_cont(0.75) within group (order by u.saidas) q3,
       percentile_cont(0.75) within group (order by u.saidas) - percentile_cont(0.25) within group (order by u.saidas) iqr
        from(


                  with tempo as (
                     select distinct to_char(day :: date, 'YYYYMM') as referencia
                     FROM generate_series(current_date - 180 , current_date, '1 day') day
                     order by to_char(day :: date, 'YYYYMM'))

                    SELECT
                         t.referencia AS mes,
                        coalesce(sum(c.qtde),0) AS saidas
                    from tempo t
                    left join consumos c
                         on c.filial =  rec_prod.filial
                        and c.idproduto = rec_prod.idproduto
                        and to_char(c.emissao , 'YYYYMM') = t.referencia

                    GROUP BY
                        t.referencia

            )u)a;


         if lim_inf < 0 then lim_inf=0; end if;
         if lim_sup < 0 then lim_sup=0; end if;




          UPDATE analise_statistica_produtos
            SET q1=qt_1, q3=qt_3, iqr=vl_iqr, limite_inferior=coalesce(lim_inf,0), limite_superior=lim_sup
            WHERE filial=rec_prod.filial AND idproduto=rec_prod.idproduto;


          if not found then

             INSERT INTO analise_statistica_produtos
                    (filial, idproduto, q1, q3, iqr, limite_inferior, limite_superior)
                    VALUES(rec_prod.filial,rec_prod.idproduto, qt_1,qt_3,vl_iqr,lim_inf,lim_sup);

          end if;

         update produtos_filial set limite_inferior=coalesce(lim_inf,0),limite_superior=coalesce(lim_sup,0) WHERE filial=rec_prod.filial AND idproduto=rec_prod.idproduto;


      end loop;

     alter table public.produtos_filial ENABLE TRIGGER all;

    end
    $function$

