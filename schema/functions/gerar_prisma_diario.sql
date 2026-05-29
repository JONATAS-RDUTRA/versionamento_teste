CREATE OR REPLACE FUNCTION public.gerar_prisma_diario(dataini date, datafim date)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
declare 

  rec_prod record;
begin

  for rec_prod in (select idproduto,"data" from saldos where "data" between dataini and datafim and arvore_decisao is null  order by idproduto,"data")
  loop
  
       update saldos set arvore_decisao=get_prismas_analise(idproduto,rec_prod.data::date) where idproduto =rec_prod.idproduto and data = rec_prod.data::date;

  end loop;

end;

$function$

