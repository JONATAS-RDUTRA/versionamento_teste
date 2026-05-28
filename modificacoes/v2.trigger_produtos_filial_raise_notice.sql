-- DROP FUNCTION public.trigger_produtos_filial();

CREATE OR REPLACE FUNCTION public.trigger_produtos_filial()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$

DECLARE



cof_variacao numeric;

existe numeric;

saldo_drp numeric;

consumo_horizonte numeric;

desvio_consumo_horizonte numeric;

tempo_distribuicao numeric;

compra_pendente numeric;

amplitude numeric;

saldo_futuro numeric;
resto_lote numeric;
ressup_manual varchar;
ressup_qtde_manual numeric;

estoque_real numeric;

cobertura_compras int8;

cobertura_esseg numeric;

rec_analise_requisicoes record;

v_ctx_base text;
   v_ctx_erro text;

begin

 v_ctx_base :=
   format(
      'ERRO | trigger=%s | tabela=%s | operacao=%s | produto=%s | filial=%s',
      TG_NAME,
      TG_TABLE_NAME,
      TG_OP,
      NEW.idproduto,
      NEW.filial
   );

raise notice 'Produto: %' ,new.idproduto;

--	 Estoque Transferencia DRP
	new.estoque_transito_drp = coalesce((
		SELECT sum(GREATEST(v.qtde_item, 0)) 
		FROM produtos_separacao v
		WHERE v.filial_destino = new.filial AND v.idproduto = new.idproduto
	), 0);

	-- Recuperar Comprador pela Carteira de Compradores
	--NEW.idcomprador = get_idcomprador_carteira_comprador(new.filial,new.idproduto);
	
	
	-- Evitar Saldos Negativos no Estoque;
	
    if new.estoque < 0 then new.estoque = 0; end if;
    if new.estoque_bloqueado < 0 then new.estoque_bloqueado = 0; end if;
    if new.estoque_reservado < 0 then new.estoque_reservado = 0; end if;
	
	--Ajuste Ressuprimento Manual
	
	if new.tipo_ressuprimento='F' then 
	
	   select ressuprimento_manual,ressuprimento_qtde_dias  into ressup_manual,ressup_qtde_manual from fornecedor f2 where f2.id=new.idfornecedor;

       new.ressuprimento_manual=coalesce(ressup_manual,'N');
       new.ressuprimento_manual_dias=coalesce(ressup_qtde_manual,0);
	
	end if;
   



    new.arvore_decisao = coalesce(NEW.classificacao_financeira,'')||coalesce(NEW.classificacao_criticidade,'')||coalesce(cast(NEW.classificacao_comprabilidade as varchar),'')||coalesce(NEW.classificacao_popularidade,''); 

	IF length(coalesce(new.arvore_decisao, '')) <> 4 THEN 
		new.arvore_decisao = COALESCE((
			SELECT coalesce(psm.arvore_decisao,'CX2R')
			FROM prismas_filiais psm
			WHERE 
				psm.filial = new.filial
				AND psm.idproduto = new.idproduto
				AND data_ref = to_char(current_date, 'YYYY-MM-01')::date
			LIMIT 1
		), 'CX2R');

		NEW.classificacao_financeira = substring(new.arvore_decisao, 1, 1);
		NEW.classificacao_criticidade = substring(new.arvore_decisao, 2, 1);
		NEW.classificacao_comprabilidade = substring(new.arvore_decisao, 3, 1);
		NEW.classificacao_popularidade = substring(new.arvore_decisao, 4, 1);
	END IF;

    new.nivel_servico  = (select getNivelServico(new.arvore_decisao));

    new.fes  = (select getFes(new.arvore_decisao));

    new.manter_estoque  = (select getManterEstoque(new.arvore_decisao));

    new.peso_compras = (select  getPesoCompras(new.arvore_decisao,coalesce(new.classificacao_comprabilidade,0)));



    if new.ressuprimento_manual='S' then

    

          new.tempo_medio_ressuprimento = new.ressuprimento_manual_dias;

          new.tempo_ressuprimento = new.ressuprimento_manual_dias/30;

          new.desvio_padrao_ressuprimento = 0;

    

     else

     

          new.tempo_medio_ressuprimento = (select get_tmr_filial(new.filial,new.idproduto));

          new.tempo_ressuprimento = (select get_temp_ressup_filial(new.filial,new.idproduto));

          new.desvio_padrao_ressuprimento = (select get_stddev_ressup_filial(new.filial,new.idproduto));

   

    end if;

  

    new.desvio_padrao_consumo = (select get_stddev_consumo(new.filial,new.idproduto,current_date));  

    new.consumo_medio_mensal = (select get_cmm_filial(new.filial,new.idproduto,current_date));  
   
--    Análise Filial Retira DRP 
--    new.desvio_padrao_cons_ret = coalesce(get_stddev_consumo_retira(new.filial,new.idproduto,current_date), 0);  
--    new.cmm_filial_retira = coalesce(get_cmm_filial_retira(new.filial,new.idproduto,current_date), 0);



   if new.consumo_medio_mensal > 0 then 

          new.cobertura_estoque = (round(cast( new.estoque/new.consumo_medio_mensal as numeric),2));

          new.coeficiente_variacao = (round(cast((new.desvio_padrao_consumo/new.consumo_medio_mensal) as numeric)*100));

       else 



          new.cobertura_estoque = 0;

          new.coeficiente_variacao = 0;

          new.consumo_medio_mensal = 0 ;

          new.desvio_padrao_consumo = 0;



    end if;
   
   

   

    --Perfil Demanda;    



    if cast(new.coeficiente_variacao as numeric) >= 0 and  cast(new.coeficiente_variacao as numeric) <= 200 then



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
  
  
    cobertura_compras = (select get_cobertura_compras_curva(new.filial,new.idproduto));
  
  
    -- Cobertura Manual
  
    if new.cobertura_manual_produto > 0 or cobertura_compras > 0 then
    
     if  cobertura_compras > 0 then new.cobertura_manual_produto = cobertura_compras; end if;
    
     	--new.estoque_seguranca = ((new.consumo_medio_mensal/30)*new.cobertura_manual_produto)*0.30;
     	new.estoque_seguranca = (new.consumo_medio_mensal*0.30);
    
    end if;

   

   -- cobertura manual do eseg
   cobertura_esseg = (SELECT get_cobertura_esseg(NEW.filial, NEW.idproduto));

    IF NEW.status_tempo_esseg > 0 AND cobertura_esseg > 0 THEN

        NEW.estoque_seguranca = (NEW.consumo_medio_mensal::numeric / 30::numeric) * cobertura_esseg;

    END IF;

  

    

    new.ponto_pedido = round(cast(new.estoque_seguranca + (new.consumo_medio_mensal * (new.tempo_ressuprimento+new.desvio_padrao_ressuprimento))as numeric),2) ;



   



   /*Alterado para comercio + estoque de segurança - Retirado em 10/02/2019*/



   new.estoque_maximo = (new.ponto_pedido+new.consumo_medio_mensal);
  
  
  
  
  --Cobertura Manual
   
    if new.cobertura_manual_produto > 0 or cobertura_compras > 0 then
    
       	
    
    	if  ((new.consumo_medio_mensal/30)*new.cobertura_manual_produto) > new.ponto_pedido then
    	
    	
    	
    	    new.estoque_maximo = ((new.consumo_medio_mensal/30)*new.cobertura_manual_produto); 
    	   
    	   
    	   else 
    	   
    	   
    	   -- Cobertura Máxima atribuida ao item e inferior ao tempo de reposição do mesmo;
    	   
   
    	   new.estoque_maximo = (new.ponto_pedido+new.consumo_medio_mensal);
    	   
    	   
    	
    	end if;
    
    
      else
      
      
       new.estoque_maximo = (new.ponto_pedido+new.consumo_medio_mensal);
    
    end if;





   

   new.tempo_medio_apanhe = (select get_tma_filial(new.filial,new.idproduto,current_date));

   

   

    /*
   new.ultima_riquisicao_entrada = (select max(id_solicitacao) from vw_requisicoes where cast(idproduto as varchar) =new.idproduto);
   new.data_ultima_riquisicao = (select max(data_solicitacao) from vw_requisicoes where cast(idproduto as varchar)=new.idproduto);
   new.ultimo_pedido_compra = (select max(ordem_compra) from vw_requisicoes where cast(idproduto as varchar)=new.idproduto);
   new.data_ultima_compra = (select max(data_entrada) from vw_requisicoes where cast(idproduto as varchar)=new.idproduto);
   */
   
   new.status_ultima_compra = (select case when atraso > 0 then 'PENDENTE COM ATRASO DE ' || atraso ||' DIA(S)' else 'ENTRADA CONFIRMADA' end as status  from vw_requisicoes where cast(idproduto as varchar) = new.idproduto  group by atraso order by atraso desc limit 1);

    SELECT
        max(v.id_solicitacao) AS id_solicitacao,
        max(v.data_solicitacao) AS data_solicitacao,
        max(v.ordem_compra) AS ordem_compra,
        max(v.data_entrada) AS data_entrada
        INTO rec_analise_requisicoes
    FROM vw_requisicoes v
    WHERE v.idproduto = new.idproduto;

    new.ultima_riquisicao_entrada = rec_analise_requisicoes.id_solicitacao;
    new.data_ultima_riquisicao = rec_analise_requisicoes.data_solicitacao;
    new.ultimo_pedido_compra = rec_analise_requisicoes.ordem_compra;
    new.data_ultima_compra = rec_analise_requisicoes.data_entrada;
   
   --Modificado o filtro para data_entrada nula tirando atraso > 0

   new.status_suprimento_sku = (select case when  (select count(*) from vw_requisicoes where idproduto = new.idproduto and qtde_pendente > 0 and vw_requisicoes.filial=new.filial) > 0

                                                then 'AGUARDANDO ENTRADA' when (new.estoque <= new.ponto_pedido and  new.ponto_pedido > 0)

                                                then 'RESSUPRIR' else 'OK' end  from produtos_filial where idproduto= new.idproduto and filial = new.filial);
                                                
                                                
                                             





  -- Modelos QR - Poisson





  if new.perfil_demanda = 'OCASIONAL' then



    new.taxa_media_poisson = round( cast(new.tempo_medio_apanhe *(new.tempo_ressuprimento*30) as numeric),2);

    new.lote_medio_poisson = (select getLoteMedioQR(new.idproduto)); 

    new.desvio_padrao_poisson = (SQRT(new.taxa_media_poisson)*new.lote_medio_poisson);

    new.estoque_seguranca_poisson = round( cast(new.fes*new.desvio_padrao_poisson as numeric),2);

    new.ponto_pedido_poisson=round( cast((new.lote_medio_poisson*new.taxa_media_poisson)+new.estoque_seguranca_poisson as numeric),2);

    new.estoque_maximo_poisson = round(cast((new.ponto_pedido_poisson+new.lote_medio_poisson) as numeric),2);

   

   new.ponto_pedido = round(cast(new.estoque_seguranca + ((new.consumo_medio_mensal/2) * (new.tempo_ressuprimento+new.desvio_padrao_ressuprimento))as numeric),2) ;

   new.estoque_maximo = (new.ponto_pedido+(new.consumo_medio_mensal/2));
  
  
    if new.cobertura_manual_produto > 0 or cobertura_compras > 0 then
    
       	
    
    	if  (((new.consumo_medio_mensal/2)/30)*new.cobertura_manual_produto) > new.ponto_pedido then
    	
    	
    	    new.estoque_maximo = (((new.consumo_medio_mensal/2)/30)*new.cobertura_manual_produto); 
    	   
    	   
    	   else 
    	   
    	   
    	   -- Cobertura Máxima atribuida ao item e inferior ao tempo de reposição do mesmo;
    	   
    	   
    	   new.estoque_maximo = (new.ponto_pedido+(new.consumo_medio_mensal/2));
    	   
    	   
    	
    	end if;
    
    
      else
      
      
       new.estoque_maximo = (new.ponto_pedido+(new.consumo_medio_mensal/2));
    
    end if;




   else

 

     new.taxa_media_poisson = 0;

     new.lote_medio_poisson = 0; 

     new.desvio_padrao_poisson = 0;

     new.estoque_seguranca_poisson = 0;

     new.ponto_pedido_poisson= 0;

     new.estoque_maximo_poisson = 0;

 

   end if;

  

  new.lote_compras = 0;

  new.lote_minimo_compras = 0;



  -- Lotes de Compra



   if new.perfil_demanda <> 'OCASIONAL'  AND  new.status_suprimento_sku ='RESSUPRIR' THEN



       new.lote_compras = (round(cast((new.estoque_maximo+(new.consumo_medio_mensal*(new.tempo_ressuprimento+new.desvio_padrao_ressuprimento))-new.estoque) as numeric),2));



      elsif  new.perfil_demanda <> 'OCASIONAL'  AND  new.status_suprimento_sku ='OK' then

      

       new.lote_compras = (round(cast((new.estoque_maximo+(new.consumo_medio_mensal*(new.tempo_ressuprimento+new.desvio_padrao_ressuprimento))-new.estoque) as numeric),2));

 

   end if;



   -- Ajustar apos calculos de poisson

   IF new.perfil_demanda = 'OCASIONAL'  AND  new.status_suprimento_sku ='RESSUPRIR' THEN



      new.lote_compras = ceil((new.consumo_medio_mensal/2));

 

    END IF;

   

   

   --Zera lote compras caso seja < 0

   

   if new.lote_compras < 0 then 

   

  		new.lote_compras=0;

  	

   end if;


   new.lote_minimo = coalesce(nullif(new.lote_minimo::numeric,0),1);


   IF new.lote_minimo IS NULL THEN

      new.lote_minimo_compras = new.lote_compras;
  
     else
     
      resto_lote =  ceil(mod(new.lote_compras::numeric, new.lote_minimo::numeric))/coalesce(nullif(new.lote_minimo::numeric,0),1);
     
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

      

     -- Lógica Gatilho de Compras
      
   /*   if new.status_suprimento_sku = 'RESSUPRIR' and new.revenda='S' and new.status <> 'FL' then 
      
           select count(*) into existe from hist_gatilho_compras where idproduto=new.idproduto and status='A';
          
           if existe = 0 then 
           
               INSERT INTO public.hist_gatilho_compras
                    (idproduto, filial, "data", status, estoque, ponto_pedido, sugestao,arvore_decisao,tempo_reposicao)
                     VALUES(new.idproduto, new.filial, current_date,'A',new.estoque,new.ponto_pedido,new.lote_compras,new.arvore_decisao,new.tempo_medio_ressuprimento);
                    
           end if;
          
          elsif new.status_suprimento_sku = 'AGUARDANDO ENTRADA' then 
          
          
               UPDATE public.hist_gatilho_compras SET status='F', idrequisicao=new.ultima_riquisicao_entrada::numeric,data_requisicao=new.data_ultima_riquisicao WHERE idproduto=new.idproduto AND status='A';
              
          else
          
              select count(*) into existe from hist_gatilho_compras where idproduto=new.idproduto and status='A';
             
              if existe > 0 then
              
                
                  UPDATE public.hist_gatilho_compras SET status='F', idrequisicao=0 WHERE idproduto=new.idproduto AND status='A';
                 
                 else
                 
                  delete from public.hist_gatilho_compras  WHERE idproduto=new.idproduto and  status='F' and idrequisicao=0;
              
              end if;
                      
      
      end if;
     
     new.tempo_gatilho = coalesce((select (current_date - "data") from hist_gatilho_compras where idproduto=new.idproduto and status='A'),0);

     */

     

     --Nível de Estoque

        

     new.nivel_estoque = coalesce(round(new.estoque/nullif(new.estoque_maximo,0),4),0)*100;

    

    

     --DRP

      estoque_real = coalesce(new.estoque,0) - coalesce(new.estoque_bloqueado,0) - coalesce(new.estoque_reservado,0) - coalesce(new.estoque_similar,0);
     

     --Pedido de compra mais antigo

     

     select (data_prevista_cal-current_date),qtde_pendente

       into amplitude,compra_pendente

     from analise_requisicoes r 

       where r.filial::numeric = new.filial 

       and r.idproduto=new.idproduto 

       and r.qtde_pendente > 0  

       and qtde_entregue=0  

       order by data_prevista_cal limit 1; 

      

      compra_pendente = coalesce(compra_pendente,0);

      amplitude = coalesce(amplitude,-1);

      saldo_drp=0;

    

     if new.consumo_medio_mensal = 0 and estoque_real> 0 then

     

       saldo_drp=new.estoque;

    

     elsif new.estoque_maximo <= 0 or estoque_real<= 0 then

     

         saldo_drp=0; 

        

  --   elsif new.estoque < new.ponto_pedido then -- Ajuste Neto

     

     --    saldo_drp=0; 

     

     else

     

       --Nova lógica para disponibilidade estoque para DRP com mercadoria em trânsito

       

        if compra_pendente > 0 and amplitude > 0 and  amplitude < 30 then

        

        

        

            consumo_horizonte=(new.consumo_medio_mensal/30)*amplitude;

            desvio_consumo_horizonte = (new.desvio_padrao_consumo/30)*amplitude;

           

           saldo_futuro = coalesce( estoque_real- consumo_horizonte + desvio_consumo_horizonte + compra_pendente,0);

          

                

          

           if (saldo_futuro - new.ponto_pedido) < 0 then

             

           	   saldo_drp = 0;

          

             elseif (saldo_futuro - new.ponto_pedido) > estoque_real then

           

               saldo_drp = coalesce( ceil(estoque_real - new.estoque_seguranca),0);

              

             else

               

               saldo_drp=coalesce( ceil(estoque_real - new.estoque_seguranca),0);

              

              

           end if;  

              

        

        else

           

           saldo_drp=coalesce( ceil(estoque_real- new.ponto_pedido),0);

        

        end if;

           

     end if;

    

     if saldo_drp < 0 then new.estoque_drp = 0; else new.estoque_drp = saldo_drp; end if;

    

   
    tempo_distribuicao=5;

   

    consumo_horizonte=(new.consumo_medio_mensal/30)*tempo_distribuicao;

    desvio_consumo_horizonte = (new.desvio_padrao_consumo/30)*tempo_distribuicao;

    

    if new.estoque_drp <> 0 then 

    

      new.status_drp ='DISP DRP';

      new.saldo_necessidade_drp =0;

      

      elseif estoque_real<= new.ponto_pedido and new.consumo_medio_mensal > 0 then 

      

      	new.status_drp ='DRP';

        new.saldo_necessidade_drp = ceil((new.estoque_maximo + (consumo_horizonte+desvio_consumo_horizonte)) - (estoque_real+ (new.consumo_medio_mensal/30))) ;
       
          --Embalagem Master - Distribuir 
        
        new.saldo_necessidade_drp = (new.embalagem_master - mod(new.saldo_necessidade_drp,new.embalagem_master))+ new.saldo_necessidade_drp;

      

      

      elseif (estoque_real-(consumo_horizonte+desvio_consumo_horizonte)) <=  new.ponto_pedido  and  new.consumo_medio_mensal > 0 then

      

      	new.status_drp ='ANT DRP';

        new.saldo_necessidade_drp = ceil((new.estoque_maximo + (consumo_horizonte+desvio_consumo_horizonte)) - (estoque_real+ (new.consumo_medio_mensal/30))) ;
       
         --Embalagem Master - Distribuir 
        
        new.saldo_necessidade_drp = (new.embalagem_master - mod(new.saldo_necessidade_drp,new.embalagem_master))+ new.saldo_necessidade_drp;

      

      else

      

      new.status_drp ='OK';

      new.saldo_necessidade_drp =0;

      

    end if;  

   
    -- Preco Médio Vendas 
    
    
    new.preco_medio_venda = get_preco_medio_venda_filial(new.filial,new.idproduto);
   
   -- Análise Financeira
   
   
   new.total_estoque_custo  = coalesce(round(new.custo_unitario*new.estoque,4),0);
   new.total_estoque_venda  = coalesce(round(new.valor_unitario*new.estoque,4),0);
   new.fator_markup = coalesce(round(new.total_estoque_venda/nullif(new.total_estoque_custo,0),4),0);
   new.projecao_venda  = coalesce(round(new.consumo_medio_mensal*new.valor_unitario,4),0);
   new.projecao_rentabilidade = coalesce(round((new.projecao_venda/nullif(new.fator_markup,0)),4),0);
  
 
  

   --Grupo de Compras
   
  
   --new.grupo_compra = coalesce((select id_grupo from grupo_filial gf where gf.filial=new.filial),0);

           
               
    -- produto fica fora de linha quando é herdado por outro    
    IF (SELECT count(*) FROM produtos_filial pf WHERE pf.heranca = NEW.idproduto AND pf.filial = NEW.filial) > 0 THEN
        NEW.status = 'FL';
    END IF;             

    RETURN NEW;

EXCEPTION WHEN OTHERS THEN
   GET STACKED DIAGNOSTICS v_ctx_erro = PG_EXCEPTION_CONTEXT;

   RAISE EXCEPTION
   '% | erro=% | contexto=%',
   v_ctx_base,
   SQLERRM,
   v_ctx_erro;
END;
$function$
;
