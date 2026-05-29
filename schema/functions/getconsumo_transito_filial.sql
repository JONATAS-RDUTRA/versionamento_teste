CREATE OR REPLACE FUNCTION public.getconsumo_transito_filial(p_filial numeric, idprod character varying)
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

begin 

   

   select

	amplitude,

	get_cmm_filial(p_filial,idproduto),

	get_stddev_consumo(p_filial,idproduto),

	perfil_demanda,

	estoque

 into amp,cmmd,dv_cmmd,perfil,est

from

	(

	select

		vw_requisicoes.idproduto::varchar,

		data_prevista_cal,

		(case

			when data_previsao is null then (data_prevista_cal - current_date)

			else (data_prevista_cal - current_date)

		end) amplitude,

		perfil_demanda,

		produtos.estoque

	from

		vw_requisicoes

	 inner join produtos_filial  as produtos

   on  produtos.filial =vw_requisicoes.filial and  produtos.idproduto = vw_requisicoes.idproduto::varchar

	where

		vw_requisicoes.idproduto::varchar = idprod and vw_requisicoes.filial = p_filial 

		and data_entrada isnull  order by data_solicitacao desc limit 1)a;

	

	if perfil = 'OCASIONAL' then

	

	   consumo_transito =((cmmd/2))/30;

	

    elsif perfil <>'REPETITIVO' then

      

       consumo_transito = ((cmmd+dv_cmmd)*amp)/30;

    

      else

      

       consumo_transito =((cmmd)*amp)/30;

    

    end if;

   

   if consumo_transito < 0 then consumo_transito=0; end if;

  

  --Remoção demanda Reprimida;

   

   if  coalesce(consumo_transito,0) > est then consumo_transito=est; end if;



    

    return coalesce(consumo_transito,0);



end;



$function$

