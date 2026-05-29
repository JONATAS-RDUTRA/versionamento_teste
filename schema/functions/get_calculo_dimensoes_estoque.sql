CREATE OR REPLACE FUNCTION public.get_calculo_dimensoes_estoque(idprod character varying, arv_decisao character varying, dataref date DEFAULT ('now'::text)::date)
 RETURNS TABLE(estoque_seguranca numeric, estoque numeric, ponto_pedido numeric, estoque_maximo numeric, consumo_medio numeric, sugestao numeric)
 LANGUAGE plpgsql
AS $function$
declare
  fes  numeric;
  cmm  numeric;
  eseg numeric;
  ppd  numeric;
  emax numeric;
  temp_ressup numeric;
  sdv_ressup numeric;
  sdv_csm numeric;
  perfil varchar;
  lote_compras numeric;
  est numeric;
  lote_min numeric;
  
begin
		
  select
	coalesce(saldos.tempo_ressuprimento,produtos.tempo_ressuprimento),
	coalesce(saldos.desvio_padrao_ressuprimento,produtos.desvio_padrao_ressuprimento),
	getFes(arv_decisao),
	coalesce(getconsumomediomensal(produtos.idproduto,dataref),0),
	coalesce(getdesviopadraoconsumo(produtos.idproduto,dataref),0),
	perfil_demanda,
	coalesce( saldos.estoque,produtos.estoque),
	coalesce(produtos.lote_minimo,1)
   into temp_ressup,sdv_ressup,fes,cmm,sdv_csm,perfil,est,lote_min
  from produtos
   left join saldos 
     on saldos.idproduto = produtos.idproduto
     and saldos."data" = dataref
  where produtos.idproduto = idprod;

   --invalidar cortes maiores que a saida
   
    if cmm <= 0 then cmm = 0; end if; 
    if est <= 0 then est = 0; end if; 
    
 
   --Estoque de Segurança
   
    if sdv_csm = 0 then
    
       eseg =  round((cmm * fes),2) ;
       
     else
     
       eseg =  round((sdv_csm * fes),2) ;
    
     end if;
    
     if perfil = 'OCASIONAL' then
     
        eseg =  round(((cmm/2) * fes),2) ;
     
     end if;
   
    
   
   --Ponto de Pedido;
   
    ppd = round((eseg + (cmm * (temp_ressup+ sdv_ressup))),2);
   
   --Estoque Máximo
   
    emax =ppd + cmm +sdv_csm;

   --Lote de Compras
   
    if perfil <> 'OCASIONAL' then
    
        
        lote_compras = (round((emax+(cmm*(temp_ressup+sdv_ressup))-est)-cmm,2));
       
    
      else
      
       ppd = round((eseg + ((cmm/2) * (temp_ressup+ sdv_ressup))),2);
       emax =ppd + (cmm/2) +sdv_csm;
       lote_compras =  ceil((cmm/2));
    
    end if;


    if lote_compras <= 0 then lote_compras = 0; end if; 
   
    if cmm <= 0 then
      
     	estoque_seguranca := 0;
    	estoque_maximo := 0;
    	ponto_pedido := 0;
    	consumo_medio := 0;
    	sugestao := 0;
        estoque := est;
    
      else 
      
        estoque_seguranca := eseg;
        estoque_maximo := emax;
    	ponto_pedido := ppd;
    	consumo_medio := cmm;
        
        if est <= ppd and cmm > 0 then 
        
    	   sugestao := gerar_lote_embalagem(lote_compras,lote_min);
    	  
    	  else
    	  
    	   sugestao := 0;
    	  
    	end if;  
    
        estoque := est;
      
      
    
    end if;
   

 
 
  return next;


end;

$function$

