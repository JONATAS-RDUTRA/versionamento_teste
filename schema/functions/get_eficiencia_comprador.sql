CREATE OR REPLACE FUNCTION public.get_eficiencia_comprador(id numeric, p_grupo bigint DEFAULT 1)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$
declare 
    total_ocorencias numeric;
    total numeric;
    rec_percepcao record;
    qualidade_estoque numeric;
   
begin 

   total=0;
   	
   select count(*)  into total_ocorencias from analise_percepcao_compras_grupos where id_grupo=p_grupo and  idcomprador=id and data_solicitacao between first_day(current_date)  and last_day(current_date) and status_percepcao not in ('PRIMEIRA COMPRA');
  
   for rec_percepcao in (select status_percepcao,count(*) ocorrencia from analise_percepcao_compras_grupos where id_grupo=p_grupo and idcomprador=id and data_solicitacao between first_day(current_date)  and last_day(current_date) group by status_percepcao)
    loop
    
     if rec_percepcao.status_percepcao in ('PERCEPCAO COM SUTIL PREMATURIDADE','PERCEPCAO EM PONTO DE PEDIDO') then 
     
       total = total +((rec_percepcao.ocorrencia/total_ocorencias));
     
     end if;
    
    end loop;
   
   
    -- Metrica Qualidade do Estoque
    
    select
        (((count(*) filter (where estoque >= ponto_pedido))::numeric/nullif(count(*)::numeric, 0))) 
      into qualidade_estoque  
    from vw_grupo_compras_produtos_mt g
    where id_grupo=p_grupo and g.idcomprador = id;
 

    return (total*qualidade_estoque);

end;

$function$

