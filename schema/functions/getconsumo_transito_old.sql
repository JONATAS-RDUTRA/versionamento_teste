CREATE OR REPLACE FUNCTION public.getconsumo_transito_old(idprod character varying)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$
declare 
    vconsumo_medio_mensal numeric;
    vdesvio_consumo numeric;
    vtempo_ressuprimento numeric;
    vdesvio_ressuprimento numeric;
    status character varying;
    saldo_estoque numeric;
    consumo_transito numeric;
begin 


    select coalesce(consumo_medio_mensal,0),coalesce(desvio_padrao_consumo,0),coalesce(tempo_ressuprimento,0),coalesce(desvio_padrao_ressuprimento,0),perfil_demanda,coalesce(estoque,0) 
           into  vconsumo_medio_mensal,vdesvio_consumo,vtempo_ressuprimento,vdesvio_ressuprimento,status,saldo_estoque 
    from produtos where idproduto=idprod; 

    if status <>'REPETITIVO' then
      
        
       consumo_transito = (vconsumo_medio_mensal+vdesvio_consumo) * (vtempo_ressuprimento+vdesvio_ressuprimento);
    
      else
      
       consumo_transito = (vconsumo_medio_mensal) * (vtempo_ressuprimento+vdesvio_ressuprimento);
    
    end if;

    
    return consumo_transito;

end;

$function$

