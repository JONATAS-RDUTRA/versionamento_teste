CREATE OR REPLACE FUNCTION public.get_freq_ruptura(idprod character varying, p_ano integer, p_mes integer)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$
declare
   rec_data record;
   saida numeric;
   flag numeric;
begin
 
  flag = 0;
  saida = 0;


  for rec_data in (select estoque,media_trimestre from saldos where idproduto= idprod and ano=p_ano and mes=p_mes order by data)
  loop

           if rec_data.estoque = 0 and flag = 0 and rec_data.media_trimestre > 0 then 
             
              flag =1; 
             
              saida = saida + 1;
           
            else
            
              flag= 0;
             
           end if; 
  end loop;
 
  return saida;
 
end;

$function$

