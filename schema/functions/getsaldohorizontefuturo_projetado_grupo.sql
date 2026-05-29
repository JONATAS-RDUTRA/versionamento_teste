CREATE OR REPLACE FUNCTION public.getsaldohorizontefuturo_projetado_grupo(p_filial numeric, idprod character varying, p_grupo numeric)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$

declare 

    rec_filial record;
    saldo_estoque numeric;
    compra_transito numeric;
    consumo_transito numeric;
    v_saldo_estoque numeric;
    v_compra_transito numeric;
    v_consumo_transito numeric;
    saldo_futuro numeric;

begin 


  consumo_transito = 0;
  compra_transito =0;
  saldo_estoque =0;

  for rec_filial in (select filial from grupo_filial gf where id_grupo = p_grupo)
    loop

	    select getconsumo_transito_projetado_filial( rec_filial.filial,idprod,amplitude_transito_atual_filial( rec_filial.filial,idprod)),getcompra_transito_grupo(p_grupo,idprod)/fator_conversao,coalesce(estoque,0) 
	
	           into v_consumo_transito,v_compra_transito,v_saldo_estoque 
	
	    from produtos_filial where filial = rec_filial.filial and idproduto=idprod; 
   
   
      
	   consumo_transito = consumo_transito + v_consumo_transito;
	   compra_transito =  v_compra_transito;
	   saldo_estoque = saldo_estoque + v_saldo_estoque;
	   
   end loop;


    

   saldo_futuro = (saldo_estoque-consumo_transito)+compra_transito;

    

    return saldo_futuro;



end;



$function$

