CREATE OR REPLACE FUNCTION public.gerar_prisma_diario_filial(dataini date, datafim date)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
declare 
  rec_prod record;
begin

  for rec_prod in (select filial,idproduto,"data" from saldo_filiais sf where "data" between dataini and datafim and arvore_decisao is null  order by idproduto,"data",filial)

  loop

       update saldo_filiais set arvore_decisao=get_prismas_analise_filial(rec_prod.filial,idproduto,rec_prod.data::date) where filial =rec_prod.filial and idproduto =rec_prod.idproduto and data = rec_prod.data::date;

  end loop;

end;

$function$

