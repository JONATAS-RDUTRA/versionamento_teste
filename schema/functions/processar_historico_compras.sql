CREATE OR REPLACE FUNCTION public.processar_historico_compras(prazo integer DEFAULT 30)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
declare

requisoes record;
arv_decisao varchar;
eseg numeric;
ppd  numeric;
emax numeric;
existe numeric;
cmm numeric;
sugest numeric;

begin
		
  
  for requisoes in (select distinct r.idproduto::varchar,r.data_solicitacao from requisicoes r
       inner join produtos p 
        on p.idproduto::varchar = r.idproduto::varchar
       inner join entrada_mercadorias e ON r.ordem_compra = e.ordem_compra AND r.idproduto = e.idproduto  
      where  data_solicitacao between current_date - prazo and current_date 
          /* and not exists (select 'x' from hist_analise_compras h 
                                            where h.idproduto::varchar = r.idproduto::varchar 
                                            and h.data_solicitacao = r.data_solicitacao )*/                 
           and p.revenda='S' 
           and p.status <>'FL'
          order by r.data_solicitacao)
     loop
                
           
          select count(*),arvore_decisao  into existe,arv_decisao from hist_analise_compras where idproduto = requisoes.idproduto 
            and data_solicitacao = requisoes.data_solicitacao group by arvore_decisao;
         
          if existe = 0 then
          
             arv_decisao = (select get_prismas_analise(requisoes.idproduto,requisoes.data_solicitacao));
         
             select estoque_seguranca,ponto_pedido,estoque_maximo,consumo_medio,sugestao into eseg,ppd,emax,cmm,sugest from get_calculo_dimensoes_estoque(requisoes.idproduto,arv_decisao,requisoes.data_solicitacao);

             INSERT INTO public.hist_analise_compras
               (idproduto, data_solicitacao,arvore_decisao,estoque_seguranca, ponto_pedido, estoque_maximo,consumo_medio,sugestao)
             VALUES(requisoes.idproduto, requisoes.data_solicitacao,arv_decisao,eseg,ppd,emax,cmm,sugest);


             else
             
             select estoque_seguranca,ponto_pedido,estoque_maximo,consumo_medio,sugestao into eseg,ppd,emax,cmm,sugest from get_calculo_dimensoes_estoque(requisoes.idproduto,arv_decisao,requisoes.data_solicitacao);
             
             
             UPDATE public.hist_analise_compras
                 SET estoque_seguranca=eseg, ponto_pedido=ppd, estoque_maximo=emax, consumo_medio=cmm, sugestao=sugest
             WHERE filial=0 AND idproduto= requisoes.idproduto  AND data_solicitacao=requisoes.data_solicitacao;

          end if;
         
     
     end loop;


end;

$function$

