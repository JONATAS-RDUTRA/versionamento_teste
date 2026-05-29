CREATE OR REPLACE FUNCTION public.processar_historico_compras_saldos_filial(prazo integer DEFAULT 30)
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

		

  

  for rec_prod in (select filial,idproduto,"data",arvore_decisao from saldo_filiais sf where "data" between current_date-prazo and current_date and arvore_decisao is not null order by "data",idproduto,filial)

     loop

                

           

          select count(*) into existe from hist_analise_compras_filial where filial= rec_prod.filial and idproduto = rec_prod.idproduto and data_solicitacao = rec_prod.data;

         

          if existe = 0 then

          

             select coalesce(estoque_seguranca,0),coalesce(ponto_pedido,0),coalesce(estoque_maximo,0),coalesce(consumo_medio,0),coalesce(sugestao,0),coalesce(estoque,0) into eseg,ppd,emax,cmm,sugest,est from get_calculo_dimensoes_estoque_filial(rec_prod.filial,rec_prod.idproduto,rec_prod.arvore_decisao,rec_prod.data);



             INSERT INTO public.hist_analise_compras_filial

               (filial,idproduto, data_solicitacao,arvore_decisao,estoque_seguranca, ponto_pedido, estoque_maximo,consumo_medio,sugestao,estoque)

             VALUES(rec_prod.filial,rec_prod.idproduto, rec_prod.data,rec_prod.arvore_decisao,eseg,ppd,emax,cmm,sugest,est);





             else

             

             select coalesce(estoque_seguranca,0),coalesce(ponto_pedido,0),coalesce(estoque_maximo,0),coalesce(consumo_medio,0),coalesce(sugestao,0),coalesce(estoque,0) into eseg,ppd,emax,cmm,sugest,est  from get_calculo_dimensoes_estoque_filial(rec_prod.filial,rec_prod.idproduto,rec_prod.arvore_decisao,rec_prod.data);

             

             

             UPDATE public.hist_analise_compras_filial

                 SET estoque_seguranca=eseg, ponto_pedido=ppd, estoque_maximo=emax, consumo_medio=cmm, 

                 sugestao=sugest,arvore_decisao=rec_prod.arvore_decisao,processamento=current_timestamp,

                 estoque=est

             WHERE filial=rec_prod.filial AND idproduto= rec_prod.idproduto  AND data_solicitacao=rec_prod.data;



          end if;

         

     

     end loop;





end;



$function$

