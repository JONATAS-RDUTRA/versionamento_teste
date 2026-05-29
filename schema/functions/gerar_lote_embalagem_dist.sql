CREATE OR REPLACE FUNCTION public.gerar_lote_embalagem_dist(lote numeric, lote_minimo numeric)
 RETURNS numeric
 LANGUAGE plpgsql
AS $function$
declare 

    resto_lote numeric;
    resultado numeric;
   
begin
    
    if coalesce(lote_minimo, 1) = 0 then 
        lote_minimo = 1; 
    end if;

    resto_lote =  CEIL(mod(lote, lote_minimo)) / lote_minimo;
    
    if resto_lote >= 0.5 then 
    
        RETURN (lote_minimo - MOD(lote, lote_minimo)) + lote;
          
    end if;
        
    RETURN lote - MOD(lote, lote_minimo);

end;
$function$

