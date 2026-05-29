CREATE OR REPLACE FUNCTION public.get_estoque_diario_filial(p_filial numeric, idprod character varying, data_venda date)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$

declare

    total numeric;

begin



    select sum(qtde) into total from hist_estoque WHERE filial = p_filial and  hist_estoque.idproduto = idprod  AND data = data_venda;
   
    if total is null then 
    
      select sum(qtde) into total from hist_estoque WHERE filial = p_filial and  hist_estoque.idproduto = idprod  
        AND data  = (select max(data) from hist_estoque WHERE filial = p_filial and  hist_estoque.idproduto = idprod  AND data < data_venda);
    
    end if;
   
  

    return coalesce(total,0);



end;



$function$

