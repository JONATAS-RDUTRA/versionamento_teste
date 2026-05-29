CREATE OR REPLACE FUNCTION public.processar_historico_compras_saldos_filial_prod(p_filial numeric, p_produto character varying, p_dataini date, p_datafim date)
 RETURNS void
 LANGUAGE plpgsql
 PARALLEL SAFE
AS $function$

declare

rec_prod record;
arv_decisao varchar;
eseg numeric;
ppd  numeric;
emax numeric;
existe numeric;
cmm numeric;
sugest numeric;
est numeric;

begin

		

for rec_prod in (select filial,idproduto,"data",arvore_decisao from saldo_filiais sf where filial = p_filial and idproduto =p_produto and "data" between p_dataini and p_datafim and  arvore_decisao is not null order by "data")

     loop

        
       select coalesce(estoque_seguranca,0),coalesce(ponto_pedido,0),coalesce(estoque_maximo,0),coalesce(consumo_medio,0),coalesce(sugestao,0),coalesce(estoque,0) into eseg,ppd,emax,cmm,sugest,est  from get_calculo_dimensoes_estoque_filial(rec_prod.filial,rec_prod.idproduto,rec_prod.arvore_decisao,rec_prod.data);

            
	     UPDATE public.hist_analise_compras_filial
	
	         SET estoque_seguranca=eseg, ponto_pedido=ppd, estoque_maximo=emax, consumo_medio=cmm, 
	
	         sugestao=sugest,arvore_decisao=rec_prod.arvore_decisao,processamento=current_timestamp,
	
	         estoque=est
	
	     WHERE filial=rec_prod.filial AND idproduto= rec_prod.idproduto  AND data_solicitacao=rec_prod.data;
    
         
	    if not found then 
	    
	    	 INSERT INTO public.hist_analise_compras_filial

               (filial,idproduto, data_solicitacao,arvore_decisao,estoque_seguranca, ponto_pedido, estoque_maximo,consumo_medio,sugestao,estoque)

             VALUES(rec_prod.filial,rec_prod.idproduto, rec_prod.data,rec_prod.arvore_decisao,eseg,ppd,emax,cmm,sugest,est);
	    
	    end if;
	   
   
     end loop;


end;


$function$

