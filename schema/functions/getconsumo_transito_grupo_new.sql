CREATE OR REPLACE FUNCTION public.getconsumo_transito_grupo_new(p_grupo numeric, idprod character varying)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$

declare 

    cmmd numeric;

    dv_cmmd numeric;

    perfil character varying;

    amp numeric;

    consumo_transito numeric;

    est numeric;
   
    tempo_ressuprimento numeric;

begin 
    
    
    
      select consumo_medio_mensal,desvio_padrao_consumo,perfil_demanda,estoque,tempo_medio_ressuprimento  
            into cmmd,dv_cmmd,perfil,est,tempo_ressuprimento
      from vw_grupo_compras_produtos_mt vgcp  
      where id_grupo =p_grupo and idproduto=idprod;
 
   

   select

    amplitude

 into amp

from

    (

    select

       (vw_requisicoes.data_solicitacao+produtos.tempo_medio_ressuprimento::int4) - current_date  as  amplitude

    from

        vw_requisicoes

     inner join produtos_filial  as produtos

   on  produtos.filial =vw_requisicoes.filial and  produtos.idproduto = vw_requisicoes.idproduto::varchar

    where

        vw_requisicoes.idproduto::varchar = idprod and vw_requisicoes.filial in (select filial from grupo_filial gf where id_grupo=p_grupo)

        and data_entrada isnull  order by data_solicitacao desc limit 1)a;
    
    
    
    amp= greatest(amp,0);
    

    if perfil = 'OCASIONAL' then

    

       consumo_transito =((cmmd/2))/30;

    

    elsif perfil <>'REPETITIVO' then

      

       consumo_transito = ((cmmd+dv_cmmd)*amp)/30;

    

      else

      

       consumo_transito =((cmmd)*amp)/30;

    

    end if;

   

   if consumo_transito < 0 then consumo_transito=0; end if;

  

    return coalesce(consumo_transito,0);



end;



$function$

