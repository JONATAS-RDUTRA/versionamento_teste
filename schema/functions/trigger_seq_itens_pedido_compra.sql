CREATE OR REPLACE FUNCTION public.trigger_seq_itens_pedido_compra()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ 
declare

    seq int;
 
begin 

   -- Sequencia de Produtos

	select coalesce(pc.seq_itens,0)+1  into  seq from pedidos_compras pc where idpedido = new.idpedido;
    update pedidos_compras set seq_itens=seq where idpedido = new.idpedido;

    new.item = seq;

RETURN NEW;

end;

 $function$

