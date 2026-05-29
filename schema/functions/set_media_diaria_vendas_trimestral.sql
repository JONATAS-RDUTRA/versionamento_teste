CREATE OR REPLACE FUNCTION public.set_media_diaria_vendas_trimestral(idprod character varying, data_venda date)
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

	select current_date- min(emissao) into  primeiro_consumo from consumos where idproduto=idprod;

   -- Calculo de Desvio Padrao do Trimestre (mes)
    /*select   coalesce(round(stddev_pop(total) :: numeric, 2),0) 
 			  into desvio_padrao_tri
			from (
  					SELECT sum(saidas) total
						from saldos
					where idproduto = idprod
				    and ano = date_part('year', data_venda)
 				    and trimestre = date_part('quarter',data_venda)
 			        and data >= (select min(data) from saldos where idproduto = idprod and saidas > 0)
					group by saldos.mes)a;*/	

      /*select coalesce(round(((avg(total) :: numeric)), 2),0) 
        into media 
        	from (
				select sum(saidas) as total
					from saldos
				where idproduto = idprod
 				and ano = date_part('year',data_venda)
 				and trimestre = date_part('quarter', data_venda)
 				and data >= (select min(data) from saldos where idproduto = idprod and saidas > 0)
			 group by mes) b;*/

			SELECT coalesce(round(cast(stddev_pop(saidas) as numeric), 2), 0)
     			 into desvio_padrao_tri
			  from (select mes,sum(saidas) as saidas from (SELECT to_char(emissao, 'YYYYMM') AS mes,to_char(emissao, 'YYYYMMDD') AS dia, sum(qtde)-coalesce(qtde_corte,0) AS saidas
			      FROM consumos
			      left join (
			         select  idproduto,to_char(data,'yyyymmdd') cod_mes,sum(qtde) as qtde_corte from cortes 
			             where data between (data_venda - 90) AND data_venda and cortes.idproduto=idprod
			             group by idproduto,cod_mes
			      ) as corte
			       on corte.cod_mes = to_char(emissao, 'YYYYMMdd')
			       and corte.idproduto = consumos.idproduto
			      WHERE     consumos.idproduto = idprod
			            AND emissao BETWEEN (data_venda - 90) AND data_venda
			      GROUP BY mes,dia,qtde_corte)a  group by a.mes )com;
			
			SELECT coalesce(round(cast(sum(saidas)/(abs( case when abs(datediff('mm',cast(to_char(data_venda,'YYYYMMDD') as date), cast(min(mes)||'01' as date)))+1 > 3 then 3 
			 when abs(datediff('mm',cast(to_char(data_venda,'YYYYMMDD') as date), cast(min(mes)||'01' as date)))+1 < 3 and primeiro_consumo >= 90 then 3                                                       
			 else abs(datediff('mm',cast(to_char(data_venda,'YYYYMMDD') as date), cast(min(mes)||'01' as date)))+1 end ))as numeric) ,2),0)
			  into media
			 FROM ( SELECT to_char(emissao, 'YYYYMM') AS mes,to_char(emissao, 'YYYYMMDD') AS dia, sum(qtde)-coalesce(qtde_corte,0) AS saidas
			      FROM consumos
			      left join (
			         select  idproduto,to_char(data,'yyyymmdd') cod_mes,sum(qtde) as qtde_corte from cortes 
			             where data between (data_venda - 90) AND data_venda and cortes.idproduto=idprod
			             group by idproduto,cod_mes
			      ) as corte
			       on corte.cod_mes = to_char(emissao, 'YYYYMMdd')
			       and corte.idproduto = consumos.idproduto
			      WHERE     consumos.idproduto = idprod
			            AND emissao BETWEEN (data_venda - 90) AND data_venda
			      GROUP BY mes,dia,qtde_corte) com;


   	if media > 0 then --Média do trimestre 
   
   
        cof_var = coalesce(round(desvio_padrao_tri / media,4),0) ;


 		if cof_var >= 1.5 then
 
    		media = media + desvio_padrao_tri;
    		media_diaria =  coalesce(round(media/30,2),0);
 
  			else
  
    		media_diaria =  coalesce(round(media/30,2),0);
 
  		end if; 
   

        update saldos set media_trimestre_ant=0,media_diaria_trimestre_ant=0,media_trimestre=media,media_diaria_trimestre=media_diaria,desvio_padrao_trimestre=desvio_padrao_tri,coeficiente_variacao=cof_var,processamento=current_timestamp where idproduto = idprod and "data"=data_venda;
       
    
    elsif media = 0 then -- Media do trimestre anterior
    
    
       
        update saldos set media_trimestre_ant=0,
                          media_diaria_trimestre_ant=0,
                          media_trimestre=0,
                          media_diaria_trimestre=0,
                          desvio_padrao_trimestre=0,
                          coeficiente_variacao=0,
                          media_anual_corrida=0,
                          media_diaria_anual=0,
                          desvio_padrao_anual=0,
                          processamento=current_timestamp where idproduto = idprod and "data"=data_venda;
    
         -- Calculo de Desvio Padrao do Trimestre (mes)
    
        /*  select   coalesce(round(stddev_pop(total) :: numeric, 2),0) 
 			  into desvio_padrao_tri
			from (
  					SELECT sum(saidas) total
						from saldos
					where idproduto = idprod
				       and cod_trimestre in (select max(cod_trimestre) from saldos
                                               where idproduto= idprod 
                                                and  cod_trimestre < to_char(data_venda,'yyyyq')::numeric)
                        and data >= (select min(data) from saldos where idproduto = idprod and saidas > 0)                         
					group by saldos.mes)a;	*/
    
        
                   
             
        /*  select coalesce(round(((avg(total) :: numeric)), 2),0) 
             into media 
        	from (
				select sum(saidas) as total
					from saldos
				where idproduto = idprod
 			       and cod_trimestre in(select max(cod_trimestre) from saldos
                                    where idproduto= idprod 
                                     and  cod_trimestre < to_char(data_venda,'yyyyq')::numeric)
              and data >= (select min(data) from saldos where idproduto = idprod and saidas > 0)
			 group by mes) b;    */
                                    
                                    
         
        /* if media > 0 then 
         
         
             
             cof_var = coalesce(round(desvio_padrao_tri / media,4),0) ;

         		if cof_var >= 1.5 then
 
            		media = media + desvio_padrao_tri;
            		media_diaria =  coalesce(round(media/30,2),0);
 
            	else
  
           			 media_diaria =  coalesce(round(media/30,2),0);
 
         		end if;
         
         
             update saldos set media_trimestre_ant=media,media_diaria_trimestre_ant=media_diaria,desvio_padrao_trimestre_ant=desvio_padrao_tri,coeficiente_variacao=cof_var,processamento=current_timestamp where idproduto = idprod and "data"=data_venda;
         
           else  -- Media Anual Corrida*/
           
           
             -- Calculo de Desvio Padrao do Trimestre (mes)
    
          /*  select   coalesce(round(stddev_pop(total) :: numeric, 2),0) 
 			  into desvio_padrao_tri
			from (
  					SELECT sum(saidas) total
						from saldos
					where idproduto = idprod
				     	and data  between data_venda - 365  and data_venda
					group by saldos.mes)a;	 
             
           
           
             select  coalesce(round(((avg(saidas) :: numeric)*30), 2),0)
        		into media
    				from saldos
   					where idproduto = idprod
     				and data  between data_venda - 365  and data_venda;
     		
     		
     		  if media > 0 then
     		  
     		        cof_var = coalesce(round(desvio_padrao_tri / COALESCE(NULLIF(media,0), desvio_padrao_tri) ,4),0) ;
     		  
     		    else
     		    
     		        cof_var = 0;
     		  
     		   end if;
   	    

            if cof_var >= 1.2 then
 
            	media = media + desvio_padrao_tri;
            	media_diaria =  coalesce(round(media/30,2),0);
 
            	else
  
            	media_diaria =  coalesce(round(media/30,2),0);
 
         	end if;*/
         
         
            -- Não usar mais Comportamento Anual
          /*     
              media = 0;
              media_diaria = 0;
              cof_var=0;
              desvio_padrao_tri=0;
      
           
             update saldos set media_anual_corrida=media,media_diaria_anual=media_diaria,desvio_padrao_anual=desvio_padrao_tri,coeficiente_variacao=cof_var,processamento=current_timestamp where idproduto = idprod and "data"=data_venda;
           
         end if;  */
    
    
   end if;
    

end;

$function$

