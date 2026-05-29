CREATE OR REPLACE FUNCTION public.processar_filtros_produto(p_forn integer DEFAULT 0, p_filial boolean DEFAULT false)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
        declare
    
            produto_rec record;
            f_item_novo bool;
            f_com_movimentacao bool;
            f_sem_movimentacao bool;
            f_similar bool;
            f_heranca bool;
            f_influencia_previsao bool;
            movimentacao numeric;
            existe numeric;
    
        begin
            --filial
            if p_filial then
                for produto_rec in (
                    select
                        (select id_grupo from grupo_filial gf where gf.filial=pf.filial limit 1) as grupo,
                        pf.filial,
                        pf.idfornecedor,
                        pf.idproduto,
                        pf.heranca,
                        pf.fator_atuacao,
                        (pf.estoque > pf.estoque_maximo) AS em_excesso,
                        (pf.estoque > pf.ponto_pedido AND pf.estoque <= pf.estoque_maximo) AS nivel_adequado,
                        (pf.estoque > 0 AND pf.consumo_medio_mensal > 0 AND pf.estoque <= pf.ponto_pedido AND pf.cobertura_estoque >= pf.tempo_medio_ressuprimento) AS baixa_exposicao_ruptura,
                        (pf.estoque > 0 AND pf.consumo_medio_mensal > 0 AND pf.estoque <= pf.ponto_pedido AND pf.cobertura_estoque < pf.tempo_medio_ressuprimento) AS elevada_exposicao_ruptura,
                        (pf.estoque = 0 AND pf.consumo_medio_mensal > 0) AS em_ruptura
                    from produtos_filial pf 
                      inner join grupo_filial gf
                       on gf.id_grupo = pf.grupo_compra 
                    where pf.idfornecedor = p_forn and pf.revenda='S' and pf.status <> 'FL'
                )
                loop
        
                    f_item_novo = false;
                    f_com_movimentacao = false;
                    f_sem_movimentacao = false;
        
                    -- Verificação Movimentos
                    select case when max(emissao) = min(emissao) then 1 else coalesce(max(emissao)-min(emissao),0) end into movimentacao 
                    from consumos c 
                    where c.filial=produto_rec.filial 
                        and c.idproduto=produto_rec.idproduto
                        and c.emissao between (current_date - 180) and current_date;
        
                    if movimentacao > 90 then
                        f_com_movimentacao=true;
                    elsif movimentacao > 0 and movimentacao <= 90  then
                        f_item_novo=true;
                    else
                        f_sem_movimentacao=true;
                        f_item_novo=true;
                    end if;
        
                    -- Verificação Similares
        
                    select (case when (count(*) > 0) then true else false end) into f_similar from similares s where id_item_pai=produto_rec.idproduto;
        
                    -- Verificação Herança
        
                    if produto_rec.heranca notnull and produto_rec.heranca not in ('', ' ') then
                        f_heranca = true;
                    else
                        f_heranca = false;
                    end if;
        
                    -- Verifcação Fator de Atuação
        
                    if produto_rec.fator_atuacao <> 1 then
                        f_influencia_previsao = true;
                    else
                        f_influencia_previsao = false;
                    end if;
        
                    select count(*) into existe
                    from filtros_produto fp
                    where fp.idgrupo = produto_rec.grupo
                        and fp.idfilial = produto_rec.filial
                        and fp.idfornecedor = produto_rec.idfornecedor
                        and fp.idproduto = produto_rec.idproduto;
                    
                        --insert ou update
                    if existe > 0 then

                        update filtros_produto
                            set (item_novo, com_movimentacao, sem_movimentacao, "similar", heranca, ciclo_vida, sazonalidade, evento, influencia_previsao, excesso, adequado, baixa_exposicao_ruptura, elevada_exposicao_ruptura, ruptura)
                            =
                            (f_item_novo, f_com_movimentacao, f_sem_movimentacao, f_similar, f_heranca, false, false, false, f_influencia_previsao,produto_rec.em_excesso, produto_rec.nivel_adequado, produto_rec.baixa_exposicao_ruptura, produto_rec.elevada_exposicao_ruptura, produto_rec.em_ruptura)
                        where idgrupo=produto_rec.grupo
                            and idfilial=produto_rec.filial
                            and idfornecedor=produto_rec.idfornecedor
                            and idproduto=produto_rec.idproduto;

                    else

                        insert into filtros_produto
                        values (produto_rec.grupo, produto_rec.filial, produto_rec.idfornecedor, produto_rec.idproduto, f_item_novo, f_com_movimentacao, f_sem_movimentacao, f_similar, f_heranca, false, false, false, f_influencia_previsao, produto_rec.em_excesso, produto_rec.nivel_adequado, produto_rec.baixa_exposicao_ruptura, produto_rec.elevada_exposicao_ruptura, produto_rec.em_ruptura);

                    end if;
        
                end loop;
            -- grupo
            else
            
                for produto_rec in (
                   
                    with heranca_grupo as (
                  
                        select gf.id_grupo ,pf.idproduto, max(heranca) as heranca 
                         from produtos_filial pf 
                          inner join grupo_filial gf
                           on gf.filial = pf.filial 
                         where  pf.idfornecedor =  p_forn
                         group by gf.id_grupo ,pf.idproduto
                   )
                
                    select 
                        vg.id_grupo as grupo,
                        0 as filial,
                        vg.idfornecedor,
                        vg.idproduto,
                        hg.heranca,
                        vg.fator_atuacao,
                        (vg.estoque = 0 AND vg.consumo_medio_mensal > 0) AS em_ruptura,
                        (vg.estoque > vg.estoque_maximo) AS em_excesso,
                        (vg.estoque > vg.ponto_pedido AND vg.estoque <= vg.estoque_maximo) AS nivel_adequado,
                        (vg.estoque > 0 AND vg.consumo_medio_mensal > 0 AND vg.estoque <= vg.ponto_pedido AND vg.cobertura_estoque >= vg.tempo_medio_ressuprimento) AS baixa_exposicao_ruptura,
                        (vg.estoque > 0 AND vg.consumo_medio_mensal > 0 AND vg.estoque <= vg.ponto_pedido AND vg.cobertura_estoque < vg.tempo_medio_ressuprimento) AS elevada_exposicao_ruptura
                    from vw_grupo_compras_produtos_mt vg
                      left join heranca_grupo hg 
                       on hg.id_grupo = vg.id_grupo 
                       and hg.idproduto = vg.idproduto 
                    where vg.idfornecedor = p_forn and vg.revenda='S' and vg.status <> 'FL'

                )
                loop
        
                    f_item_novo = false;
                    f_com_movimentacao = false;
                    f_sem_movimentacao = false;
        
                    -- Verificação Movimentos
                    select case when max(emissao) = min(emissao) then 1 else coalesce(max(emissao)-min(emissao),0) end into movimentacao  
                    from consumos c 
                    where c.filial in (select filial from grupo_filial gf where gf.id_grupo=produto_rec.grupo) 
                        and c.idproduto=produto_rec.idproduto
                        and c.emissao between (current_date - 180) and current_date;
        
                    if movimentacao > 90 then
                        f_com_movimentacao=true;
                    elsif movimentacao > 0 and movimentacao <= 90  then
                        f_item_novo=true;
                    else
                        f_sem_movimentacao=true;
                        f_item_novo=true;
                    end if;
        
                    -- Verificação Similares
        
                    select (case when (count(*) > 0) then true else false end) into f_similar from similares s where id_item_pai=produto_rec.idproduto;
        
                    -- Verificação Herança
        
                    if produto_rec.heranca notnull and produto_rec.heranca not in ('', ' ') then
                        f_heranca = true;
                    else
                        f_heranca = false;
                    end if;
        
                    -- Verifcação Fator de Atuação
        
                    if produto_rec.fator_atuacao <> 1 then
                        f_influencia_previsao = true;
                    else
                        f_influencia_previsao = false;
                    end if;
        
                    select count(*) into existe
                    from filtros_produto fp
                    where fp.idgrupo = produto_rec.grupo
                        and fp.idfilial = produto_rec.filial
                        and fp.idfornecedor = produto_rec.idfornecedor
                        and fp.idproduto = produto_rec.idproduto;
                    
                    
                    
                    --insert ou update
                    if existe > 0 then

                        update filtros_produto
                            set (item_novo, com_movimentacao, sem_movimentacao, "similar", heranca, ciclo_vida, sazonalidade, evento, influencia_previsao, excesso, adequado, baixa_exposicao_ruptura, elevada_exposicao_ruptura, ruptura)
                            =
                            (f_item_novo, f_com_movimentacao, f_sem_movimentacao, f_similar, f_heranca, false, false, false, f_influencia_previsao, produto_rec.em_excesso, produto_rec.nivel_adequado, produto_rec.baixa_exposicao_ruptura, produto_rec.elevada_exposicao_ruptura, produto_rec.em_ruptura)
                        where idgrupo=produto_rec.grupo
                            and idfilial=produto_rec.filial
                            and idfornecedor=produto_rec.idfornecedor
                            and idproduto=produto_rec.idproduto;

                    else

                        insert into filtros_produto
                        values (produto_rec.grupo, produto_rec.filial, produto_rec.idfornecedor, produto_rec.idproduto, f_item_novo, f_com_movimentacao, f_sem_movimentacao, f_similar, f_heranca, false, false, false, f_influencia_previsao, produto_rec.em_excesso, produto_rec.nivel_adequado, produto_rec.baixa_exposicao_ruptura, produto_rec.elevada_exposicao_ruptura, produto_rec.em_ruptura);

                    end if;
        
                end loop;
            
            end if;
        end
    $function$

