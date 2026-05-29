CREATE OR REPLACE FUNCTION public.processar_status_produto(p_dataref date DEFAULT (('now'::text)::date - 1))
 RETURNS void
 LANGUAGE plpgsql
 PARALLEL SAFE
AS $function$
declare

rec_prod record;

    v_ultima_entrada date;
    v_ultima_solicitacao date;
    v_id_solicitacao int8;
    v_estoque_solicitacao numeric(12,4);
    v_status_percepcao varchar;
    v_media_mensal numeric(12,4);
    v_ult_saida date;
    v_tempo_ult_venda int8;
    v_qtde_dias_ruptura int8;
    v_dataini date;
    v_datafim date;
   	v_data_ruptura date;

begin


 update status_produto  set flag='D' where ano=date_part('year',p_dataref) and mes=date_part('month',p_dataref);

 select first_day(p_dataref) , last_day(p_dataref) into v_dataini,v_datafim;


 for rec_prod in ( SELECT a.id_grupo,
    a.filial,
    a.ano,
    a.mes,
    a.descricao_produto,
    a.descricao_familia_produto,
    a.custo_unitario,
    a.valor_unitario,
    a.estoque,
    a.estoque_transito,
    a.status_compra,
    a.idproduto,
    a.data_solicitacao,
    a.arvore_decisao,
    a.estoque_seguranca,
    a.ponto_pedido,
    a.estoque_maximo,
    a.consumo_medio,
    a.sugestao,
    a.necessidade,
    a.processamento,
    a.indice_nivel,
    a.nivel_servico,
    a.peso_nivel_servico,
    a.status_produto,
    a.status_exposicao,
    a.peso_status,
    a.revenda,
    a.fora_linha,
    a.nome_completo,
    a.id,
    a.razao_social,
    a.data_cadastro,
    a.peso_nivel_servico * a.peso_status::numeric AS analise_qualitativa,
    a.tempo_ressuprimento,
    a.desvio_padrao_ressuprimento
   FROM ( SELECT gf.id_grupo,
            s.filial,
            s.ano,
            s.mes,
            p.descricao_produto,
            familia_produtos.descricao_familia_produto,
            p.custo_unitario * p.fator_conversao AS custo_unitario,
            p.valor_unitario * p.fator_conversao AS valor_unitario,
            s.estoque,
            getcompra_transito_periodo_filial(s.filial::numeric, s.idproduto, s.data) AS estoque_transito,
                CASE
                    WHEN getcompra_transito_periodo_filial(s.filial::numeric, s.idproduto, s.data) > 0::numeric THEN 'COM PEDIDO'::text
                    ELSE 'SEM PEDIDO'::text
                END AS status_compra,
            s.idproduto,
            s."data"  as data_solicitacao,
            s.arvore_decisao ,
            s.esseg  as estoque_seguranca,
            s.ppd as ponto_pedido,
            s.emax  as estoque_maximo,
            s.cmm  as consumo_medio,
            s.sugestao_compras  as sugestao,
                CASE
                    WHEN s.ppd > (s.estoque + getcompra_transito_periodo_filial(s.filial::numeric, s.idproduto, s.data)) THEN s.emax - (s.estoque + getcompra_transito_periodo_filial(s.filial::numeric, s.idproduto, s.data))
                    ELSE 0::numeric
                END AS necessidade,
            s.processamento,
            n.indice AS indice_nivel,
            p.nivel_servico,
            n.peso AS peso_nivel_servico,
                CASE
                    WHEN s.estoque > (ceil(s.emax) * n.peso) THEN 'EXCESSO'::text
                    WHEN s.estoque = 0::numeric AND s.media_trimestre > 0::numeric THEN 'RUPTURA'::text
                    WHEN s.estoque = 0::numeric AND s.media_trimestre = 0::numeric THEN 'SEM MOVIMENTO'::text
                    WHEN s.estoque > s.ppd AND s.estoque <= (ceil(s.emax) * n.peso) THEN 'ADEQUADO'::text
                    WHEN s.estoque <= s.ppd AND getcompra_transito_periodo_filial(s.filial::numeric, s.idproduto, s.data) > 0::numeric THEN 'EXPOSTO COM PEDIDO'::text
                    WHEN s.estoque <= s.ppd AND getcompra_transito_periodo_filial(s.filial::numeric, s.idproduto, s.data) = 0::numeric THEN 'EXPOSTO SEM PEDIDO'::text
                    ELSE NULL::text
                END AS status_produto,
                CASE
                    WHEN s.estoque <= s.ppd AND s.estoque > (s.ppd - s.esseg) THEN 'SUTIL'::text
                    WHEN s.estoque <= s.ppd AND s.estoque < (s.ppd - s.esseg) THEN 'ELEVADA'::text
                    ELSE ' '::text
                END AS status_exposicao,
                CASE
                    WHEN s.estoque > (ceil(s.emax) * n.peso) THEN 10
                    WHEN s.estoque = 0::numeric THEN 25
                    WHEN s.estoque > s.ppd AND s.estoque <= (ceil(s.emax) * n.peso) THEN 30
                    WHEN s.estoque <= s.ppd AND getcompra_transito_periodo_filial(s.filial::numeric, s.idproduto, s.data) = 0::numeric THEN 15
                    WHEN s.estoque <= s.ppd AND getcompra_transito_periodo_filial(s.filial::numeric, s.idproduto, s.data) <> 0::numeric THEN 20
                    ELSE NULL::integer
                END AS peso_status,
            p.revenda,
            p.status AS fora_linha,
            c.nome_completo,
            f.id,
            f.razao_social,
              p.data_cadastro,
              s.tempo_ressuprimento,
              s.desvio_padrao_ressuprimento
           FROM saldo_filiais s
             JOIN produtos_filial p ON p.filial = s.filial AND p.idproduto::text = s.idproduto::text
             JOIN nivel_servico n ON n.descricao_nivel_servico::text = p.nivel_servico::text
             JOIN comprador c ON c.id = p.idcomprador
             JOIN fornecedor f ON p.idfornecedor = f.id
             JOIN familia_produtos ON p.idfamilia_produto = familia_produtos.idfamilia_produto
             JOIN grupo_filial gf ON gf.filial = s.filial
          where (s.data = p_dataref) AND (s."data" - COALESCE(p.data_cadastro,current_date-365)) > 180 AND p.status::text <> 'FL'::text AND p.revenda::text = 'S'::text AND familia_produtos.descricao_familia_produto::text !~~ '%FEIRAO%'::text AND familia_produtos.descricao_familia_produto::text !~~ '%AVARIA%'::text
          ORDER BY s.data)a)

          loop




               --   ult_saida;tempo_ult_venda ok

               select  max(c2.emissao)  ,   'now'::text::date - max(c2.emissao)
                into v_ult_saida,v_tempo_ult_venda
               FROM consumos c2
                  WHERE c2.filial = rec_prod.filial  AND c2.idproduto = rec_prod.idproduto;

                -- media_mensal ok

                select avg(s2.media_trimestre)
                   into v_media_mensal
                   FROM saldo_filiais s2
                  WHERE s2.filial = rec_prod.filial AND s2.idproduto = rec_prod.idproduto AND s2.data >= v_dataini AND s2.data <= v_datafim;


                --qtde_dias_ruptura ok

                SELECT count(*), min(data) as data_ruptura
                       into v_qtde_dias_ruptura, v_data_ruptura
			                   FROM saldo_filiais
			                  WHERE saldo_filiais.filial = rec_prod.filial
			                  AND saldo_filiais.idproduto  = rec_prod.idproduto
			                  AND saldo_filiais.data >= v_dataini AND saldo_filiais.data <= v_datafim
			                  AND saldo_filiais.media_trimestre > 0::numeric
			                  AND saldo_filiais.estoque = 0::numeric ;

                --status_percepcao ok


                SELECT w.status_percepcao
                   into v_status_percepcao
                   FROM analise_percepcao_compras_grupos w
                  WHERE w.filial = rec_prod.filial
                  AND w.idproduto = rec_prod.idproduto
                  AND w.ordem_compra = (( SELECT max(analise_requisicoes.id_solicitacao) AS max
                           					FROM analise_requisicoes
                         				  WHERE analise_requisicoes.idproduto = rec_prod.idproduto
                         				  AND analise_requisicoes.data_solicitacao <= v_datafim  LIMIT 1))
                 LIMIT 1;



                  --estoque_solicitacao ok

                  SELECT saldo_filiais.estoque
                   into v_estoque_solicitacao
                   FROM saldo_filiais
                  WHERE saldo_filiais.filial = rec_prod.filial
                  AND saldo_filiais.idproduto = rec_prod.idproduto
                  AND saldo_filiais.data = (( SELECT max(analise_requisicoes.data_solicitacao)
                           						FROM analise_requisicoes
                          					  WHERE analise_requisicoes.filial = rec_prod.filial
                          					  AND analise_requisicoes.idproduto = rec_prod.idproduto
                          					  AND analise_requisicoes.data_solicitacao <= v_datafim LIMIT 1));

                  --id_solicitacao ok

                  SELECT max(analise_requisicoes.id_solicitacao)
                   into v_id_solicitacao
                   FROM analise_requisicoes
                  WHERE (analise_requisicoes.filial IN ( SELECT grupo_filial.filial
                           FROM grupo_filial
                          WHERE grupo_filial.id_grupo = rec_prod.id_grupo))
                          AND analise_requisicoes.idproduto  = rec_prod.idproduto
                          AND analise_requisicoes.data_solicitacao <= v_datafim
                 LIMIT 1;


                  --ultima_solicitacao ok

                 SELECT max(analise_requisicoes.data_solicitacao)
                   into v_ultima_solicitacao
                   FROM analise_requisicoes
                  WHERE (analise_requisicoes.filial IN ( SELECT grupo_filial.filial
                           FROM grupo_filial
                          WHERE grupo_filial.id_grupo = rec_prod.id_grupo))
                          AND analise_requisicoes.idproduto = rec_prod.idproduto
                          AND analise_requisicoes.data_solicitacao <= v_datafim
                 LIMIT 1;

                 --ultima_entrada ok

                 SELECT max(em.data_entrada)
                   into v_ultima_entrada
                   FROM entrada_mercadorias em
                  WHERE (em.idfilial IN ( SELECT grupo_filial.filial
                           FROM grupo_filial
                          WHERE grupo_filial.id_grupo = rec_prod.id_grupo))
                          AND em.idproduto = rec_prod.idproduto
                          AND em.data_entrada <= v_datafim
                 LIMIT 1;




          update
				status_produto
			set
				descricao_produto = rec_prod.descricao_produto,
				descricao_familia_produto = rec_prod.descricao_familia_produto,
				custo_unitario = rec_prod.custo_unitario,
				valor_unitario = rec_prod.valor_unitario,
				estoque = rec_prod.estoque,
				estoque_transito = rec_prod.estoque_transito,
				status_compra = rec_prod.status_compra,
				data_solicitacao = rec_prod.data_solicitacao,
				arvore_decisao = rec_prod.arvore_decisao,
				estoque_seguranca = rec_prod.estoque_seguranca,
				ponto_pedido = rec_prod.ponto_pedido,
				estoque_maximo = rec_prod.estoque_maximo,
				consumo_medio = rec_prod.consumo_medio,
				sugestao = rec_prod.sugestao,
				necessidade = rec_prod.necessidade,
				processamento = rec_prod.processamento,
				indice_nivel = rec_prod.indice_nivel,
				nivel_servico = rec_prod.nivel_servico,
				peso_nivel_servico = rec_prod.peso_nivel_servico,
				status_produto = rec_prod.status_produto,
				status_exposicao = rec_prod.status_exposicao,
				peso_status = rec_prod.peso_status,
				revenda = rec_prod.revenda,
				fora_linha = rec_prod.fora_linha,
				nome_completo = rec_prod.nome_completo,
				ultima_entrada = v_ultima_entrada,
				ultima_solicitacao = v_ultima_solicitacao,
				id_solicitacao = v_id_solicitacao,
				estoque_solicitacao = v_estoque_solicitacao,
				status_percepcao = v_status_percepcao,
				razao_social = rec_prod.razao_social,
				qtde_dias_ruptura = v_qtde_dias_ruptura,
				data_cadastro = rec_prod.data_cadastro,
				media_mensal = v_media_mensal,
				ult_saida = v_ult_saida,
				tempo_ult_venda = v_tempo_ult_venda,
				analise_qualitativa = rec_prod.analise_qualitativa,
				tempo_ressuprimento =rec_prod.tempo_ressuprimento,
				desvio_padrao_ressuprimento =rec_prod.desvio_padrao_ressuprimento,
				flag=null,
				data_ruptura = v_data_ruptura
			where
				id_grupo = rec_prod.id_grupo
				and filial = rec_prod.filial
				and ano = rec_prod.ano
				and mes = rec_prod.mes
				and id = rec_prod.id
				and idproduto = rec_prod.idproduto;


	           if not found then

	            INSERT INTO status_produto
				(id_grupo, filial, ano, mes, descricao_produto, descricao_familia_produto, custo_unitario, valor_unitario, estoque,
				 estoque_transito, status_compra, idproduto, data_solicitacao, arvore_decisao, estoque_seguranca, ponto_pedido, estoque_maximo,
				 consumo_medio, sugestao, necessidade, processamento, indice_nivel, nivel_servico, peso_nivel_servico, status_produto,
				 status_exposicao, peso_status, revenda, fora_linha, nome_completo, ultima_entrada, ultima_solicitacao, id_solicitacao,
				 estoque_solicitacao, status_percepcao, id, razao_social, qtde_dias_ruptura, data_cadastro, media_mensal, ult_saida, tempo_ult_venda,
				 analise_qualitativa,data_referencia,tempo_ressuprimento,desvio_padrao_ressuprimento,
				data_ruptura)
				VALUES(rec_prod.id_grupo, rec_prod.filial, rec_prod.ano, rec_prod.mes, rec_prod.descricao_produto, rec_prod.descricao_familia_produto, rec_prod.custo_unitario, rec_prod.valor_unitario,
						rec_prod.estoque, rec_prod.estoque_transito, rec_prod.status_compra, rec_prod.idproduto, rec_prod.data_solicitacao, rec_prod.arvore_decisao, rec_prod.estoque_seguranca, rec_prod.ponto_pedido,
					rec_prod.estoque_maximo, rec_prod.consumo_medio, rec_prod.sugestao, rec_prod.necessidade, rec_prod.processamento, rec_prod.indice_nivel, rec_prod.nivel_servico, rec_prod.peso_nivel_servico, rec_prod.status_produto,
					rec_prod.status_exposicao, rec_prod.peso_status, rec_prod.revenda, rec_prod.fora_linha, rec_prod.nome_completo, v_ultima_entrada, v_ultima_solicitacao,v_id_solicitacao, v_estoque_solicitacao,
					v_status_percepcao, rec_prod.id, rec_prod.razao_social, v_qtde_dias_ruptura, rec_prod.data_cadastro, v_media_mensal, v_ult_saida, V_tempo_ult_venda, rec_prod.analise_qualitativa,
					('01/'||lpad(CAST(rec_prod.mes AS VARCHAR),2,'0')||'/'||rec_prod.ano)::date,rec_prod.tempo_ressuprimento,rec_prod.desvio_padrao_ressuprimento, v_data_ruptura

				);

	           end if;


          end loop;

          delete from  status_produto  where ano=date_part('year',p_dataref) and mes=date_part('month',p_dataref) and flag='D';

end
  $function$

