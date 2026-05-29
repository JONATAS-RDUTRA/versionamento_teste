CREATE OR REPLACE FUNCTION public.gerar_carga_prismas(dataini date, datafim date)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
declare 
  rec_data record;
begin


 for rec_data in (SELECT to_char(day :: date, 'DD/MM/YYYY') as data
                     FROM generate_series(dataini,datafim, '1 month') day)
  loop
    
       perform get_prismas_analise('1',rec_data.data::date);
    
  end loop;
end;

$function$

