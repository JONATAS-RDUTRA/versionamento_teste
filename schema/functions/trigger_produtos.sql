CREATE OR REPLACE FUNCTION public.trigger_produtos()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE

cof_variacao numeric;
existe numeric;
resto_lote numeric;
existe_compra numeric;

BEGIN

    new.arvore_decisao = coalesce(NEW.classificacao_financeira,'')||coalesce(NEW.classificacao_criticidade,'')||coalesce(cast(NEW.classificacao_comprabilidade as varchar),'')||coalesce(NEW.classificacao_popularidade,''); 
    new.nivel_servico  = (select getNivelServico(new.arvore_decisao));
    new.fes  = (select getFes(new.arvore_decisao));
    new.manter_estoque  = (select getManterEstoque(new.arvore_decisao));
    new.peso_compras = (select  getPesoCompras(new.arvore_decisao,coalesce(new.classificacao_comprabilidade,0)));

    if new.ressuprimento_manual='S' then
    
          new.tempo_medio_ressuprimento = new.ressuprimento_manual_dias;
          new.tempo_ressuprimento = new.ressuprimento_manual_dias/30;
         new.desvio_padrao_ressuprimento = 0;
    
     else
     
       new.tempo_medio_ressuprimento = (select getTMR(new.idproduto));
       new.tempo_ressuprimento = (select getTempoRessuprimento(new.idproduto));
       new.desvio_padrao_ressuprimento = (select getDesvioPadrao(new.idproduto));
   
    end if;

    
      
    new.desvio_padrao_consumo = (select getDesvioPadraoConsumo(new.idproduto));  
    new.consumo_medio_mensal = (select getConsumoMedioMensal(new.idproduto));  
   
     
   
   --HN

   if new.consumo_medio_mensal > 0 then 
          new.cobertura_estoque = (round(cast( new.estoque/new.consumo_medio_mensal as numeric),2));
          new.coeficiente_variacao = (round(cast((new.desvio_padrao_consumo/new.consumo_medio_mensal) as numeric)*100));
       else 

          new.cobertura_estoque = 0;
          new.coeficiente_variacao = 0;
          new.consumo_medio_mensal = 0 ;
          new.desvio_padrao_consumo = 0;

    end if;
   --
   
   --Perfil Demanda;    

    if cast(new.coeficiente_variacao as numeric) > 0 and  cast(new.coeficiente_variacao as numeric) <= 200 then

       new.perfil_demanda ='REPETITIVO';

     elsif  cast(new.coeficiente_variacao as numeric) > 200  and  cast(new.coeficiente_variacao as numeric) <= 600 then

       new.perfil_demanda ='ESTATISTICO';

     else

       new.perfil_demanda ='OCASIONAL';

    end if; 
    
   
    
    new.estoque_seguranca = ( round(cast( new.desvio_padrao_consumo * new.fes as numeric),2));

    if new.desvio_padrao_consumo = 0 then
    
       new.estoque_seguranca = ( round(cast( new.consumo_medio_mensal * new.fes as numeric),2));
    
    end if;
   
   
   if new.perfil_demanda ='OCASIONAL' then
   
      new.estoque_seguranca = ( round(cast((new.consumo_medio_mensal/2) * new.fes as numeric),2));
   
   end if;
   
   
    
    new.ponto_pedido = round(cast(new.estoque_seguranca + (new.consumo_medio_mensal * (new.tempo_ressuprimento+new.desvio_padrao_ressuprimento))as numeric),2) ;

     




    /*new.perfil_demanda = (select
                                case 
    when ( cast(coeficiente_variacao as numeric) > 0  and cast(coeficiente_variacao as numeric) <= 200 ) then 'REPETITIVO'
    when (cast(coeficiente_variacao as numeric) > 200 and cast(coeficiente_variacao as numeric) <= 600) then 'ESTATISTICO'
    when cast(coeficiente_variacao as numeric) > 600  then 'OCASIONAL' end as perfil
       FROM produtos where idproduto = new.idproduto); */

   /*Alterado para comercio + estoque de segurança - Retirado em 10/02/2019*/

   new.estoque_maximo = (new.ponto_pedido+new.consumo_medio_mensal+new.desvio_padrao_consumo);

   
   new.tempo_medio_apanhe = (select getTMA(new.idproduto));
   
   
   new.ultima_riquisicao_entrada = (select max(id_solicitacao) from vw_requisicoes where cast(idproduto as varchar) =new.idproduto);
   new.data_ultima_riquisicao = (select max(data_solicitacao) from vw_requisicoes where cast(idproduto as varchar)=new.idproduto);
   new.ultimo_pedido_compra = (select max(ordem_compra) from vw_requisicoes where cast(idproduto as varchar)=new.idproduto);
   new.data_ultima_compra = (select max(data_entrada) from vw_requisicoes where cast(idproduto as varchar)=new.idproduto);
   new.status_ultima_compra = (select case when atraso > 0 then 'PENDENTE COM ATRASO DE ' || atraso ||' DIA(S)' else 'ENTRADA CONFIRMADA' end as status  from vw_requisicoes where cast(idproduto as varchar) = new.idproduto  group by atraso order by atraso desc limit 1);
   --Modificado o filtro para data_entrada nula tirando atraso > 0
   
  
   --Verifica se existe compra produto;
   
   select count(*) into existe_compra from vw_requisicoes where cast(idproduto as varchar) = new.idproduto and qtde_pendente > 0;
  
  
   if existe_compra > 0 then 
   
      new.status_suprimento_sku = 'AGUARDANDO ENTRADA';
    
   	 elseif new.estoque <= new.ponto_pedido and new.ponto_pedido > 0 then 
   	 
   	 
   	 	new.status_suprimento_sku = 'RESSUPRIR';
   
   
     else
     
     	new.status_suprimento_sku = 'OK';
     
   end if;
   
  
  
  /* new.status_suprimento_sku = (select case when  (select count(*) from vw_requisicoes where cast(idproduto as varchar) = new.idproduto and qtde_pendente > 0) > 0
                                                then 'AGUARDANDO ENTRADA' when  (new.estoque <= new.ponto_pedido and  new.ponto_pedido > 0)
                                                then 'RESSUPRIR' else 'OK' end  from produtos where idproduto= new.idproduto);*/


  -- Modelos QR - Poisson


  if new.perfil_demanda = 'OCASIONAL' then

    new.taxa_media_poisson = round( cast(new.tempo_medio_apanhe *(new.tempo_ressuprimento*30) as numeric),2);
    new.lote_medio_poisson = (select getLoteMedioQR(new.idproduto)); 
    new.desvio_padrao_poisson = (SQRT(new.taxa_media_poisson)*new.lote_medio_poisson);
    new.estoque_seguranca_poisson = round( cast(new.fes*new.desvio_padrao_poisson as numeric),2);
    new.ponto_pedido_poisson=round( cast((new.lote_medio_poisson*new.taxa_media_poisson)+new.estoque_seguranca_poisson as numeric),2);
    new.estoque_maximo_poisson = round(cast((new.ponto_pedido_poisson+new.lote_medio_poisson) as numeric),2);
   
   new.ponto_pedido = round(cast(new.estoque_seguranca + ((new.consumo_medio_mensal/2) * (new.tempo_ressuprimento+new.desvio_padrao_ressuprimento))as numeric),2) ;
   new.estoque_maximo = (new.ponto_pedido+(new.consumo_medio_mensal/2)+new.desvio_padrao_consumo);

   else
 
     new.taxa_media_poisson = 0;
     new.lote_medio_poisson = 0; 
     new.desvio_padrao_poisson = 0;
     new.estoque_seguranca_poisson = 0;
     new.ponto_pedido_poisson= 0;
     new.estoque_maximo_poisson = 0;
 
   end if;

  -- Lotes de Compra

   if new.perfil_demanda <> 'OCASIONAL'  AND  new.status_suprimento_sku ='RESSUPRIR' THEN

       new.lote_compras = (round(cast((new.estoque_maximo+(new.consumo_medio_mensal*(new.tempo_ressuprimento+new.desvio_padrao_ressuprimento))-new.estoque)-new.consumo_medio_mensal as numeric),2));

      elsif  new.perfil_demanda <> 'OCASIONAL'  AND  new.status_suprimento_sku ='OK' then
      
       new.lote_compras = (round(cast((new.estoque_maximo+(new.consumo_medio_mensal*(new.tempo_ressuprimento+new.desvio_padrao_ressuprimento))-new.estoque)-new.consumo_medio_mensal as numeric),2));
 
   end if;

   -- Ajustar apos calculos de poisson
    IF new.perfil_demanda = 'OCASIONAL'  AND  new.status_suprimento_sku ='RESSUPRIR' THEN

      new.lote_compras = ceil((new.consumo_medio_mensal/2));
 
    END IF;


   IF new.lote_minimo IS NULL THEN

      new.lote_minimo_compras = new.lote_compras;
  
     else
     
      resto_lote =  ceil(mod(new.lote_compras::numeric, new.lote_minimo::numeric))/new.lote_minimo::numeric;
     
      if resto_lote >= 0.5 then 
      
         new.lote_minimo_compras = ((new.lote_minimo::numeric - MOD(new.lote_compras::numeric,new.lote_minimo::numeric))+ new.lote_compras::numeric);
        
        else
        
         new.lote_minimo_compras = ((new.lote_compras::numeric - MOD(new.lote_compras::numeric,new.lote_minimo::numeric)));
        
      end if;
     
      if new.lote_minimo_compras > 0 and new.status_suprimento_sku ='RESSUPRIR' then
      
         new.lote_compras = new.lote_minimo_compras;
      
        elsif new.lote_minimo_compras = 0 and new.status_suprimento_sku ='RESSUPRIR' then
        
         new.status_suprimento_sku ='SOB ENCOMENDA';
      
      end if;
 

   END IF;
  
      new.processamento = current_timestamp;

     
      -- Lógica Gatilho de Compras
      
      if new.status_suprimento_sku = 'RESSUPRIR' and new.revenda='S' and new.status <> 'FL' then 
      
           select count(*) into existe from hist_gatilho_compras where idproduto=new.idproduto and status='A';
          
           if existe = 0 then 
           
               INSERT INTO public.hist_gatilho_compras
                    (idproduto, filial, "data", status, estoque, ponto_pedido, sugestao,arvore_decisao,tempo_reposicao)
                     VALUES(new.idproduto, 0, current_date,'A',new.estoque,new.ponto_pedido,new.lote_compras,new.arvore_decisao,new.tempo_medio_ressuprimento);
                    
           end if;
          
          elsif new.status_suprimento_sku = 'AGUARDANDO ENTRADA' then 
          
          
               UPDATE public.hist_gatilho_compras SET status='F', idrequisicao=new.ultima_riquisicao_entrada::numeric,data_requisicao=new.data_ultima_riquisicao WHERE idproduto=new.idproduto AND status='A';
              
          else
          
              select count(*) into existe from hist_gatilho_compras where idproduto=new.idproduto and status='A';
             
              if existe > 0 then
              
                
                  UPDATE public.hist_gatilho_compras SET status='F', idrequisicao=0 WHERE idproduto=new.idproduto AND status='A';
              
              
              end if;
                      
      
      end if;
     
     new.tempo_gatilho = coalesce((select (current_date - "data") from hist_gatilho_compras where idproduto=new.idproduto and status='A'),0);
                                                  
    
    RETURN NEW;
end
$function$

