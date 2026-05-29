CREATE OR REPLACE FUNCTION public.getconsumo_provisionado_filial(p_filial numeric, idprod character varying, qtde_dias numeric)
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

    consumo_previsto numeric;

begin 





    select coalesce(consumo_medio_mensal,0),coalesce(desvio_padrao_consumo,0),coalesce(tempo_ressuprimento,0),coalesce(desvio_padrao_ressuprimento,0),perfil_demanda,coalesce(estoque,0) 

           into  vconsumo_medio_mensal,vdesvio_consumo,vtempo_ressuprimento,vdesvio_ressuprimento,status,saldo_estoque 

    from produtos_filial where filial = p_filial and idproduto=idprod; 



    if status <>'REPETITIVO' then

      

        

       consumo_previsto = (vconsumo_medio_mensal+vdesvio_consumo) * ((qtde_dias/30)+(qtde_dias*(vdesvio_ressuprimento/30)));

    

      else

      

       consumo_previsto = (vconsumo_medio_mensal) * ((qtde_dias/30)+(qtde_dias*(vdesvio_ressuprimento/30)));

    

    end if;



    

    return consumo_previsto;



end;



$function$

