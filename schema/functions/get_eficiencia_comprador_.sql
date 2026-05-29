CREATE OR REPLACE FUNCTION public.get_eficiencia_comprador_(id numeric, periodo integer DEFAULT 30)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$
declare 
    total_ocorencias numeric;
    total numeric;
    rec_percepcao record;
begin 

   total=0;
   	
   select count(*)  into total_ocorencias from analise_percepcao_compras where idcomprador=id and data_solicitacao between first_day(current_date)  and last_day(current_date) and status_percepcao not in ('PRIMEIRA COMPRA');
  
   for rec_percepcao in (select status_percepcao,count(*) ocorrencia from analise_percepcao_compras where idcomprador=id and data_solicitacao between first_day(current_date)  and last_day(current_date) group by status_percepcao)
    loop
    
     if rec_percepcao.status_percepcao in ('PERCEPCAO COM SUTIL PREMATURIDADE','PERCEPCAO EM PONTO DE PEDIDO') then 
     
       total = total +((rec_percepcao.ocorrencia/total_ocorencias));
     
     end if;
    
    end loop;

    return (total);

end;

$function$

