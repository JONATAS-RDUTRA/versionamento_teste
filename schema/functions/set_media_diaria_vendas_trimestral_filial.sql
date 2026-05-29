CREATE OR REPLACE FUNCTION public.set_media_diaria_vendas_trimestral_filial(p_filial numeric, idprod character varying, data_venda date)
 RETURNS void
 LANGUAGE plpgsql
AS $function$

declare 

    media numeric;

    media_diaria numeric;

    desvio_padrao_tri numeric;

    cof_var numeric;

    primeiro_consumo numeric;

begin 

	

   -- Tempo Primeiro Consumo



	select current_date- min(emissao) into  primeiro_consumo from consumos where filial = p_filial and idproduto=idprod;



   -- Calculo de Desvio Padrao do Trimestre (mes)

      select get_stddev_consumo(p_filial,idprod,data_venda) into desvio_padrao_tri;
   

	  /*    SELECT coalesce(round(cast(stddev_pop(saidas) as numeric), 2), 0)

	      into desvio_padrao_tri

	 		 from (SELECT to_char(emissao, 'YYYYMM') AS mes,sum(qtde) AS saidas

         FROM consumos c

      		WHERE c.filial = p_filial     

            and c.idproduto = idprod

            AND c.emissao BETWEEN (data_venda - 90) AND data_venda

        group by mes)com;*/

	       

	       

   -- Media de Consumos 90 dias Corrido

      select get_cmm_filial(p_filial,idprod,data_venda) into media;
   

  /*  SELECT coalesce(round(cast(sum(saidas)/(abs( case when abs(datediff('mm',cast(to_char(data_venda,'YYYYMMDD') as date), cast(min(mes)||'01' as date)))+1 > 3 then 3 

	 when abs(datediff('mm',cast(to_char(data_venda,'YYYYMMDD') as date), cast(min(mes)||'01' as date)))+1 < 3 and primeiro_consumo >= 90 then 3                                                       

	 else abs(datediff('mm',cast(to_char(data_venda,'YYYYMMDD') as date), cast(min(mes)||'01' as date)))+1 end ))as numeric) ,2),0)

	  into media

	 FROM ( SELECT to_char(emissao, 'YYYYMM') AS mes,to_char(emissao, 'YYYYMMDD') AS dia, sum(qtde) AS saidas

	      FROM consumos

	      WHERE consumos.filial = p_filial and consumos.idproduto = idprod

	            AND emissao BETWEEN (data_venda - 90) AND data_venda

	      GROUP BY mes,dia) com;*/

  



   	if media > 0 then --Média do trimestre 

   

   

        cof_var = coalesce(round(desvio_padrao_tri / media,4),0) ;





 		if cof_var >= 1.5 then

 

    		media = media + desvio_padrao_tri;

    		media_diaria =  coalesce(round(media/30,2),0);

 

  			else

  

    		media_diaria =  coalesce(round(media/30,2),0);

 

  		end if; 

   



        update saldo_filiais set media_trimestre=media,media_diaria_trimestre=media_diaria,desvio_padrao_trimestre=desvio_padrao_tri,coeficiente_variacao=cof_var,processamento=current_timestamp where filial= p_filial and idproduto = idprod and "data"=data_venda;

       

    

    elsif media = 0 then -- Media do trimestre anterior

    

    

       

        update saldo_filiais set media_trimestre=0,

                          media_diaria_trimestre=0,

                          desvio_padrao_trimestre=0,

                          coeficiente_variacao=0,

                          processamento=current_timestamp where filial= p_filial and idproduto = idprod and "data"=data_venda;

  

    

   end if;

    



end;



$function$

