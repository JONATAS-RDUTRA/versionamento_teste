CREATE OR REPLACE FUNCTION public.getdesviopadraoconsumo(idprod character varying, dataref date DEFAULT ('now'::text)::date)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$
declare
  desvio numeric;
begin

  -- Espaço amostral sai de 365 para 180;

  SELECT coalesce(round(cast(stddev_pop(saidas) as numeric), 2), 0)
      into desvio
  from (select mes,sum(saidas) as saidas from (SELECT to_char(emissao, 'YYYYMM') AS mes,to_char(emissao, 'YYYYMMDD') AS dia, sum(qtde)-coalesce(qtde_corte,0) AS saidas
      FROM consumos
      left join (
         select  idproduto,to_char(data,'yyyymmdd') cod_mes,sum(qtde) as qtde_corte from cortes 
             where data between (dataref - 180) AND dataref and cortes.idproduto=idprod
             group by idproduto,cod_mes
      ) as corte
       on corte.cod_mes = to_char(emissao, 'YYYYMMdd')
       and corte.idproduto = consumos.idproduto
      WHERE     consumos.idproduto = idprod
            AND emissao BETWEEN (dataref - 180) AND dataref
      GROUP BY mes,dia,qtde_corte)a  group by a.mes )com;

 /* if desvio = 0
  then

    SELECT coalesce(round(cast(stddev_pop(saidas) as numeric), 2), 0)
        into desvio
    from (select mes,sum(saidas) as saidas from (SELECT to_char(emissao, 'YYYYMM') AS mes,to_char(emissao, 'YYYYMMDD') AS dia, sum(qtde)-coalesce(qtde_corte,0) AS saidas
      FROM consumos
      left join (
         select  idproduto,to_char(data,'yyyymmdd') cod_mes,sum(qtde) as qtde_corte from cortes 
             where data between (dataref - 365) AND dataref and cortes.idproduto=idprod
             group by idproduto,cod_mes
      ) as corte
       on corte.cod_mes = to_char(emissao, 'YYYYMMdd')
       and corte.idproduto = consumos.idproduto
      WHERE     consumos.idproduto = idprod
            AND emissao BETWEEN (dataref - 365) AND dataref
      GROUP BY mes,dia,qtde_corte)a group by a.mes )com;

  end if;*/

  return desvio;

end;

$function$

