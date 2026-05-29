CREATE OR REPLACE FUNCTION public.gerar_saldos_diario_prod(produto character varying, dataini date, datafim date)
 RETURNS void
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
begin

  for rec_prod in (select idproduto,tempo_ressuprimento,desvio_padrao_ressuprimento from produtos where idproduto=produto order by idproduto)
  loop

    for rec_data in (SELECT to_char(day :: date, 'DD/MM/YYYY') as data
                     FROM generate_series(dataini, datafim, '1 day') day)
    loop

        saldo_com =(select get_consumo_diario(rec_prod.idproduto,rec_data.data::date));
        saldo_ent =(select get_entradas(rec_prod.idproduto,rec_data.data::date));
        saldo_est =(select get_estoque_diario(rec_prod.idproduto,rec_data.data::date));


        if saldo_est < 0 then saldo_est = 0; end if;
       
        existe = (select count(*) from saldos where idproduto =rec_prod.idproduto and saldos.data = rec_data.data::date);

        if existe = 0 then

            insert into  saldos (idproduto, data,ano, mes, trimestre,cod_trimestre, entradas, saidas, estoque,processamento,tempo_ressuprimento,desvio_padrao_ressuprimento)  
                values (rec_prod.idproduto,rec_data.data::date,date_part('year', rec_data.data::date),date_part('month', rec_data.data::date),
                 date_part('quarter', rec_data.data::date),to_char(rec_data.data::date,'YYYYQ')::numeric,saldo_ent,saldo_com,saldo_est,current_timestamp,rec_prod.tempo_ressuprimento,rec_prod.desvio_padrao_ressuprimento);

          else

          update saldos set entradas=saldo_ent, saidas=saldo_com, estoque=saldo_est,processamento=current_timestamp where idproduto =rec_prod.idproduto and data = rec_data.data::date;

        end if;
      

    end loop;

  end loop;
 
end;

$function$

