CREATE OR REPLACE FUNCTION public.getlotemedioqr(idprod character varying)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$
declare 
    loteMedio numeric;
begin 

 select 
round(cast(sum(saidas)/count(mes) as numeric),2)
 into loteMedio
from (
select  emissao as mes,count(qtde) as saidas
  from movimentacoes
  inner join movimentacoes_produtos
   on movimentacoes.idmovimentacao = movimentacoes_produtos.movimentacao_idorcamentos
   where  movimentacoes.tipo_movimentacao ='SD' 
   and  movimentacoes_produtos.produtos_idproduto= idProd  and emissao BETWEEN  (current_date - 365) AND current_date
   group by emissao 
    union all
    SELECT  emissao as mes, sum(qtde) AS saidas
      FROM consumos
      WHERE     idproduto = idProd
            AND emissao BETWEEN  (current_date - 365) AND current_date
      GROUP BY mes) saidas;
    
    return loteMedio;

end;

$function$

