CREATE OR REPLACE FUNCTION public.oportunidade_vendas(produto character varying, dataini date, datafim date)
 RETURNS TABLE(op_idproduto character varying, op_descricao_produto character varying, op_ano integer, op_trimestre integer, op_mes integer, op_media_trimestre numeric, op_media_diaria_trimestre numeric, op_media_trimestre_ant numeric, op_media_diaria_trimestre_ant numeric, op_media_anual_corrida numeric, op_media_diaria_anual numeric, op_total_saida_trimestre numeric, op_cof_variacao numeric, op_valor_unitario numeric, op_ganho numeric, op_perda numeric, op_total_perda_mensal numeric, op_idfamilia_produto integer, op_descricao_familia_produto character varying)
 LANGUAGE plpgsql
AS $function$ 
declare
begin
	
	PERFORM processar_saldos_produto(produto,dataini,datafim);
	
	return query 
	  with movimento as (
select idproduto,ano,trimestre,mes,media_trimestre,media_diaria_trimestre,media_trimestre_ant,media_diaria_trimestre_ant,avg(media_anual_corrida) as media_anual_corrida,avg(media_diaria_anual) as media_diaria_anual,
 sum(saidas) as total_saida_trimestre,avg(coeficiente_variacao) as cof_variacao,sum(p) ganho,sum(n) as perda from (
select idproduto,ano,trimestre,mes,media_trimestre,media_diaria_trimestre,media_trimestre_ant,media_diaria_trimestre_ant,media_anual_corrida,media_diaria_anual,saidas,
(case when (saidas-media_diaria_trimestre-media_diaria_trimestre_ant-media_diaria_anual) > 0 then  (saidas-media_diaria_trimestre-media_diaria_trimestre_ant-media_diaria_anual) else 0 end ) as p,
(case when (saidas-media_diaria_trimestre-media_diaria_trimestre_ant-media_diaria_anual) < 0 then  (saidas-media_diaria_trimestre-media_diaria_trimestre_ant-media_diaria_anual) else 0 end ) as n,
coeficiente_variacao
from saldos where data between dataini and datafim  and saldos.idproduto in (produto)) totais
group by ano,trimestre,mes,idproduto,media_diaria_trimestre,media_trimestre,media_trimestre_ant,media_diaria_trimestre_ant
order by idproduto,ano,trimestre,mes)

select movimento.idproduto,produtos.descricao_produto,ano,trimestre,mes,media_trimestre::numeric,media_diaria_trimestre::numeric,media_trimestre_ant::numeric,
       media_diaria_trimestre_ant::numeric,media_anual_corrida::numeric,media_diaria_anual::numeric,total_saida_trimestre::numeric,cof_variacao::numeric,valor_unitario::numeric,
       ganho::numeric,perda::numeric,(valor_unitario::numeric*perda::numeric) total_perda_mensal,produtos.idfamilia_produto,
       descricao_familia_produto from movimento 
 inner join produtos
  on produtos.idproduto = movimento.idproduto
 inner join familia_produtos
 on familia_produtos.idfamilia_produto = produtos.idfamilia_produto
  where produtos.revenda='S'
 order by idproduto,ano,trimestre,mes;
	
end; 
 $function$

