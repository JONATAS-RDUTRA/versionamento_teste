CREATE OR REPLACE FUNCTION public.processar_compra_mp()
 RETURNS void
 LANGUAGE plpgsql
AS $function$
declare
 
rec_prod_mp record;
rec_grupo record;
tempo_ressup_mp numeric;
std_tempo_ressup_mp numeric;

begin
	
update produtos_mp set status ='D' where idgrupo in (select id from grupo_compras);

	
for rec_grupo in (select id from grupo_compras gc where id=2)
  loop 
  
     for rec_prod_mp in (
               select 
			    distinct 
				id_fornecedor_materia_prima forn_mp,
				id_produto_materia_prima idproduto_mp,
				descricao_produto,
				round((pf.estoque),2) estoque_mp,
				round((pf.estoque_seguranca),2) estoque_seguranca,
				round((pf.ponto_pedido),2) ponto_pedido,
				round((pf.estoque_maximo),2) emax,
				round((consumo_medio_mensal),2) cmm,
				round((pf.desvio_padrao_consumo),2) std_cmm,
				(select sugestao from vw_lista_compras_dinamica_grupo vlcdg  where id_grupo = rec_grupo.id and idproduto= id_produto_materia_prima) sugestao
				from produtos_pa pp  
				inner join vw_grupo_compras_produtos_mt pf 
				 on pf.idproduto = pp.id_produto_materia_prima 
				where pf.id_grupo= rec_grupo.id
				AND pf.sob_encomenda = 0 
				AND pf.revenda::text = 'S'::text 
				AND pf.revenda::text <> 'FL'::text
				)
				
		 loop 
		 
		   select max(tempo_medio_ressuprimento),sum(desvio_padrao_ressuprimento) into tempo_ressup_mp,std_tempo_ressup_mp 
		        from produtos_filial pf  
		    where pf.filial in (select filial from grupo_filial gf where gf.id_grupo = rec_grupo.id) and pf.idproduto=rec_prod_mp.idproduto_mp;
		 
		 
           UPDATE produtos_mp
			SET estoque=coalesce(rec_prod_mp.estoque_mp,0), emax=rec_prod_mp.emax, cmm=rec_prod_mp.cmm, std_cmm=rec_prod_mp.std_cmm, 
			    tp_ressup=tempo_ressup_mp, std_tp_ressup=std_tempo_ressup_mp,status='', processamento=current_timestamp,sugestao=rec_prod_mp.sugestao
			WHERE idgrupo=rec_grupo.id AND id_fornecedor=rec_prod_mp.forn_mp AND id_produto=rec_prod_mp.idproduto_mp;

		
		   if not found then 
		   
		       
		       INSERT INTO produtos_mp
				(idgrupo, id_fornecedor, id_produto, estoque, emax, cmm, std_cmm, tp_ressup, std_tp_ressup, id_user, data_cadastro, status, processamento,sugestao)
			   VALUES(rec_grupo.id, rec_prod_mp.forn_mp,rec_prod_mp.idproduto_mp,coalesce(rec_prod_mp.estoque_mp,0),rec_prod_mp.emax, rec_prod_mp.cmm,rec_prod_mp.std_cmm,tempo_ressup_mp,
			  std_tempo_ressup_mp,0,current_date,'', current_timestamp,rec_prod_mp.sugestao);
			  
		   
		   end if;

				
	     end loop;
  
  end loop;
 
 delete from  produtos_mp where status ='D';
	
end
$function$

