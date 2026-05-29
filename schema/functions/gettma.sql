CREATE OR REPLACE FUNCTION public.gettma(idprod character varying, dataref date DEFAULT ('now'::text)::date)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$
declare 
    tma numeric;
begin 

 select 
   coalesce(ceil(sum(saidas)/(abs(datediff('mm',cast(to_char(dataref,'YYYYMMDD') as date), cast(min(mes)||'01' as date)))+1)),0)
into tma
from (
select to_char(emissao, 'YYYYMM') AS mes,count(*) as saidas
  from movimentacoes
  inner join movimentacoes_produtos
   on movimentacoes.idmovimentacao = movimentacoes_produtos.movimentacao_idorcamentos
   where  movimentacoes.tipo_movimentacao ='SD' 
   and  movimentacoes_produtos.produtos_idproduto= idProd and emissao between  (dataref - 365) AND dataref
   group by emissao
  union all
    SELECT to_char(emissao, 'YYYYMM') AS mes, count(*) AS saidas
      FROM consumos
      WHERE     idproduto = idProd
            AND emissao BETWEEN (dataref - 365) AND dataref  GROUP BY mes ) saidas;

    
    return tma;

end;

$function$

