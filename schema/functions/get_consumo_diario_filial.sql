CREATE OR REPLACE FUNCTION public.get_consumo_diario_filial(p_filial numeric, idprod character varying, data_venda date)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$

declare

    total numeric;

begin





    select coalesce(round(sum(qtde)::numeric,4),0) into total from consumos where filial= p_filial and idproduto=idprod and emissao=data_venda;

  

     

     if coalesce(total,0) < 0 then 

     

        return 0;

     

       else

       

        return coalesce(total,0);

      

     end if;  





end;



$function$

