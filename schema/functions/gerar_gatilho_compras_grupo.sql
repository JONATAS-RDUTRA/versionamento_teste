CREATE OR REPLACE FUNCTION public.gerar_gatilho_compras_grupo()
 RETURNS void
 LANGUAGE plpgsql
AS $function$
declare 

  rec_prod record;
  existe numeric;
  tmp_forecast int4;
 
begin

 -- Em gatilho de Compra 
 	
  for rec_prod in (select id_grupo,idproduto,'CP' as tipo,round(estoque::numeric,4) estoque,ceil(lote_compras) as sugestao,ponto_pedido,tempo_ressuprimento,desvio_padrao_ressuprimento,arvore_decisao
					   FROM produtos_compras_grupo vgcp
					     JOIN departamentos dpto ON dpto.iddepartamento = vgcp.idfamilia_produto
					  WHERE vgcp.lote_compras > 0::numeric AND vgcp.sob_encomenda = 0 
					       AND vgcp.revenda::text = 'S'::text 
					       AND vgcp.revenda::text <> 'FL'::text 
					       AND dpto.descricao_departamento::text !~~ '%FEIRAO%'::text 
					       AND dpto.descricao_departamento::text !~~ '%AVARIA%'::text
 					 )
  loop
  
          
      
           select count(*) into existe from hist_gatilho_compras_grupo where grupo=rec_prod.id_grupo and idproduto=rec_prod.idproduto and tipo='CP' and status='A';
          
           if existe = 0 then 
           
               INSERT INTO hist_gatilho_compras_grupo
				(grupo, idproduto, "data", tipo, status, estoque, ponto_pedido, sugestao, arvore_decisao, tempo_reposicao, std_dv_tempo_reposicao)
				VALUES(rec_prod.id_grupo,rec_prod.idproduto,current_date,rec_prod.tipo, 'A'::character varying,rec_prod.estoque,rec_prod.ponto_pedido,
			            rec_prod.sugestao,rec_prod.arvore_decisao,rec_prod.tempo_ressuprimento, rec_prod.desvio_padrao_ressuprimento);
                    
           end if;
 

  end loop;
 
 -- Em gatilho de Compra Transito
 
 for rec_prod in (SELECT t.id_grupo,
				    'TR'::text AS tipo,
				    t.idproduto,
				    round(t.estoque::numeric,4) as estoque,
				    ceil(t.lote_compras) AS sugestao
				   FROM produtos_transito t
				  WHERE t.lote_compras > 0::double precision)
  loop
  
          
           select count(*) into existe from hist_gatilho_compras_grupo where grupo=rec_prod.id_grupo and idproduto=rec_prod.idproduto and tipo='TR' and status='A';
          
           if existe = 0 then 
           
               INSERT INTO hist_gatilho_compras_grupo
				(grupo, idproduto, "data", tipo, status, estoque, sugestao)
				VALUES(rec_prod.id_grupo,rec_prod.idproduto,current_date,rec_prod.tipo, 'A'::character varying,rec_prod.estoque,rec_prod.sugestao);
                    
           end if;
 

  end loop;
 
 -- Em Forecast
 

 
 for rec_prod in (SELECT t.id_grupo,
				    t.idfornecedor,
				    'FC'::text AS tipo,
				    t.idproduto,
				    round(t.estoque::numeric,4) as estoque ,
				    ceil(t.lote_compras) AS sugestao
				   FROM produtos_forecast t)
  loop
  
           select f.tempo_forecast  into tmp_forecast from fornecedor f  where f.id = rec_prod.idfornecedor;
  
          
           select count(*) into existe from hist_gatilho_compras_grupo where grupo=rec_prod.id_grupo and idproduto=rec_prod.idproduto and tipo='FC' and status='A';
          
           if existe = 0 then 
           
               INSERT INTO hist_gatilho_compras_grupo
				(grupo, idproduto, "data", tipo, status, estoque, sugestao)
				VALUES(rec_prod.id_grupo,rec_prod.idproduto,(current_date+tmp_forecast),rec_prod.tipo, 'A'::character varying,rec_prod.estoque,rec_prod.sugestao);
                    
           end if;
 

  end loop;
 
 -- Fechamento do Gatilho por Pedido de Compras 
 
 for rec_prod in (select
					    distinct 
						gf.id_grupo,
						pf.idproduto,
						ultima_riquisicao_entrada ,
						data_ultima_riquisicao
					from
						produtos_filial pf
					inner join grupo_filial gf on
						gf.filial = pf.filial
					where
						status_suprimento_sku = 'AGUARDANDO ENTRADA')
  loop
          
   
         UPDATE public.hist_gatilho_compras_grupo SET status='F', idrequisicao=rec_prod.ultima_riquisicao_entrada::numeric,data_requisicao=rec_prod.data_ultima_riquisicao 
          WHERE grupo=rec_prod.id_grupo and idproduto=rec_prod.idproduto AND status='A' and "data" <= rec_prod.data_ultima_riquisicao;

  end loop;
 
 -- Fechamento de itens por sairem de momento de compras

 for rec_prod in (select
						grupo,
						idproduto,
						0 as ultima_riquisicao_entrada ,
						current_date as data_ultima_riquisicao
					from
						hist_gatilho_compras_grupo hgcg
					where
						(grupo,
						idproduto ) in (
						select
							id_grupo ,
							idproduto
						from
							produtos_compras_grupo vgcp
						where
							lote_compras = 0)
						and status = 'A')
  loop
          
   
         UPDATE public.hist_gatilho_compras_grupo SET status='F', idrequisicao=rec_prod.ultima_riquisicao_entrada::numeric,data_requisicao=rec_prod.data_ultima_riquisicao 
          WHERE grupo=rec_prod.grupo and idproduto=rec_prod.idproduto AND status='A' and "data" <= rec_prod.data_ultima_riquisicao;

  end loop;
 
 
  --Limpando Itens em Forecast que já sairam e mudaram para categoria;
 
   delete from hist_gatilho_compras_grupo where (grupo,idproduto) not in (SELECT t.id_grupo,t.idproduto FROM produtos_forecast t) and status='A' and tipo='FC';
 
 --Limpando Itens em Transito que já sairam e mudaram para outra categoria; 
 
   delete from hist_gatilho_compras_grupo where (grupo,idproduto) not in (select id_grupo,idproduto FROM produtos_transito ) and status='A' and tipo='TR'; 


end;


$function$

