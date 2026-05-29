CREATE OR REPLACE FUNCTION public.processar_baixa_pedidos_systock()
 RETURNS void
 LANGUAGE plpgsql
AS $function$
declare
 
rec_oc record;
rec_pedidos record;

begin
	
for rec_oc in (select * from ( 
            SELECT c.idpedido,i.idproduto,data_emissao,i.qtde_pedido,
            (select coalesce(sum(qtde),0) from requisicoes r where r.idfilial in  (select filial from grupo_filial gf  where gf.id_grupo =c.grupo) and r.idproduto=i.idproduto   and r.data_solicitacao >=c.data_emissao) qtde_atend,
            (select max(id_solicitacao) from requisicoes r where r.idfilial in (select filial from grupo_filial gf  where gf.id_grupo =c.grupo) and r.idproduto=i.idproduto   and r.data_solicitacao >=c.data_emissao) oc_num,
            (select distinct data_solicitacao from requisicoes r where 
               r.id_solicitacao = (select max(id_solicitacao) from requisicoes r where r.idfilial in (select filial from grupo_filial gf  where gf.id_grupo =c.grupo) and r.idproduto=i.idproduto   and r.data_solicitacao >=c.data_emissao)) oc_data
            FROM pedidos_compras c
             inner join pedidos_compras_itens i
              on c.idpedido  = i.idpedido 
            where status='CT' 
            order by idpedido) a  where oc_num is not null)
 loop
	
     update pedidos_compras_itens  set oc_num = rec_oc.oc_num,oc_data = rec_oc.oc_data,oc_qtde = rec_oc.qtde_atend 
        where idpedido = rec_oc.idpedido and idproduto = rec_oc.idproduto and oc_num is null;
    
 
 end loop;	

 --Fechamento dos Pedidos Systock
 
 for rec_pedidos in (select idpedido,oc_data, ((qtde_itens_atend::numeric /qtde_itens::numeric )*100) perc_atendimento from (
  select pc.idpedido,pc.data_emissao,max(pci.oc_data) oc_data,count(pci.idproduto) qtde_itens,count(pci.oc_data) qtde_itens_atend from pedidos_compras pc 
   inner join pedidos_compras_itens pci
   on pci.idpedido  = pc.idpedido 
   where pc.status='CT' group by pc.idpedido,pc.data_emissao order by pc.idpedido) a where a.oc_data is not null)
  loop
      
    if rec_pedidos.perc_atendimento >= 20 then 
  
      update pedidos_compras set status='FN',data_final=rec_pedidos.oc_data where idpedido= rec_pedidos.idpedido;
     
    end if; 
  
  end loop;
	
end
$function$

