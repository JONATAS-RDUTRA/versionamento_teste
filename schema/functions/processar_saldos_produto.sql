CREATE OR REPLACE FUNCTION public.processar_saldos_produto(produto character varying, dataini date, datafim date)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
declare
  rec_data record;
  rec_prod record;
  saida varchar;
begin
 
  saida = gerar_saldos_diario_prod(produto,dataini,datafim); 

  for rec_prod in (select idproduto from produtos where idproduto=produto order by idproduto)
  loop

    for rec_data in (SELECT to_char(day :: date, 'DD/MM/YYYY') as data
                     FROM generate_series(dataini, datafim, '1 day') day)
    loop
    
       saida = set_media_diaria_vendas_trimestral(rec_prod.idproduto,rec_data.data::date);
      
    end loop;

  end loop;
 
end;

$function$

