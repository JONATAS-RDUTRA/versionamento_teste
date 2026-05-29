CREATE OR REPLACE FUNCTION public.processar_produtos_transito_categoria(p_grupo integer DEFAULT 0, p_departamento character varying DEFAULT '0'::character varying, p_idcategoria character varying DEFAULT '0'::character varying)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
declare

	rec_produtos record;
	rec_transito record;
	rec_pedidos record;

	p_atraso int4;
	qtde_transito_atraso numeric;
	qtde_transito numeric;
	qtde_estoque numeric;
	qtde_saldo  numeric;
	p_ponto_pedido numeric;
	p_sugestao numeric;
	p_emax numeric;
	p_cmm numeric;
	p_tr numeric;
	p_consumo_transito numeric;
	p_consumo_transito2 numeric;
	qtde_saldo_futuro numeric;
	qtde_saldo_futuro_geral numeric;
	qtde_saldo_residual numeric;
	p_status_transito varchar;
	qtde_lote_minimo  numeric;
	qtde_cobertura_futura numeric;
	p_fornecedor int4;
	qtde_dias numeric;
	cont_ped numeric;
	consumo_transito_cal numeric;
	p_data_pedido_ant date;



begin



update produtos_transito_categorias
set flag ='D'
where
	(id_grupo = p_grupo or p_grupo = 0)
	and (iddepartamento = p_departamento or p_departamento = '0')
	and (idcategoria = p_idcategoria or p_idcategoria = '0');

for rec_transito in(
     select
		id_grupo,
		iddepartamento,
		idsecao,
		idcategoria,
		descricao_categoria,
		consumo_medio_mensal,
		desvio_padrao_consumo ,
		estoque,
		ponto_pedido,
		estoque_maximo,
		compra_transito,
		tempo_ressuprimento,
		lote_minimo
	from
		produtos_compras_categorias pcc
	where
		compra_transito > 0
		AND consumo_medio_mensal > 0
		AND (pcc.id_grupo = p_grupo or p_grupo = 0)
		AND (pcc.iddepartamento = p_departamento or p_departamento = '0')
		AND (pcc.idcategoria = p_idcategoria or p_idcategoria = '0')
)
  loop


	  p_atraso=0;
      qtde_transito_atraso =0;
      qtde_transito=0;
      qtde_estoque=0;
      p_sugestao= 0;
      p_consumo_transito =0;
      p_consumo_transito2 = 0;
      qtde_saldo_futuro = 0;
      qtde_lote_minimo = coalesce(rec_transito.lote_minimo,1);
      qtde_cobertura_futura=0;
      consumo_transito_cal = 0;




      --Identificar se o produto tem compra em atraso

       select count(*) into p_atraso  from analise_requisicoes ar
        inner join produtos_filial pf
         on pf.filial  = ar.filial
         and pf.idproduto  = ar.idproduto
	    where ar.filial in(select filial from grupo_filial gf where gf.id_grupo=rec_transito.id_grupo)
	    and pf.idcategoria  = rec_transito.idcategoria::varchar and atraso  >= 0  and qtde_pendente > 0 ;



	    -- Pedidos em atraso;


	   select sum(qtde_pendente)  into qtde_transito_atraso  from analise_requisicoes ar
        inner join produtos_filial pf
         on pf.filial  = ar.filial
         and pf.idproduto  = ar.idproduto
	    where ar.filial in(select filial from grupo_filial gf where gf.id_grupo=rec_transito.id_grupo)
	    and pf.idcategoria  = rec_transito.idcategoria::varchar and qtde_pendente > 0 and atraso >=0;


	    qtde_transito_atraso = coalesce(qtde_transito_atraso,0);

	    --Pedidos em Transito Aberto;

	    select sum(qtde_pendente)  into qtde_transito  from analise_requisicoes ar
        inner join produtos_filial pf
         on pf.filial  = ar.filial
         and pf.idproduto  = ar.idproduto
	    where ar.filial in(select filial from grupo_filial gf where gf.id_grupo=rec_transito.id_grupo)
	    and pf.idcategoria  = rec_transito.idcategoria::varchar and qtde_pendente > 0 and atraso < 0;

	    qtde_transito = coalesce(qtde_transito,0);


	    -- Parâmetros do Estoque;

	    qtde_estoque = rec_transito.estoque;
	    p_ponto_pedido = rec_transito.ponto_pedido;
	    p_emax = rec_transito.estoque_maximo;
	    p_cmm = rec_transito.consumo_medio_mensal;
	    p_tr =  rec_transito.tempo_ressuprimento;


	   --raise notice 'grupo = %',rec_transito.id_grupo;
	   --raise notice 'categoria = %',rec_transito.idcategoria;
	   --raise notice 'p_atraso = %',p_atraso;
	   --raise notice 'qtde_transito_atraso = %',qtde_transito_atraso;
	   --raise notice 'qtde_transito = %',qtde_transito;
	   --raise notice 'qtde_estoque = %',qtde_estoque;
	   --raise notice 'p_ponto_pedido = %',p_ponto_pedido;
	   --raise notice 'p_emax = %',p_emax;
	   --raise notice 'p_cmm = %',p_cmm;
	   --raise notice 'p_tr = %',p_tr;
	   --raise notice 'p_ponto_pedido = %',p_ponto_pedido;


	  p_consumo_transito = 0;

	   for rec_pedidos in (select distinct  gf.id_grupo  ,idproduto from produtos_filial pf
	                          inner join grupo_filial gf
	                           on gf.filial = pf.filial
	                          where gf.id_grupo = rec_transito.id_grupo
	                          and pf.idcategoria = rec_transito.idcategoria and revenda='S' and  status <> 'FL' )
	    loop

		    p_consumo_transito = p_consumo_transito + getconsumo_transito_grupo_new(rec_pedidos.id_grupo,rec_pedidos.idproduto);

		end loop;



	   --raise notice 'p_consumo_transito = %',p_consumo_transito;






	    --Somente itens atrasados

	    if p_atraso > 0 and qtde_transito = 0 then


	        --raise notice 'SOMENTE ATRASADO = %','';



	        qtde_transito = greatest(qtde_transito,0);

	    	qtde_saldo = qtde_estoque + qtde_transito_atraso + qtde_transito;

	        qtde_saldo_residual =  qtde_saldo - p_consumo_transito ;


	        --raise notice 'qtde_transito = %',qtde_transito;
	        --raise notice 'qtde_saldo = %',qtde_saldo;
	        --raise notice 'qtde_saldo_residual = %',qtde_saldo_residual;



	        if qtde_saldo_residual > p_emax then -- Excesso


	          p_sugestao =  p_emax - qtde_saldo_residual;


	         if abs(p_sugestao) > qtde_transito_atraso then


	            p_sugestao = qtde_transito_atraso *(-1);

	         end if;


	        elseif qtde_saldo_residual > p_ponto_pedido AND qtde_saldo_residual <= p_emax AND (qtde_saldo_residual - (p_cmm * 0.30)) > p_ponto_pedido then  -- Adequado


	          p_sugestao = 0;
	          p_status_transito = 'PREVISÃO ADEQUADA';


	        elseif qtde_saldo_residual > p_ponto_pedido AND qtde_saldo_residual <= p_emax AND (qtde_saldo_residual - (p_cmm * 0.30)) <= p_ponto_pedido  then


	            p_consumo_transito2 = 0;

	            for rec_pedidos in (select distinct  gf.id_grupo  ,idproduto from produtos_filial pf
	                          inner join grupo_filial gf
	                           on gf.filial = pf.filial
	                          where gf.id_grupo = rec_transito.id_grupo
	                          and pf.idcategoria = rec_transito.idcategoria and revenda='S' and  status <> 'FL' )
				    loop

					    p_consumo_transito2 = p_consumo_transito2 + getconsumo_transito_grupo_2(rec_pedidos.id_grupo,rec_pedidos.idproduto);

					end loop;


	            --raise notice 'AKI = %',p_consumo_transito2;
	            --raise notice 'p_consumo_transito2 = %',p_consumo_transito2;


	        	p_sugestao =  (p_emax - (greatest((qtde_saldo_residual-p_consumo_transito2),0)));



		          qtde_cobertura_futura =  round(qtde_saldo_residual/ p_cmm,2);

		          if qtde_cobertura_futura < p_tr then


		            p_status_transito = 'PREVISÃO COM ELEVADA EXPOSIÇÃO A RUPTURA';


		          	else


		          	p_status_transito = 'PREVISÃO COM BAIXA EXPOSIÇÃO A RUPTURA';

		          end if;


	        elseif  ( qtde_saldo_residual  <= p_ponto_pedido) then



	           p_consumo_transito2 = 0;

	            for rec_pedidos in (select distinct  gf.id_grupo  ,idproduto from produtos_filial pf
	                          inner join grupo_filial gf
	                           on gf.filial = pf.filial
	                          where gf.id_grupo = rec_transito.id_grupo
	                          and pf.idcategoria = rec_transito.idcategoria and revenda='S' and  status <> 'FL' )
				    loop

					    p_consumo_transito2 = p_consumo_transito2 + getconsumo_transito_grupo_2(rec_pedidos.id_grupo,rec_pedidos.idproduto);

			    end loop;


			  --raise notice 'p_consumo_transito2 = %',p_consumo_transito2;


	          p_sugestao =  (p_emax - (greatest(qtde_saldo_residual-p_consumo_transito2,0))); --
	          qtde_cobertura_futura =  round(qtde_saldo_residual/ p_cmm,2);


	          if qtde_cobertura_futura < p_tr then


	            p_status_transito = 'PREVISÃO COM ELEVADA EXPOSIÇÃO A RUPTURA';


	          	else


	          	p_status_transito = 'PREVISÃO COM BAIXA EXPOSIÇÃO A RUPTURA';

	          end if;


	        else

	          p_sugestao = 0;
	          p_status_transito = 'PRODUTO EM TRÂNSITO';


	        end if;


	        p_sugestao = gerar_lote_embalagem(p_sugestao,qtde_lote_minimo);



	    elseif p_atraso = 0 and  qtde_transito > 0  then --Somente itens Abertos


	     -- raise notice 'SOMENTE ABERTO = %','';


	        qtde_transito = greatest(qtde_transito,0);

	    	qtde_saldo = qtde_estoque;


	        --raise notice 'qtde_transito = %',qtde_transito;

	        -- Quantidade de Pedidos Abertos


	        cont_ped = 1;

	        qtde_saldo_futuro= 0;
	        qtde_saldo_futuro_geral=0;




	        for rec_produtos in (select distinct  gf.id_grupo  ,idproduto from produtos_filial pf
	                          inner join grupo_filial gf
	                           on gf.filial = pf.filial
	                          where gf.id_grupo = rec_transito.id_grupo
	                          and pf.idcategoria = rec_transito.idcategoria and revenda='S' and  status <> 'FL' )
				    loop


			    cont_ped = 1;
	            qtde_saldo_futuro= 0;




			   for rec_pedidos in ( select  data_prevista_cal,sum(qtde) qtde
	      			from analise_requisicoes r inner join produtos_filial pf on r.filial  = pf.filial and r.idproduto = pf.idproduto
		      		where r.idproduto = rec_produtos.idproduto and qtde_pendente > 0 and atraso < 0
		    	  and r.filial  in (select filial from grupo_filial where id_grupo= rec_produtos.id_grupo ) group by data_prevista_cal order by data_prevista_cal)

		    	 loop



			    	if cont_ped = 1 then

                      qtde_dias =  rec_pedidos.data_prevista_cal - current_date ;
                      p_tr = (qtde_dias/30);

                    else


                     qtde_dias =  ((rec_pedidos.data_prevista_cal)  - current_date) - qtde_dias ;
                     p_tr = (qtde_dias/30);

                 end if;


                 --raise notice 'qtde_dias = %',qtde_dias;
                 --raise notice 'rec_pedidos.data_prevista_cal = %',rec_pedidos.data_prevista_cal;



                 consumo_transito_cal = round((p_cmm * (qtde_dias/30)),2);


                 if  consumo_transito_cal > qtde_saldo then


                     consumo_transito_cal = qtde_saldo;

                     qtde_saldo_residual = qtde_saldo - consumo_transito_cal;


                 else

                    qtde_saldo_residual = qtde_saldo - consumo_transito_cal;

                 end if;


                 qtde_saldo_futuro = qtde_saldo_residual + rec_pedidos.qtde;

                 qtde_saldo = qtde_saldo_futuro;


                 cont_ped = cont_ped + 1;


                 p_data_pedido_ant = rec_pedidos.data_prevista_cal;



			        --raise notice '# - qtde_saldo_futuro = %',qtde_saldo_futuro;


		    	 end loop;


		    	 qtde_saldo_futuro_geral = qtde_saldo_futuro_geral + qtde_saldo_futuro;





			end loop;



		    qtde_saldo_futuro = qtde_saldo_futuro_geral ;


		   --raise notice 'qtde_saldo_futuro = %',qtde_saldo_futuro;



	        if qtde_saldo_futuro > p_emax then


	          p_sugestao =  p_emax - qtde_saldo_futuro;
	          p_status_transito = 'PREVISÃO EM EXCESSO';



	          if abs(p_sugestao) > rec_transito.compra_transito then


	            p_sugestao = rec_transito.compra_transito *(-1);

	         end if;


	        elseif qtde_saldo_futuro > p_ponto_pedido AND qtde_saldo_futuro <= p_emax AND (qtde_saldo_futuro - (p_cmm * 0.30)) > p_ponto_pedido then

	         p_sugestao = 0;
	         p_status_transito = 'PREVISÃO ADEQUADA';


	        elseif qtde_saldo_futuro > p_ponto_pedido AND qtde_saldo_futuro <= p_emax AND (qtde_saldo_futuro - (p_cmm * 0.30)) <= p_ponto_pedido  then



	         -- raise notice 'p_data_pedido_ant = %',p_data_pedido_ant;


	          p_tr = ((current_date +  (rec_transito.tempo_ressuprimento*30)::int4) - p_data_pedido_ant)::numeric/30;


			  p_sugestao = (p_emax - (greatest(qtde_saldo_futuro-(p_cmm *p_tr),0)));



	          qtde_cobertura_futura =  round(qtde_saldo_futuro/ p_cmm,2);

	          if qtde_cobertura_futura < p_tr then


	            p_status_transito = 'PREVISÃO COM ELEVADA EXPOSIÇÃO A RUPTURA';


	          	else


	          	p_status_transito = 'PREVISÃO COM BAIXA EXPOSIÇÃO A RUPTURA';

	          end if;


	        elseif  ( qtde_saldo_futuro  <= p_ponto_pedido) then




	             p_tr = ((current_date +  (rec_transito.tempo_ressuprimento*30)::int4) - p_data_pedido_ant)::numeric/30;


	             --raise notice 'TRRRRRRRR = %',p_tr;



	             p_sugestao = (p_emax - (greatest(qtde_saldo_futuro-(p_cmm *p_tr),0)));


	              qtde_cobertura_futura =  round(qtde_saldo_futuro/ p_cmm,2);

		          if qtde_cobertura_futura < p_tr then


		            p_status_transito = 'PREVISÃO COM ELEVADA EXPOSIÇÃO A RUPTURA';


		          	else


		          	p_status_transito = 'PREVISÃO COM BAIXA EXPOSIÇÃO A RUPTURA';

		          end if;



	        else

	          p_sugestao = 0;

	          p_status_transito = 'PRODUTO EM TRÂNSITO';


	        end if;


	       --raise notice 'p_status_transito = %',p_status_transito;
	      --raise notice 'p_sugestao = %',p_sugestao;


	     else    -- COMPRAS HIBRIDAS

	       --raise notice 'COMPRAS HIBRIDAS = %','';

	        qtde_transito = greatest(qtde_transito,0);

	    	qtde_saldo = qtde_estoque +  qtde_transito_atraso;


	       --raise notice 'qtde_estoque = %',qtde_saldo;


	        cont_ped = 1;

	        qtde_saldo_futuro= 0;
	        qtde_saldo_futuro_geral=0;


	        for rec_produtos in (select distinct  gf.id_grupo  ,idproduto from produtos_filial pf
	                          inner join grupo_filial gf
	                           on gf.filial = pf.filial
	                          where gf.id_grupo = rec_transito.id_grupo
	                          and pf.idcategoria = rec_transito.idcategoria and revenda='S' and  status <> 'FL' )
				    loop


			    cont_ped = 1;
	            qtde_saldo_futuro= 0;


			   for rec_pedidos in ( select  data_prevista_cal,sum(qtde) qtde
	      			from analise_requisicoes r inner join produtos_filial pf on r.filial  = pf.filial and r.idproduto = pf.idproduto
		      		where r.idproduto = rec_produtos.idproduto and qtde_pendente > 0 and atraso < 0
		    	  and r.filial  in (select filial from grupo_filial where id_grupo= rec_produtos.id_grupo ) group by data_prevista_cal order by data_prevista_cal)

		    	 loop



			    	if cont_ped = 1 then

                      qtde_dias =  rec_pedidos.data_prevista_cal - current_date ;
                      p_tr = (qtde_dias/30);

                    else


                     qtde_dias =  ((rec_pedidos.data_prevista_cal)  - current_date) - qtde_dias ;
                     p_tr = (qtde_dias/30);

                 end if;


                 --raise notice 'qtde_dias = %',qtde_dias;
                 --raise notice 'rec_pedidos.data_prevista_cal = %',rec_pedidos.data_prevista_cal;



                 consumo_transito_cal = round((p_cmm * (qtde_dias/30)),2);


                 if  consumo_transito_cal > qtde_saldo then


                     consumo_transito_cal = qtde_saldo;

                     qtde_saldo_residual = qtde_saldo - consumo_transito_cal;


                 else

                    qtde_saldo_residual = qtde_saldo - consumo_transito_cal;

                 end if;


                 qtde_saldo_futuro = qtde_saldo_residual + rec_pedidos.qtde;

                 qtde_saldo = qtde_saldo_futuro;


                 cont_ped = cont_ped + 1;


                 p_data_pedido_ant = rec_pedidos.data_prevista_cal;



			        --raise notice '# - qtde_saldo_futuro = %',qtde_saldo_futuro;


		    	 end loop;


		    	  --raise notice 'qtde_saldo_futuro  = %',qtde_saldo_futuro;


		    	 qtde_saldo_futuro_geral = qtde_saldo_futuro_geral + qtde_saldo_futuro;


			end loop;

		     --raise notice 'qtde_saldo_futuro_geral  = %',qtde_saldo_futuro_geral;

		    qtde_saldo_futuro = qtde_saldo_futuro_geral ;



	        if qtde_saldo_futuro > p_emax then


	          p_sugestao =  p_emax - qtde_saldo_futuro;
	          p_status_transito = 'PREVISÃO EM EXCESSO';



	          if abs(p_sugestao) > rec_transito.compra_transito then


	            p_sugestao = rec_transito.compra_transito *(-1);

	         end if;


	        elseif qtde_saldo_futuro > p_ponto_pedido AND qtde_saldo_futuro <= p_emax AND (qtde_saldo_futuro - (p_cmm * 0.30)) > p_ponto_pedido then

	         p_sugestao = 0;
	         p_status_transito = 'PREVISÃO ADEQUADA';


	        elseif qtde_saldo_futuro > p_ponto_pedido AND qtde_saldo_futuro <= p_emax AND (qtde_saldo_futuro - (p_cmm * 0.30)) <= p_ponto_pedido  then




	           --raise notice 'p_tr CONTA= %',p_tr;
	           --raise notice 'p_data_pedido_ant = %',p_data_pedido_ant;


	           p_tr = ((current_date +  (rec_transito.tempo_ressuprimento*30)::int4) - p_data_pedido_ant)::numeric/30;


	           --raise notice 'p_data_pedido_atual = %',p_tr;




			  p_sugestao = (p_emax - (greatest(qtde_saldo_futuro-(p_cmm *p_tr),0)));



	          qtde_cobertura_futura =  round(qtde_saldo_futuro/ p_cmm,2);

	          if qtde_cobertura_futura < p_tr then


	            p_status_transito = 'PREVISÃO COM ELEVADA EXPOSIÇÃO A RUPTURA';


	          	else


	          	p_status_transito = 'PREVISÃO COM BAIXA EXPOSIÇÃO A RUPTURA';

	          end if;


	        elseif  ( qtde_saldo_futuro  <= p_ponto_pedido) then




	             p_tr = ((current_date +  (rec_transito.tempo_ressuprimento*30)::int4) - p_data_pedido_ant)::numeric/30;


	             p_sugestao = (p_emax - (greatest(qtde_saldo_futuro-(p_cmm *p_tr),0)));


	              qtde_cobertura_futura =  round(qtde_saldo_futuro/ p_cmm,2);

		          if qtde_cobertura_futura < p_tr then


		            p_status_transito = 'PREVISÃO COM ELEVADA EXPOSIÇÃO A RUPTURA';


		          	else


		          	p_status_transito = 'PREVISÃO COM BAIXA EXPOSIÇÃO A RUPTURA';

		          end if;



	        else

	          p_sugestao = 0;

	          p_status_transito = 'PRODUTO EM TRÂNSITO';


	        end if;


	    end if;


	       p_sugestao = gerar_lote_embalagem(p_sugestao,qtde_lote_minimo);


	     -- p_sugestao=0;
	     -- p_status_transito = 'PRODUTO EM TRÂNSITO';


	      --raise notice 'p_sugestao = %',p_sugestao;
	      --raise notice 'p_status_transito = %',p_status_transito;

        --select * from produtos_transito_categorias

           --Update


			update
				produtos_transito_categorias
			set
				iddepartamento = rec_transito.iddepartamento,
				idsecao = rec_transito.idsecao,
				idcategoria = rec_transito.idcategoria,
				descricao_categoria = rec_transito.descricao_categoria,
				consumo_medio_mensal = rec_transito.consumo_medio_mensal,
				desvio_padrao_consumo = rec_transito.desvio_padrao_consumo,
				estoque = rec_transito.estoque,
				ponto_pedido = rec_transito.ponto_pedido,
				estoque_maximo = rec_transito.estoque_maximo,
				compra_transito = rec_transito.compra_transito,
				lote_compras = p_sugestao,
				status = p_status_transito,
				flag = null,
				processamento = current_timestamp
			where
				id_grupo = rec_transito.id_grupo
				and idcategoria = rec_transito.idcategoria;



			if not found then


				insert
				  into produtos_transito_categorias (
					id_grupo,
					iddepartamento,
					idsecao,
					idcategoria,
					descricao_categoria,
					consumo_medio_mensal,
					desvio_padrao_consumo,
					estoque,
					ponto_pedido,
					estoque_maximo,
					compra_transito,
					lote_compras,
					status,
					flag,
					processamento
				)
				values(
					rec_transito.id_grupo,
					rec_transito.iddepartamento,
					rec_transito.idsecao,
					rec_transito.idcategoria,
					rec_transito.descricao_categoria,
					rec_transito.consumo_medio_mensal,
					rec_transito.desvio_padrao_consumo,
					rec_transito.estoque,
					rec_transito.ponto_pedido,
					rec_transito.estoque_maximo,
					rec_transito.compra_transito,
					p_sugestao,
					p_status_transito,
					null,
					current_timestamp
				);


		    end if;


	 end loop;

 delete from  produtos_transito_categorias  where  flag ='D';

end
$function$

