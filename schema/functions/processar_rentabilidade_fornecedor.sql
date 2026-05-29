CREATE OR REPLACE FUNCTION public.processar_rentabilidade_fornecedor(p_forn integer, p_periodo integer DEFAULT 180)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
declare
 
rec_produtos record;
rec_rent_filial record;
rec_rent_prod record;
vtotal_venda numeric;
vtotal_venda_custo numeric;
vqtde_itens numeric;
vvalor_medio numeric;
vlucro_bruto numeric;
vmarkup numeric;

vtotal_geral_venda numeric;
vtotal_geral_venda_custo numeric;
vtotal_geral_qtde_itens numeric;

begin
	
update rentabilidade set status ='D' where idfornecedor= p_forn;
	
for rec_produtos in (select filial,idproduto,idfornecedor from produtos_filial pf  where idfornecedor = p_forn and revenda ='S')
  loop 
  
     select round(sum(total_venda)::numeric,2),round(sum(total_venda_custo)::numeric,2),
		 sum(qtde),round(avg(total_venda/qtde)::numeric,2),
		round((sum(total_venda) -sum(total_venda_custo))::numeric,2) 
		 into vtotal_venda,vtotal_venda_custo,vqtde_itens,vvalor_medio,vlucro_bruto
		from (
		select valor_unit, qtde ,(valor_unit*qtde) total_venda,((pf.custo_unitario*pf.fator_conversao) *qtde) as total_venda_custo
		from
			consumos c
			inner join produtos_filial pf on pf.filial = c.filial  and pf.idproduto = c.idproduto 
		where
			c.filial = rec_produtos.filial and pf.idproduto =rec_produtos.idproduto
			and c.emissao between current_date-p_periodo and current_date)a;
		
		
		   vmarkup = round(((vtotal_venda/nullif(vtotal_venda_custo,0))-1)*100,2);
		
		
		   UPDATE rentabilidade
			SET idfornecedor=rec_produtos.idfornecedor, total_venda=coalesce(vtotal_venda,0), total_venda_custo=coalesce(vtotal_venda_custo,0), 
			    lucro_bruto=coalesce(vlucro_bruto,0), valor_medio=coalesce(vvalor_medio,0), qtde_itens=coalesce(vqtde_itens,0), status=null,amostra=p_periodo,
			    markup=vmarkup,processamento=current_timestamp 
			    
			WHERE filial=rec_produtos.filial AND idproduto=rec_produtos.idproduto;

		  if not found then 
		       
		       INSERT INTO rentabilidade
				(filial, idproduto, idfornecedor, total_venda, total_venda_custo, lucro_bruto, valor_medio, qtde_itens, status,amostra,markup,processamento)
				VALUES(rec_produtos.filial,rec_produtos.idproduto,rec_produtos.idfornecedor, coalesce(vtotal_venda,0),coalesce(vtotal_venda_custo,0), 
			    coalesce(vlucro_bruto,0),coalesce(vvalor_medio,0), coalesce(vqtde_itens,0),null,p_periodo,vmarkup,current_timestamp);
			   
		  end if;
   
  end loop;
 
 for rec_rent_filial in (select distinct filial from rentabilidade r where idfornecedor =p_forn order by filial )
 	loop 
 	
 	    
 	   select sum(total_venda),sum(total_venda_custo),sum(qtde_itens) into vtotal_geral_venda,vtotal_geral_venda_custo,vtotal_geral_qtde_itens
 	     from rentabilidade r where idfornecedor =p_forn and filial=rec_rent_filial.filial;
 	   
 	
 		for rec_rent_prod in (select filial,idproduto,total_venda ,total_venda_custo ,qtde_itens from rentabilidade r  where idfornecedor =p_forn  and filial = rec_rent_filial.filial )
 			loop 
 			
 			    update rentabilidade  set perc_volume = round((rec_rent_prod.qtde_itens/nullif(vtotal_geral_qtde_itens,0))*100,2),
 			                              perc_vendas= round((rec_rent_prod.total_venda/nullif(vtotal_geral_venda,0))*100,2),
 			                              perc_lucro =round((rec_rent_prod.total_venda_custo/nullif(vtotal_geral_venda_custo,0))*100,2)
 			        where filial= rec_rent_prod.filial and idproduto= rec_rent_prod.idproduto;                     
 			                              
 			end loop;
 	
 	end loop;
 
 
 delete from  rentabilidade where status ='D';
	
end
$function$

