CREATE OR REPLACE FUNCTION public.gerar_saldos_diario_filial_prod(p_filial bigint, p_prod character varying, dataini date DEFAULT ('now'::text)::date, datafim date DEFAULT ('now'::text)::date)
 RETURNS character varying
 LANGUAGE plpgsql
AS $function$

declare

  retorno  character varying;

  rec_data record;

  rec_prod record;

  saldo_ent numeric;

  saldo_com numeric;

  saldo_est numeric;

  existe numeric;

  saida varchar;
 
  arv varchar;

begin
	
for rec_prod in (select filial,idproduto,tempo_ressuprimento,desvio_padrao_ressuprimento,data_cadastro,arvore_decisao from produtos_filial pf where pf.filial = p_filial and pf.idproduto = p_prod order by idproduto,filial)
  loop



    for rec_data in (SELECT to_char(day :: date, 'DD/MM/YYYY') as data

                     FROM generate_series(dataini, datafim, '1 day') day)

    loop

    
        saldo_com =(select get_consumo_diario_filial(rec_prod.filial,rec_prod.idproduto,rec_data.data::date));

        saldo_ent =(select get_entradas_filial(rec_prod.filial,rec_prod.idproduto,rec_data.data::date));

        saldo_est =(select get_estoque_diario_filial(rec_prod.filial,rec_prod.idproduto,rec_data.data::date));
       
        select coalesce(arvore_decisao,'CX2R') into arv from prismas_filiais pf  where filial=rec_prod.filial and idproduto =rec_prod.idproduto and data_ref = date_trunc('month',rec_data.data::date);


        if saldo_est < 0 then saldo_est = 0; end if;

       
        update saldo_filiais set entradas=saldo_ent, saidas=saldo_com, estoque=saldo_est,tempo_ressuprimento=rec_prod.tempo_ressuprimento,
               desvio_padrao_ressuprimento=rec_prod.desvio_padrao_ressuprimento,processamento=current_timestamp,arvore_decisao = arv
        where filial= rec_prod.filial and idproduto =rec_prod.idproduto and data = rec_data.data::date;
       
       
        if not found then 
        
            insert into  saldo_filiais (filial,idproduto, data,ano, mes, trimestre,cod_trimestre, entradas, saidas, estoque,processamento,tempo_ressuprimento,desvio_padrao_ressuprimento,arvore_decisao)  

                values (rec_prod.filial,rec_prod.idproduto,rec_data.data::date,date_part('year', rec_data.data::date),date_part('month', rec_data.data::date),

               date_part('quarter', rec_data.data::date),to_char(rec_data.data::date,'YYYYQ')::numeric,saldo_ent,saldo_com,saldo_est,current_timestamp,rec_prod.tempo_ressuprimento,rec_prod.desvio_padrao_ressuprimento,arv);
        
        end if;
      

    end loop;

  end loop;
   
return '1';

end;

$function$

