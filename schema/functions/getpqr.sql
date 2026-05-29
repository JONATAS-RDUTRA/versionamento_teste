CREATE OR REPLACE FUNCTION public.getpqr(idprod character varying)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$
declare 
    pqr character varying;
begin 

 select 
coalesce(
(select tempo_medio_apanhe from parametros_popularidade where 
sum(saidas)/(abs(datediff('mm',cast(to_char(current_date,'YYYYMMDD') as date), cast(min(mes)||'01' as date)))+1)
between parametros_popularidade.range_inicial and parametros_popularidade.range_final),'R')
 into pqr 
from (


select to_char(emissao, 'YYYYMM') AS mes,count(*) as saidas
  from movimentacoes
  inner join movimentacoes_produtos
   on movimentacoes.idmovimentacao = movimentacoes_produtos.movimentacao_idorcamentos
   where  movimentacoes.tipo_movimentacao ='SD' 
   and  movimentacoes_produtos.produtos_idproduto= idProd  and emissao between  (current_date - 365) AND current_date
   group by emissao

   
  union all
  
    SELECT to_char(emissao, 'YYYYMM') AS mes, count(*) AS saidas
      FROM consumos
      WHERE     idproduto = idProd
            AND emissao BETWEEN (current_date - 365) AND current_date  GROUP BY mes ) saidas;
    
    return pqr;

end;

$function$

