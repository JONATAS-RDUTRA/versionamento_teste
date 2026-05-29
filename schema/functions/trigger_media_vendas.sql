CREATE OR REPLACE FUNCTION public.trigger_media_vendas()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
declare

    media numeric;
    media_diaria numeric;
    desvio_padrao_tri numeric;
    cof_var numeric;
    primeiro_consumo numeric;
    prisma varchar;

begin 


   -- Tempo Primeiro Consumo

	select current_date- min(emissao) into  primeiro_consumo from consumos where filial = new.filial and idproduto=new.idproduto;

   -- Calculo de Desvio Padrao do Trimestre (mes)

    select get_stddev_consumo(new.filial,new.idproduto,new.data) into desvio_padrao_tri;
  
   -- Media de Consumos 90 dias Corrido

    select get_cmm_filial(new.filial,new.idproduto,new.data) into media;
   
   --Prisma 
   
   
    if new.arvore_decisao is null then 
     
        select coalesce(arvore_decisao,'CX2R') into prisma from prismas_filiais pf  where filial=new.filial and idproduto= new.idproduto and data_ref = date_trunc('month',new.data);
    
        new.arvore_decisao = prisma;
       
    end if;
   

   	if media > 0 then --Média do trimestre 

        cof_var = coalesce(round(desvio_padrao_tri / media,4),0) ;

 		if cof_var >= 1.5 then


    		media = media + desvio_padrao_tri;

    		media_diaria =  coalesce(round(media/30,2),0);

  			else
  			
    		media_diaria =  coalesce(round(media/30,2),0);

  		end if; 
  	
        new.media_trimestre=media;
        new.media_diaria_trimestre=media_diaria;
        new.desvio_padrao_trimestre=desvio_padrao_tri;
        new.coeficiente_variacao=cof_var;
        new.processamento=current_timestamp;
       

    elsif media = 0 then -- Media do trimestre anterior

        new.media_trimestre=0;
        new.media_diaria_trimestre=0;
        new.desvio_padrao_trimestre=0;
        new.coeficiente_variacao=0;
        new.processamento=current_timestamp;
       

   end if;

    
RETURN NEW;

end;

$function$

