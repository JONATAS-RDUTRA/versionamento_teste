CREATE OR REPLACE FUNCTION public.processar_historico_compras_saldos(prazo integer DEFAULT 30)
 RETURNS void
 LANGUAGE plpgsql
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
		
  
  for rec_prod in (select idproduto,"data",arvore_decisao from saldos where "data" between current_date-prazo and current_date and arvore_decisao is not null order by "data",idproduto)
     loop
                
           
          select count(*) into existe from hist_analise_compras where idproduto = rec_prod.idproduto and data_solicitacao = rec_prod.data;
         
          if existe = 0 then
          
             select estoque_seguranca,ponto_pedido,estoque_maximo,consumo_medio,sugestao,estoque into eseg,ppd,emax,cmm,sugest,est from get_calculo_dimensoes_estoque(rec_prod.idproduto,rec_prod.arvore_decisao,rec_prod.data);

             INSERT INTO public.hist_analise_compras
               (idproduto, data_solicitacao,arvore_decisao,estoque_seguranca, ponto_pedido, estoque_maximo,consumo_medio,sugestao,estoque)
             VALUES(rec_prod.idproduto, rec_prod.data,rec_prod.arvore_decisao,eseg,ppd,emax,cmm,sugest,est);


             else
             
             select estoque_seguranca,ponto_pedido,estoque_maximo,consumo_medio,sugestao,estoque into eseg,ppd,emax,cmm,sugest,est from get_calculo_dimensoes_estoque(rec_prod.idproduto,rec_prod.arvore_decisao,rec_prod.data);
             
             
             UPDATE public.hist_analise_compras
                 SET estoque_seguranca=eseg, ponto_pedido=ppd, estoque_maximo=emax, consumo_medio=cmm, 
                 sugestao=sugest,arvore_decisao=rec_prod.arvore_decisao,processamento=current_timestamp,
                 estoque=est
             WHERE filial=0 AND idproduto= rec_prod.idproduto  AND data_solicitacao=rec_prod.data;

          end if;
         
     
     end loop;


end;

$function$

