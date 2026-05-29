CREATE OR REPLACE FUNCTION public.get_temp_ressup_filial(p_filial numeric, idprod character varying)
 RETURNS double precision
 LANGUAGE plpgsql
AS $function$
declare 
    tempo_ressuprimento_mes float;
    filial_matriz int8;
    grupo_matriz int8;
    compra_matriz varchar;
    lim_inf numeric;
    lim_sup numeric;
begin 

	       
 --Busca Tempo Pela Matriz
     
  select compra_unificada into compra_matriz from cfgsystem c;
  
      if compra_matriz = 'S' then 
 
      select filial,id_grupo into filial_matriz, grupo_matriz  from grupo_filial gf  where matriz ='S';
     
       select floor((q1-(1.5*iqr)))linf ,ceil((q3+(1.5*iqr)))lisup 
   		 into lim_inf,lim_sup
			   from (     
			   select 
			   avg(saidas) media,
			   percentile_cont(0.25) within group (order by u.saidas) q1,
			   percentile_cont(0.5) within group (order by u.saidas) q2,
			   percentile_cont(0.75) within group (order by u.saidas) q3,
			   percentile_cont(0.75) within group (order by u.saidas) - percentile_cont(0.25) within group (order by u.saidas) iqr
			    from(  select tempo_ressuprimento as saidas from analise_requisicoes where filial in (select filial from grupo_filial gf where gf.id_grupo = grupo_matriz) and idproduto = idProd   
 	                     and atraso = 0 and qtde > 0 and data_solicitacao between current_date -180 and current_date)u) r;
 	                    
 	      if lim_inf < 0 then  lim_inf=0; end if;   
 	      if lim_sup < 0 then  lim_sup=0; end if;     
      
      select coalesce(round(avg(tempo_ressuprimento)/30,2),1.17) into tempo_ressuprimento_mes from analise_requisicoes where filial in (select filial from grupo_filial gf where gf.id_grupo = grupo_matriz) 
        and idproduto = idProd   
     	and atraso = 0 and qtde > 0 and data_solicitacao between current_date -180 and current_date and tempo_ressuprimento between  lim_inf and lim_sup;
     
    else
    
       select floor((q1-(1.5*iqr)))linf ,ceil((q3+(1.5*iqr)))lisup 
   		 into lim_inf,lim_sup
			   from (     
			   select 
			   avg(saidas) media,
			   percentile_cont(0.25) within group (order by u.saidas) q1,
			   percentile_cont(0.5) within group (order by u.saidas) q2,
			   percentile_cont(0.75) within group (order by u.saidas) q3,
			   percentile_cont(0.75) within group (order by u.saidas) - percentile_cont(0.25) within group (order by u.saidas) iqr
			    from(  select tempo_ressuprimento as saidas from analise_requisicoes where filial = p_filial and idproduto = idProd   
 	                     and atraso = 0 and qtde > 0 and data_solicitacao between current_date -180 and current_date)u) r;
 	                    
 	      if lim_inf < 0 then  lim_inf=0; end if;   
 	      if lim_sup < 0 then  lim_sup=0; end if;    
    
    
      select coalesce(round(avg(tempo_ressuprimento)/30,2),1.17) into tempo_ressuprimento_mes from analise_requisicoes where filial = p_filial and idproduto = idProd   
 		and atraso = 0 and qtde > 0 and data_solicitacao between current_date -180 and current_date and tempo_ressuprimento between  lim_inf and lim_sup;
    
    
  end if;  
          
  
 --Tempo Padrão 2 meses caso não tenha comportamento 
 
  tempo_ressuprimento_mes=coalesce(nullif(tempo_ressuprimento_mes,0),1.17); 
      
    
  return tempo_ressuprimento_mes;

end;

$function$

