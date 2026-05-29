CREATE OR REPLACE FUNCTION public.processar_saldos_filial(dataini date, datafim date)
 RETURNS void
 LANGUAGE plpgsql
AS $function$

declare

  rec_prod record;

  saida varchar;

begin

 

 -- saida = gerar_saldos_diario_filial(dataini,datafim); 



  for rec_prod in (select filial,idproduto,"data" from saldo_filiais sf where "data"  between  dataini and datafim)

  loop


       PERFORM set_media_diaria_vendas_trimestral_filial(rec_prod.filial,rec_prod.idproduto,rec_prod.data::date);


  end loop;


end;


$function$

