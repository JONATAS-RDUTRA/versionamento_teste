CREATE OR REPLACE FUNCTION public.get_consumo_diario(idprod character varying, data_venda date)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$
declare
    total numeric;
begin


  --select coalesce(round(sum(qtde)::numeric,4),0) into total from consumos where idproduto=idprod and emissao=data_venda;
  
  SELECT coalesce(sum(qtde),0)-coalesce(qtde_corte,0)
    into total
      FROM consumos
      left join (
         select  idproduto,to_char(data,'yyyymm') cod_mes,sum(qtde) as qtde_corte from cortes 
             where data = data_venda and cortes.idproduto=idprod
             group by idproduto,cod_mes
      ) as corte
       on corte.cod_mes = to_char(emissao, 'YYYYMM')
       and corte.idproduto = consumos.idproduto
      WHERE     consumos.idproduto = idprod
            AND emissao = data_venda
      GROUP by qtde_corte;
     
     if coalesce(total,0) < 0 then 
     
        return 0;
     
       else
       
        return coalesce(total,0);
      
     end if;  


end;

$function$

