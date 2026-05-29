CREATE OR REPLACE FUNCTION public.processar_rentabilidade(p_periodo integer DEFAULT 180)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
declare
 
rec_forn record;

begin
for rec_forn in (select id from fornecedor f where exists (select 'x' from produtos_filial pf  where idfornecedor = f.id) order by id)
  loop 
	 
  perform public.processar_rentabilidade_fornecedor(rec_forn.id::integer,p_periodo);
  
  end loop; 
end
$function$

