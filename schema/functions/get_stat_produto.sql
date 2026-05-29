CREATE OR REPLACE FUNCTION public.get_stat_produto(p_filial numeric, idprod character varying, tempo_dias numeric DEFAULT 30)
 RETURNS TABLE(t_q1 numeric, t_q3 numeric, t_iqr numeric, t_limite_inferior numeric, t_limite_superior numeric)
 LANGUAGE plpgsql
AS $function$ 
declare 

qt_1 numeric;
qt_3 numeric;
vl_iqr numeric;
lim_inf numeric;
lim_sup numeric;

begin

   select q1,q3,iqr,floor((q1-(1.5*iqr)))linf ,ceil((q3+(1.5*iqr)))lisup 
	    into qt_1,qt_3,vl_iqr,lim_inf,lim_sup
   from (     
   select 
   avg(saidas) media,
   percentile_cont(0.25) within group (order by u.saidas) q1,
   percentile_cont(0.5) within group (order by u.saidas) q2,
   percentile_cont(0.75) within group (order by u.saidas) q3,
   percentile_cont(0.75) within group (order by u.saidas) - percentile_cont(0.25) within group (order by u.saidas) iqr
    from(            
         
      with tempo as (
         select distinct to_char(day :: date, 'YYYYMMDD') as referencia
         FROM generate_series(current_date - tempo_dias::integer , current_date, '1 day') day 
         order by to_char(day :: date, 'YYYYMMDD'))

		SELECT
			 t.referencia AS mes,
			coalesce(sum(c.qtde),0) AS saidas
		from tempo t
		left join consumos c
		     on c.filial =  p_filial
			and c.idproduto = idprod
		    and to_char(c.emissao , 'YYYYMMDD') = t.referencia
		WHERE
			c.filial =  p_filial
			and c.idproduto = idprod
			AND c.emissao BETWEEN (current_date - tempo_dias::integer) AND current_date
		GROUP BY
			t.referencia    		
	
		)u)a;     
	
	   if lim_inf < 0 then lim_inf=0; end if;
	   if lim_sup < 0 then lim_sup=0; end if;
	
	
	   t_q1:=qt_1;
	   t_q3:=qt_3;
	   t_iqr:=vl_iqr;
	   t_limite_inferior:=lim_inf;
	   t_limite_superior:=lim_sup;



return next;
end;

$function$

