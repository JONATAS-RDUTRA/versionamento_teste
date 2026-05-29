CREATE OR REPLACE FUNCTION public.gerar_lote_embalagem(lote numeric, lote_minimo numeric)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$
declare 

    resto_lote numeric;
    resultado numeric;
   
begin
	
	if coalesce(lote_minimo,1) = 0 then lote_minimo=1; end if;
	
	
	resto_lote =  ceil(mod(lote,lote_minimo))/lote_minimo;
	
    if resto_lote >=0.5 then 
    
    
        resultado = ((lote_minimo - MOD(lote,lote_minimo))+ lote);
    
    
      else
      
      
       resultado = ((lote - MOD(lote,lote_minimo)));
      
      
    end if; 
	
		     
    return resultado;

end;

$function$

