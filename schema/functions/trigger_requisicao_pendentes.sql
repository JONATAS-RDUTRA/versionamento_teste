CREATE OR REPLACE FUNCTION public.trigger_requisicao_pendentes()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
declare
begin 
	new.qtde_pendente = new.qtde - new.qtde_entregue;

    if new.qtde_pendente  <  0 then 
    
    	new.qtde_pendente = 0;
    
    end if;
   
    new.data_entrega  = (select max(data_entrada) from entrada_mercadorias where ordem_compra=new.ordem_compra and idproduto::varchar = new.idproduto);

	-- Pedidos desconsiderados
	IF EXISTS (
		SELECT * 
		FROM requisicoes_desconsideradas rd 
		WHERE rd.id_solicitacao = NEW.id_solicitacao AND rd.item = NEW.item AND rd.idproduto = NEW.idproduto
	) THEN
	
		NEW.qtde_entregue = NEW.qtde;
		NEW.qtde_pendente = 0;
	
END IF;

RETURN NEW;
end
$function$

