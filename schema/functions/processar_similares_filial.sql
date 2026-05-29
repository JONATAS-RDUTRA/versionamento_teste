CREATE OR REPLACE FUNCTION public.processar_similares_filial()
 RETURNS void
 LANGUAGE plpgsql
AS $function$  
declare
 
rec_dados record;
rec_similares record;
estoque_agrupado numeric;
est_temp numeric;
und_venda varchar;
estoque_pai numeric;
estoque_final numeric;
fator_conversao_pai numeric;
existe numeric;
est_similar numeric;
    
begin
	   
 for rec_similares in (select id_item_pai ,id_item_filho,agregar_estoque from similares s where s.agregar_estoque='S'  order by id_item_pai)	
 
 loop 
	   
   for rec_dados in (select id_grupo ,filial from grupo_filial gf order by filial)
     loop 
     
   
		    select coalesce(estoque_temp,0),unidade_compra,fator_conversao into est_temp,und_venda,fator_conversao_pai from produtos_filial pf 
		    	where filial = rec_dados.filial and idproduto = rec_similares.id_item_pai;
		
		   
		    estoque_pai = (select get_estoque_diario_filial(rec_dados.filial,rec_similares.id_item_pai,current_date));
		    
		    est_temp = estoque_pai;
			   
			   if rec_similares.agregar_estoque ='S' then
			   
				       select sum(get_estoque_diario_filial(p.filial,p.idproduto,current_date)*fator_conversao) 
				         into estoque_agrupado
				       from produtos_filial p 
				       where p.filial=rec_dados.filial and  p.idproduto in (select id_item_filho from similares 
				                           where id_item_pai= rec_similares.id_item_pai 
				                          and agregar_estoque='S')
				           and p.unidade_compra = und_venda;

    -- Ajuste feito via migration para agregar o estoque do produto combinado
    estoque_agrupado = coalesce(estoque_agrupado, 0) + coalesce((
        SELECT
            CASE
                WHEN coalesce(p.estoque, 0) < coalesce(get_estoque_similar_produto_combinado(p.id_grupo::int, p.filial::int, p.id_produto_combinado), 0) THEN coalesce(p.estoque, 0) -- devolve apenas estoque, porque o estoque do similar ainda não está sendo considerado
                ELSE GREATEST(coalesce(p.estoque, 0) - coalesce(get_estoque_similar_produto_combinado(p.id_grupo::int, p.filial::int, p.id_produto_combinado), 0), 0) -- estoque do similar está dentro de estoque, por isso ele é subtraido
            END
        FROM produtos_combinados_compras_filial p
        WHERE
            p.filial = rec_dados.filial
            AND p.id_produto_combinado IN (
                SELECT s.id_item_filho
                FROM similares s
                WHERE
                    s.id_item_pai = rec_similares.id_item_pai
                    AND substring(s.id_item_filho, 0, 8) = 'SYSCOMB'
                    AND s.agregar_estoque = 'S'
            )
        LIMIT 1
    ), 0); 
				      
				      
				      estoque_final = coalesce(estoque_agrupado/fator_conversao_pai,0)+ coalesce(estoque_pai,0);
				     
				      est_similar = coalesce(estoque_agrupado/fator_conversao_pai,0);
			   
			     else
			     
			     	  estoque_final=  coalesce(estoque_pai,0);
			     	  est_temp = 0;
			     	  estoque_agrupado=0;
			     	  est_similar = 0;
			   
			   end if;
		 
		       update produtos_filial set estoque = estoque_final,estoque_similar=est_similar,processamento = current_timestamp,estoque_temp=est_temp  where filial=rec_dados.filial and idproduto = rec_similares.id_item_pai;
		      
		      
	   end loop;	

  end loop;	   
 
      
end
  $function$

