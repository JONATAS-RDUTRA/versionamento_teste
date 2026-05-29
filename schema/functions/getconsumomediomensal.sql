CREATE OR REPLACE FUNCTION public.getconsumomediomensal(idprod character varying, dataref date DEFAULT ('now'::text)::date)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$
declare 
    cmm3 numeric;
    cmm6 numeric;
    cmm numeric;
    primeiro_consumo numeric;
    qtde3 numeric;
    qtde6 numeric;
begin 
	
	select current_date- min(emissao) into  primeiro_consumo from consumos where idproduto=idprod;

--Media do Consumo  sai 365 para  (90+180)/2 
-- 30/05/2019 - Inclusão do abatimento Corte nas saídas
 
 SELECT coalesce(round(cast(sum(saidas)/(abs( case when abs(datediff('mm',cast(to_char(dataref,'YYYYMMDD') as date), cast(min(mes)||'01' as date)))+1 > 3 then 3 
 when abs(datediff('mm',cast(to_char(dataref,'YYYYMMDD') as date), cast(min(mes)||'01' as date)))+1 < 3 and primeiro_consumo >= 90 then 3                                                       
 else abs(datediff('mm',cast(to_char(dataref,'YYYYMMDD') as date), cast(min(mes)||'01' as date)))+1 end ))as numeric) ,2),0),
 (abs( case when abs(datediff('mm',cast(to_char(dataref,'YYYYMMDD') as date), cast(min(mes)||'01' as date)))+1 > 3 then 3 
 when abs(datediff('mm',cast(to_char(dataref,'YYYYMMDD') as date), cast(min(mes)||'01' as date)))+1 < 3 and primeiro_consumo >= 90 then 3                                                       
 else abs(datediff('mm',cast(to_char(dataref,'YYYYMMDD') as date), cast(min(mes)||'01' as date)))+1 end ))
  into cmm3,qtde3
 FROM ( SELECT to_char(emissao, 'YYYYMM') AS mes,to_char(emissao, 'YYYYMMDD') AS dia, sum(qtde)-coalesce(qtde_corte,0) AS saidas
      FROM consumos
      left join (
         select  idproduto,to_char(data,'yyyymmdd') cod_mes,sum(qtde) as qtde_corte from cortes 
             where data between (dataref - 90) AND dataref and cortes.idproduto=idprod
             group by idproduto,cod_mes
      ) as corte
       on corte.cod_mes = to_char(emissao, 'YYYYMMdd')
       and corte.idproduto = consumos.idproduto
      WHERE     consumos.idproduto = idprod
            AND emissao BETWEEN (dataref - 90) AND dataref
      GROUP BY mes,dia,qtde_corte) com;

  SELECT coalesce(round(cast(sum(saidas)/(abs( case when abs(datediff('mm',cast(to_char(dataref,'YYYYMMDD') as date), cast(min(mes)||'01' as date)))+1 > 6 then 6
  when abs(datediff('mm',cast(to_char(dataref,'YYYYMMDD') as date), cast(min(mes)||'01' as date)))+1 < 6 and primeiro_consumo >= 180 then 6
  else abs(datediff('mm',cast(to_char(dataref,'YYYYMMDD') as date), cast(min(mes)||'01' as date)))+1 end ))as numeric) ,2),0),
  (abs( case when abs(datediff('mm',cast(to_char(dataref,'YYYYMMDD') as date), cast(min(mes)||'01' as date)))+1 > 6 then 6
  when abs(datediff('mm',cast(to_char(dataref,'YYYYMMDD') as date), cast(min(mes)||'01' as date)))+1 < 6 and primeiro_consumo >= 180 then 6
  else abs(datediff('mm',cast(to_char(dataref,'YYYYMMDD') as date), cast(min(mes)||'01' as date)))+1 end ))
  
  into cmm6,qtde6
 FROM ( SELECT to_char(emissao, 'YYYYMM') AS mes,to_char(emissao, 'YYYYMMDD') AS dia, sum(qtde)-coalesce(qtde_corte,0) AS saidas
      FROM consumos
      left join (
         select  idproduto,to_char(data,'yyyymmdd') cod_mes,sum(qtde) as qtde_corte from cortes 
             where data between (dataref - 180) AND dataref and cortes.idproduto=idprod
             group by idproduto,cod_mes
      ) as corte
       on corte.cod_mes = to_char(emissao, 'YYYYMMDD')
       and corte.idproduto = consumos.idproduto
      WHERE     consumos.idproduto = idprod
            AND emissao BETWEEN (dataref - 180) AND dataref
      GROUP BY mes,dia,qtde_corte) com;

    if qtde6 < 6 then cmm6 = cmm3; end if;
     
    cmm = (cmm3+cmm6)/2;

   if cmm = 0 then 
   
     SELECT coalesce(round(cast(sum(saidas)/(abs( case when abs(datediff('mm',cast(to_char(dataref,'YYYYMMDD') as date), cast(min(mes)||'01' as date)))+1 > 12  then 12 
     when abs(datediff('mm',cast(to_char(dataref,'YYYYMMDD') as date), cast(min(mes)||'01' as date)))+1 < 12 and primeiro_consumo >= 365 then 12
     else abs(datediff('mm',cast(to_char(dataref,'YYYYMMDD') as date), cast(min(mes)||'01' as date)))+1 end ))as numeric) ,2),0)
        into cmm6
     FROM ( SELECT to_char(emissao, 'YYYYMM') AS mes,to_char(emissao, 'YYYYMMDD') AS dia, sum(qtde)-coalesce(qtde_corte,0) AS saidas
      FROM consumos
      left join (
         select  idproduto,to_char(data,'yyyymmdd') cod_mes,sum(qtde) as qtde_corte from cortes 
             where data between (dataref - 365) AND dataref and cortes.idproduto=idprod
             group by idproduto,cod_mes
      ) as corte
       on corte.cod_mes = to_char(emissao, 'YYYYMMDD')
       and corte.idproduto = consumos.idproduto
      WHERE     consumos.idproduto = idprod
            AND emissao BETWEEN (dataref - 365) AND dataref
      GROUP BY mes,dia,qtde_corte) com;


       return cmm6;
   
    else
    
       return cmm;
   
    end if;
    
    

end;
$function$

