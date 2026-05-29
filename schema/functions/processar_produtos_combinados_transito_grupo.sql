CREATE OR REPLACE FUNCTION public.processar_produtos_combinados_transito_grupo(f_id_produto_combinado character varying DEFAULT NULL::character varying)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
    declare
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
        qtde_saldo_residual numeric;
        p_status_transito varchar;
        qtde_lote_minimo  numeric;
        qtde_cobertura_futura numeric;
        qtde_dias numeric;
        cont_ped numeric;
        consumo_transito_cal numeric;
        data_temp date;
    BEGIN

    IF trim(f_id_produto_combinado) = '' THEN
        f_id_produto_combinado = NULL;
    END IF;

    UPDATE produtos_combinados_transito_grupo SET flag ='D' WHERE (f_id_produto_combinado = id_produto_combinado OR f_id_produto_combinado IS NULL);

    for rec_transito in(
        SELECT
            a.id_grupo,
            a.id_produto_combinado,
            a.produtos,
            a.compra_transito,
            a.consumo_transito * a.fator_conversao AS consumo_transito,
            a.saldo_futuro * a.fator_conversao AS saldo_futuro,
            a.estoque_maximo * a.fator_conversao::double precision AS estoque_maximo,
            a.ponto_pedido * a.fator_conversao::double precision AS ponto_pedido,
            a.consumo_medio_mensal::double precision * a.fator_conversao::double precision AS consumo_medio_mensal,
            a.tempo_ressuprimento,
            a.estoque::double precision * a.fator_conversao::double precision AS estoque,
            a.status,
            CASE
                WHEN a.status = 'PREVISÃO FUTURA EM EXCESSO'::text AND abs(a.lote_compras * a.fator_conversao::double precision) > a.compra_transito::double precision THEN (a.compra_transito * '-1'::integer::numeric)::double precision
                ELSE gerar_lote_embalagem((a.lote_compras * a.fator_conversao::double precision)::numeric, a.lote_minimo::numeric * a.fator_conversao)::double precision
            END AS lote_compras,
            a.fator_conversao,
            a.unidade_compra,
            a.data_ultima_requisicao,
            'now'::text::date - a.data_ultima_requisicao AS tempo_pedido,
            a.nivel_servico,
            a.peso_compras,
            CASE
                WHEN ('now'::text::date - a.data_ultima_requisicao - 1) < 0 THEN NULL::integer
                ELSE 'now'::text::date - a.data_ultima_requisicao - 1
            END AS gatilho_transito,
            a.lote_minimo
        FROM (
            SELECT
                analise_entrada.id_grupo,
                analise_entrada.id_produto_combinado,
                analise_entrada.produtos,
                analise_entrada.compra_transito,
                analise_entrada.consumo_transito,
                analise_entrada.saldo_futuro,
                analise_entrada.estoque_maximo,
                analise_entrada.ponto_pedido,
                analise_entrada.consumo_medio_mensal,
                analise_entrada.tempo_ressuprimento,
                analise_entrada.estoque,
                analise_entrada.fator_conversao,
                analise_entrada.unidade_compra,
                analise_entrada.lote_minimo,
                analise_entrada.data_ultima_requisicao,
                analise_entrada.nivel_servico,
                analise_entrada.peso_compras,
                case
                    WHEN analise_entrada.status_compra = 0::numeric AND ('now'::text::date - analise_entrada.data_ultima_requisicao) <= 1 THEN 'PRODUTO EM TRANSITO'::text
                    WHEN analise_entrada.status_compra = 0::numeric AND ('now'::text::date - analise_entrada.data_ultima_requisicao) > 1 AND analise_entrada.saldo_futuro::double precision > analise_entrada.estoque_maximo THEN 'PREVISÃO FUTURA EM EXCESSO'::text
                    WHEN analise_entrada.status_compra = 0::numeric AND ('now'::text::date - analise_entrada.data_ultima_requisicao) > 1 AND analise_entrada.saldo_futuro::double precision > analise_entrada.ponto_pedido AND analise_entrada.saldo_futuro::double precision <= analise_entrada.estoque_maximo AND (analise_entrada.saldo_futuro::double precision - analise_entrada.consumo_medio_mensal::double precision * 0.3::double precision) > analise_entrada.ponto_pedido THEN 'PREVISÃO FUTURA ADEQUADA'::text
                    WHEN analise_entrada.status_compra = 0::numeric AND ('now'::text::date - analise_entrada.data_ultima_requisicao) > 1 AND analise_entrada.saldo_futuro::double precision > analise_entrada.ponto_pedido AND analise_entrada.saldo_futuro::double precision <= analise_entrada.estoque_maximo AND (analise_entrada.saldo_futuro::double precision - analise_entrada.consumo_medio_mensal::double precision * 0.3::double precision) <= analise_entrada.ponto_pedido THEN 'PREVISÃO COM SUTIL EXPOSIÇÃO A RUPTURA'::text
                    WHEN analise_entrada.status_compra = 0::numeric AND ('now'::text::date - analise_entrada.data_ultima_requisicao) > 1 AND analise_entrada.saldo_futuro::double precision <= analise_entrada.ponto_pedido THEN 'PREVISÃO COM ELEVADA EXPOSIÇÃO A RUPTURA'::text
                    ELSE 'PRIMEIRA COMPRA'::text
                END AS status,
                CASE
                    WHEN analise_entrada.status_compra = 0::numeric AND ('now'::text::date - analise_entrada.data_ultima_requisicao) > 1 AND analise_entrada.saldo_futuro::double precision > analise_entrada.estoque_maximo THEN analise_entrada.estoque_maximo - analise_entrada.saldo_futuro::double precision
                    WHEN analise_entrada.status_compra = 0::numeric AND ('now'::text::date - analise_entrada.data_ultima_requisicao) > 1 AND analise_entrada.saldo_futuro::double precision > analise_entrada.ponto_pedido AND analise_entrada.saldo_futuro::double precision <= analise_entrada.estoque_maximo AND (analise_entrada.saldo_futuro::double precision - analise_entrada.consumo_medio_mensal::double precision * 0.3::double precision) > analise_entrada.ponto_pedido THEN 0::double precision
                    WHEN analise_entrada.status_compra = 0::numeric AND ('now'::text::date - analise_entrada.data_ultima_requisicao) > 1 AND analise_entrada.saldo_futuro::double precision > analise_entrada.ponto_pedido AND analise_entrada.saldo_futuro::double precision <= analise_entrada.estoque_maximo AND (analise_entrada.saldo_futuro::double precision - analise_entrada.consumo_medio_mensal::double precision * 0.3::double precision) <= analise_entrada.ponto_pedido THEN round((analise_entrada.estoque_maximo - (analise_entrada.saldo_futuro::double PRECISION - analise_entrada.consumo_transito_grupo_entre_pedidos))::numeric, 2)::double precision
                    WHEN analise_entrada.status_compra = 0::numeric AND ('now'::text::date - analise_entrada.data_ultima_requisicao) > 1 AND analise_entrada.saldo_futuro::double precision <= analise_entrada.ponto_pedido THEN round((analise_entrada.estoque_maximo - (analise_entrada.saldo_futuro::double precision - analise_entrada.consumo_transito_grupo_entre_pedidos))::numeric, 2)::double precision
                    ELSE 0::double precision
                END AS lote_compras
            FROM (
                SELECT
                    b.id_grupo,
                    b.id_produto_combinado,
                    b.produtos,
                    b.fator_conversao,
                    b.unidade_compra,
                    max(b.lote_minimo) AS lote_minimo,
                    max(b.data_ultima_requisicao) AS data_ultima_requisicao,
                    b.nivel_servico,
                    b.peso_compras,
                    avg(b.compra_transito) AS compra_transito,
                    sum(b.consumo_transito) AS consumo_transito,
                    CASE
                        WHEN (greatest((avg(b.estoque) - sum(b.consumo_transito)),0) + avg(b.compra_transito)) < 0::numeric THEN 0::numeric
                        ELSE greatest((avg(b.estoque) - sum(b.consumo_transito)),0) + avg(b.compra_transito)
                    END AS saldo_futuro,
                    avg(b.amplitude_atual) AS amplitude_atual,
                    avg(b.estoque_maximo) AS estoque_maximo,
                    avg(b.ponto_pedido) AS ponto_pedido,
                    avg(b.consumo_medio_mensal) AS consumo_medio_mensal,
                    avg(b.tempo_ressuprimento) AS tempo_ressuprimento,
                    avg(b.desvio_padrao_ressuprimento) AS desvio_padrao_ressuprimento,
                    avg(b.estoque) AS estoque,
                    avg(b.status_compra) AS status_compra,
                    b.consumo_transito_grupo_entre_pedidos
                FROM (
                    SELECT
                        g.id_grupo,
                        p.filial,
                        vp.id_produto_combinado,
                        vp.produtos,
                        vp.compra_transito AS compra_transito,
                        case
                            when ((
                                select count(*)
                                from analise_requisicoes ar
                                where filial in(select filial from grupo_filial gf where gf.id_grupo=g.id_grupo::numeric) and idproduto = ANY (vp.produtos) and atraso  > 0
                            ) > 0)
                            then sum(getconsumo_transito_grupo_new(g.id_grupo::numeric, p.idproduto)) +  round(coalesce((vp.tempo_medio_ressuprimento / 30) * vp.consumo_medio_mensal, 0), 2)
                            else sum(getconsumo_transito_grupo_new(g.id_grupo::numeric, p.idproduto))
                        END as consumo_transito,
                        round(coalesce((vp.tempo_medio_ressuprimento / 30) * vp.consumo_medio_mensal, 0), 2) AS consumo_transito_2,
                        case
                            when ((select count(*) from analise_requisicoes ar
                                where filial in(select filial from grupo_filial gf where gf.id_grupo=g.id_grupo::numeric)
                                and idproduto = ANY (vp.produtos) and atraso  > 0) > 0)  then 1
                            else 0
                        end as atraso,
                        sum(amplitude_transito_atual_filial(p.filial::numeric, p.idproduto)) AS amplitude_atual,
                        COALESCE(vp.estoque_maximo::double precision, 0::double precision) AS estoque_maximo,
                        COALESCE(vp.ponto_pedido::double precision, 0::double precision) AS ponto_pedido,
                        vp.consumo_medio_mensal,
                        vp.tempo_ressuprimento,
                        vp.desvio_padrao_ressuprimento,
                        vp.estoque,
                        (
                            SELECT CASE WHEN count(*) > 0 THEN 0 ELSE 1 END
                            FROM entrada_mercadorias
                            WHERE
                                entrada_mercadorias.data_entrada <= 'now'::text::date
                                AND entrada_mercadorias.idproduto::text = ANY (vp.produtos)
                                AND entrada_mercadorias.qtde > 0::double PRECISION
                        ) AS status_compra,
                        vp.fator_conversao,
                        vp.unidade_compra,
                        vp.lote_minimo,
                        vp.data_ultima_requisicao,
                        vp.arvore_decisao,
                        vp.nivel_servico,
                        vp.peso_compras,
                        sum(getconsumo_transito_grupo_entre_pedidos(g.id_grupo::numeric, p.idproduto)) AS consumo_transito_grupo_entre_pedidos
                    FROM produtos_filial p
                        INNER JOIN sys_produtos_combinados_itens spci ON spci.idproduto = p.idproduto
                        JOIN grupo_filial g ON g.filial = p.filial
                        JOIN produtos_combinados_compras_grupo vp ON vp.id_grupo = g.id_grupo AND vp.id_produto_combinado = spci.id_produto_combinado
                    where
                        p.revenda::text = 'S'::text
                        AND p.status::text <> 'FL'::text
                        AND p.status_suprimento_sku::text ~~ '%AGUARDANDO%'::text
                        AND getcompra_transito_grupo(g.id_grupo::numeric, p.idproduto) > 0::NUMERIC
                        AND (f_id_produto_combinado = spci.id_produto_combinado OR f_id_produto_combinado IS NULL)
                    GROUP BY
                        g.id_grupo,
                        p.filial,
                        vp.id_produto_combinado,
                        vp.descricao_produto,
                        vp.compra_transito,
                        vp.produtos,
                        vp.tempo_medio_ressuprimento,
                        vp.consumo_medio_mensal,
                        vp.estoque_maximo,
                        vp.ponto_pedido,
                        vp.tempo_ressuprimento,
                        vp.desvio_padrao_ressuprimento,
                        vp.estoque,
                        vp.fator_conversao,
                        vp.unidade_compra,
                        vp.lote_minimo,
                        vp.data_ultima_requisicao,
                        vp.arvore_decisao,
                        vp.nivel_servico,
                        vp.peso_compras
                ) b
                GROUP BY b.id_grupo, b.id_produto_combinado, b.produtos, b.fator_conversao, b.unidade_compra, b.arvore_decisao, b.nivel_servico, b.peso_compras, b.consumo_transito_grupo_entre_pedidos
            ) analise_entrada
            WHERE analise_entrada.compra_transito > 0::NUMERIC
        ) a
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
          qtde_lote_minimo =  coalesce(rec_transito.lote_minimo,1);
          qtde_cobertura_futura=0;
          consumo_transito_cal = 0;


            --Identificar se o produto tem compra em atraso
            select count(*) into p_atraso
            from analise_requisicoes ar
            where filial in(select filial from grupo_filial gf where gf.id_grupo = rec_transito.id_grupo)
            and idproduto = ANY (rec_transito.produtos) and atraso >= 0 and qtde_pendente > 0;


            -- Pedidos em atraso;
            select  sum(qtde_pendente / spci.fator_conversao) into qtde_transito_atraso
            from analise_requisicoes r
                INNER JOIN sys_produtos_combinados_itens spci ON spci.idproduto = r.idproduto
            where
                spci.id_produto_combinado = rec_transito.id_produto_combinado
                and qtde_pendente > 0
                and atraso >= 0
                and r.filial in (select filial from grupo_filial where id_grupo = rec_transito.id_grupo);

            qtde_transito_atraso = coalesce(qtde_transito_atraso,0);

            --Pedidos em Transito Aberto;
            select  sum(qtde_pendente / spci.fator_conversao) into qtde_transito
            from analise_requisicoes r
                INNER JOIN sys_produtos_combinados_itens spci ON spci.idproduto = r.idproduto
            where
                spci.id_produto_combinado = rec_transito.id_produto_combinado
                and qtde_pendente > 0
                and atraso < 0
                and r.filial in (select filial from grupo_filial where id_grupo= rec_transito.id_grupo);

            qtde_transito = coalesce(qtde_transito, 0);


            -- Parâmetros do Estoque;
            qtde_estoque = rec_transito.estoque;
            p_ponto_pedido = rec_transito.ponto_pedido;
            p_emax = rec_transito.estoque_maximo;
            p_cmm = rec_transito.consumo_medio_mensal;
            p_tr =  rec_transito.tempo_ressuprimento;

            SELECT sum(getconsumo_transito_grupo_new(rec_transito.id_grupo, idproduto) / spci.fator_conversao) INTO p_consumo_transito
            FROM sys_produtos_combinados_itens spci
            WHERE spci.id_produto_combinado = rec_transito.id_produto_combinado;

            --Somente itens atrasados
            if p_atraso > 0 and qtde_transito = 0 then


                qtde_transito = greatest(qtde_transito,0);

                qtde_saldo = qtde_estoque + qtde_transito_atraso + qtde_transito;

                qtde_saldo_residual =  qtde_saldo - p_consumo_transito ;


                if qtde_saldo_residual > p_emax then -- Excesso


                  p_sugestao =  p_emax - qtde_saldo_residual;


                 if abs(p_sugestao) > qtde_transito_atraso then


                    p_sugestao = qtde_transito_atraso *(-1);

                 end if;


                elseif qtde_saldo_residual > p_ponto_pedido AND qtde_saldo_residual <= p_emax AND (qtde_saldo_residual - (p_cmm * 0.30)) > p_ponto_pedido then  -- Adequado


                  p_sugestao = 0;
                  p_status_transito = 'PREVISÃO ADEQUADA';


                elseif qtde_saldo_residual > p_ponto_pedido AND qtde_saldo_residual <= p_emax AND (qtde_saldo_residual - (p_cmm * 0.30)) <= p_ponto_pedido  then

                    SELECT sum(getconsumo_transito_grupo_2(rec_transito.id_grupo, idproduto) / spci.fator_conversao) INTO p_consumo_transito2
                    FROM sys_produtos_combinados_itens spci
                    WHERE spci.id_produto_combinado = rec_transito.id_produto_combinado;

                    p_sugestao =  (p_emax - greatest(qtde_saldo_residual-p_consumo_transito2, 0));



                      qtde_cobertura_futura =  round(qtde_saldo_residual/ greatest(p_cmm, 1),2);

                      if qtde_cobertura_futura < p_tr then


                        p_status_transito = 'PREVISÃO COM ELEVADA EXPOSIÇÃO A RUPTURA';


                        else


                        p_status_transito = 'PREVISÃO COM BAIXA EXPOSIÇÃO A RUPTURA';

                      end if;


                elseif  ( qtde_saldo_residual  <= p_ponto_pedido) then

                  SELECT sum(getconsumo_transito_grupo_2(rec_transito.id_grupo, idproduto) / spci.fator_conversao) INTO p_consumo_transito2
                  FROM sys_produtos_combinados_itens spci
                  WHERE spci.id_produto_combinado = rec_transito.id_produto_combinado;

                  p_sugestao =  (p_emax - greatest(qtde_saldo_residual-p_consumo_transito2, 0)); --
                  qtde_cobertura_futura =  round(qtde_saldo_residual/ greatest(p_cmm, 1),2);


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



                qtde_transito = greatest(qtde_transito,0);

                qtde_saldo = qtde_estoque;


                -- Quantidade de Pedidos Abertos


                cont_ped = 1;

                qtde_saldo_futuro= 0;


                for rec_pedidos in (
                    SELECT data_prevista_cal, sum(qtde / spci.fator_conversao) qtde
                    from analise_requisicoes r
                        INNER JOIN sys_produtos_combinados_itens spci ON spci.idproduto = r.idproduto
                    where
                        spci.id_produto_combinado = rec_transito.id_produto_combinado
                        and qtde_pendente > 0
                        and atraso < 0
                        and r.filial in (select filial from grupo_filial where id_grupo = rec_transito.id_grupo)
                    group by data_prevista_cal
                    order by data_prevista_cal
                )
                 loop


                      if cont_ped = 1 then

                          data_temp= rec_pedidos.data_prevista_cal;
                          qtde_dias =  rec_pedidos.data_prevista_cal - current_date ;
                          p_tr = (qtde_dias/30);


                        else


                         qtde_dias = ((rec_pedidos.data_prevista_cal)  - data_temp) ;
                         p_tr = (qtde_dias/30);
                         data_temp= rec_pedidos.data_prevista_cal;


                     end if;


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


                 end loop;

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

                 if qtde_transito > 0 then

                        select ((current_date + (produtos.tempo_medio_ressuprimento::int4)) - ((current_date + ((vw_requisicoes.data_solicitacao+produtos.tempo_medio_ressuprimento::int4) - current_date)) - current_date) - current_date)::numeric/30  into p_tr
                        FROM vw_requisicoes
                            inner join produtos_filial as produtos ON produtos.filial = vw_requisicoes.filial and produtos.idproduto = vw_requisicoes.idproduto::varchar
                        where
                            vw_requisicoes.idproduto::varchar = ANY (rec_transito.produtos)
                            and vw_requisicoes.filial in (select filial from grupo_filial gf where id_grupo= rec_transito.id_grupo )
                            and data_entrada isnull
                        order by data_solicitacao desc
                        limit 1;
                  end if;


                  p_sugestao = (p_emax - (greatest(qtde_saldo_futuro-(p_cmm *p_tr),0)));



                  qtde_cobertura_futura =  round(qtde_saldo_futuro/ greatest(p_cmm, 1),2);

                  if qtde_cobertura_futura < p_tr then


                    p_status_transito = 'PREVISÃO COM ELEVADA EXPOSIÇÃO A RUPTURA';


                    else


                    p_status_transito = 'PREVISÃO COM BAIXA EXPOSIÇÃO A RUPTURA';

                  end if;


                elseif  ( qtde_saldo_futuro  <= p_ponto_pedido) then



                    if qtde_transito > 0 then

                            select ((current_date + (produtos.tempo_medio_ressuprimento::int4)) - ((current_date + ((vw_requisicoes.data_solicitacao+produtos.tempo_medio_ressuprimento::int4) - current_date)) - current_date) - current_date)::numeric/30  into p_tr
                            from vw_requisicoes
                                inner join produtos_filial  as produtos on  produtos.filial =vw_requisicoes.filial and  produtos.idproduto = vw_requisicoes.idproduto::varchar
                            where
                                vw_requisicoes.idproduto::varchar = ANY (rec_transito.produtos)
                                and vw_requisicoes.filial in (select filial from grupo_filial gf where id_grupo= rec_transito.id_grupo )
                                and data_entrada isnull
                            order by data_solicitacao desc
                            limit 1;

                      end if;


                     p_sugestao = (p_emax - (greatest(qtde_saldo_futuro-(p_cmm *p_tr),0)));


                      qtde_cobertura_futura =  round(qtde_saldo_futuro/ greatest(p_cmm, 1),2);

                      if qtde_cobertura_futura < p_tr then


                        p_status_transito = 'PREVISÃO COM ELEVADA EXPOSIÇÃO A RUPTURA';


                        else


                        p_status_transito = 'PREVISÃO COM BAIXA EXPOSIÇÃO A RUPTURA';

                      end if;



                else

                  p_sugestao = 0;

                  p_status_transito = 'PRODUTO EM TRÂNSITO';


                end if;


             else    -- COMPRAS HIBRIDAS



                qtde_transito = greatest(qtde_transito,0);

                qtde_saldo = qtde_estoque +  qtde_transito_atraso;


                cont_ped = 1;


                qtde_saldo_futuro= 0;


                for rec_pedidos in (
                    select data_prevista_cal, sum(qtde / spci.fator_conversao) qtde
                    from analise_requisicoes r
                        INNER JOIN sys_produtos_combinados_itens spci ON spci.idproduto = r.idproduto
                    where
                        spci.id_produto_combinado = rec_transito.id_produto_combinado
                        and qtde_pendente > 0
                        and atraso < 0
                        and r.filial  in (select filial from grupo_filial where id_grupo= rec_transito.id_grupo )
                    group by data_prevista_cal
                    order by data_prevista_cal
                )

                 loop


                    if cont_ped = 1 then

                          data_temp= rec_pedidos.data_prevista_cal;
                          qtde_dias =  rec_pedidos.data_prevista_cal - current_date ;
                          p_tr = (qtde_dias/30);


                        else


                         qtde_dias = ((rec_pedidos.data_prevista_cal)  - data_temp) ;
                         p_tr = (qtde_dias/30);
                         data_temp= rec_pedidos.data_prevista_cal;


                     end if;



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


                 end loop;



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

                 if qtde_transito > 0 then

                        select ((current_date + (produtos.tempo_medio_ressuprimento::int4)) - ((current_date + ((vw_requisicoes.data_solicitacao+produtos.tempo_medio_ressuprimento::int4) - current_date)) - current_date) - current_date)::numeric/30  into p_tr
                        from vw_requisicoes
                            inner join produtos_filial  as produtos on  produtos.filial =vw_requisicoes.filial and  produtos.idproduto = vw_requisicoes.idproduto::varchar
                        where
                            vw_requisicoes.idproduto::varchar = ANY (rec_transito.produtos)
                            and vw_requisicoes.filial in (select filial from grupo_filial gf where id_grupo= rec_transito.id_grupo )
                            and data_entrada isnull  order by data_solicitacao desc
                        limit 1;

                  end if;


                  p_sugestao = (p_emax - (greatest(qtde_saldo_futuro-(p_cmm *p_tr),0)));


                  qtde_cobertura_futura =  round(qtde_saldo_futuro/ greatest(p_cmm, 1),2);

                  if qtde_cobertura_futura < p_tr then


                    p_status_transito = 'PREVISÃO COM ELEVADA EXPOSIÇÃO A RUPTURA';


                    else


                    p_status_transito = 'PREVISÃO COM BAIXA EXPOSIÇÃO A RUPTURA';

                  end if;


                elseif  ( qtde_saldo_futuro  <= p_ponto_pedido) then



                    if qtde_transito > 0 then

                        select ((current_date + (produtos.tempo_medio_ressuprimento::int4)) - ((current_date + ((vw_requisicoes.data_solicitacao+produtos.tempo_medio_ressuprimento::int4) - current_date)) - current_date) - current_date)::numeric/30  into p_tr
                        from vw_requisicoes
                            inner join produtos_filial  as produtos on  produtos.filial =vw_requisicoes.filial and  produtos.idproduto = vw_requisicoes.idproduto::varchar
                        where
                            vw_requisicoes.idproduto::varchar = ANY (rec_transito.produtos)
                            and vw_requisicoes.filial in (select filial from grupo_filial gf where id_grupo= rec_transito.id_grupo )
                            and data_entrada isnull
                        order by data_solicitacao desc
                        limit 1;

                    end if;

                     p_sugestao = (p_emax - (greatest(qtde_saldo_futuro-(p_cmm *p_tr),0)));

                      qtde_cobertura_futura =  round(qtde_saldo_futuro/ greatest(p_cmm, 1),2);

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

            -- Ajuste para Analisar os pedidos em compras após 15 dias
              if rec_transito.tempo_pedido  <= 2  then
                  p_sugestao = 0;
                  p_status_transito = 'PREVISÃO ADEQUADA';
              end if;

          IF p_status_transito IS NULL THEN
              p_status_transito = 'PRODUTO EM TRÂNSITO';
          END IF;

          update
            produtos_combinados_transito_grupo
            set
                compra_transito = rec_transito.compra_transito,
                consumo_transito = rec_transito.consumo_transito,
                saldo_futuro = rec_transito.saldo_futuro,
                status = p_status_transito,
                lote_compras = p_sugestao,
                data_ultima_requisicao = rec_transito.data_ultima_requisicao,
                tempo_pedido = rec_transito.tempo_pedido,
                gatilho_transito = rec_transito.gatilho_transito,
                flag = null,
                processamento = current_timestamp
            where
                id_grupo = rec_transito.id_grupo
                and id_produto_combinado = rec_transito.id_produto_combinado;


        if not found then

             insert into produtos_combinados_transito_grupo (
                    id_grupo,
                    id_produto_combinado,
                    compra_transito,
                    consumo_transito,
                    saldo_futuro,
                    status,
                    lote_compras,
                    data_ultima_requisicao,
                    tempo_pedido,
                    gatilho_transito,
                    flag,
                    processamento
                )
                values(
                    rec_transito.id_grupo,
                    rec_transito.id_produto_combinado,
                    rec_transito.compra_transito,
                    rec_transito.consumo_transito,
                    rec_transito.saldo_futuro,
                    p_status_transito,
                    p_sugestao,
                    rec_transito.data_ultima_requisicao,
                    rec_transito.tempo_pedido,
                    rec_transito.gatilho_transito,
                    null,
                    current_timestamp
                );

            end if;

        end loop;

        delete from  produtos_combinados_transito_grupo  where  flag ='D';

    end $function$

