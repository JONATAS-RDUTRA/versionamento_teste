CREATE OR REPLACE FUNCTION public.get_calculo_parametros_estoque(p_filial numeric, idprod character varying, arv_decisao character varying, dataref date DEFAULT ('now'::text)::date)
 RETURNS TABLE(estoque_seguranca numeric, estoque numeric, ponto_pedido numeric, estoque_maximo numeric, consumo_medio numeric, std_consumo_medio numeric, sugestao numeric, fes numeric, nivel_servico character varying)
 LANGUAGE plpgsql
AS $function$ 
declare 

v_fes numeric;
cmm numeric;
eseg numeric;
ppd numeric;
emax numeric;
temp_ressup numeric;
sdv_ressup numeric;
sdv_csm numeric;
perfil varchar;
lote_compras numeric;
est numeric;
lote_min numeric;
v_nivel_servico varchar;

begin
	
select
	coalesce(sf.tempo_ressuprimento, pf.tempo_ressuprimento),
	coalesce(sf.desvio_padrao_ressuprimento, pf.desvio_padrao_ressuprimento),
	getFes(arv_decisao),
	getnivelservico(arv_decisao),
	coalesce(get_cmm_filial(pf.filial, pf.idproduto, dataref), 0),
	coalesce(get_stddev_consumo(pf.filial, pf.idproduto, dataref), 0),
	perfil_demanda,
	get_estoque_diario_filial(p_filial,idprod,dataref),
	coalesce(pf.lote_minimo, 1)
into
	temp_ressup,
	sdv_ressup,
	v_fes,
	v_nivel_servico,
	cmm,
	sdv_csm,
	perfil,
	est,
	lote_min
from
	produtos_filial pf
left join saldo_filiais sf on
	sf.filial = pf.filial
	and sf.idproduto = pf.idproduto
	and sf."data" = dataref
where
	pf.filial = p_filial
	and pf.idproduto = idprod;


--invalidar cortes maiores que a saida
 if cmm <= 0 then cmm = 0;
end if;

if est <= 0 then est = 0;
end if;
--Estoque de Segurança
 if sdv_csm = 0 then eseg = round((cmm * v_fes), 2) ;
else eseg = round((sdv_csm * v_fes), 2) ;
end if;

if perfil = 'OCASIONAL' then eseg = round(((cmm / 2) * v_fes), 2) ;
end if;
--Ponto de Pedido;
 ppd = round((eseg + (cmm * (temp_ressup + sdv_ressup))), 2);
--Estoque Máximo
 emax = ppd + cmm ;
--Lote de Compras
 if perfil <> 'OCASIONAL' then lote_compras = (round((emax +(cmm*(temp_ressup + sdv_ressup))-est), 2));
else ppd = round((eseg + ((cmm / 2) * (temp_ressup + sdv_ressup))), 2);

emax = ppd + (cmm / 2);

lote_compras = ceil((cmm / 2));
end if;

if lote_compras <= 0 then lote_compras = 0;
end if;

fes := v_fes;
nivel_servico :=v_nivel_servico;

if cmm <= 0 then estoque_seguranca := 0;

estoque_maximo := 0;

ponto_pedido := 0;

consumo_medio := 0;

sugestao := 0;

estoque := est;

std_consumo_medio := 0;

else 

estoque_seguranca := eseg;

estoque_maximo := emax;

ponto_pedido := ppd;

consumo_medio := cmm;

if est <= ppd and cmm > 0 then 
	sugestao := gerar_lote_embalagem(lote_compras,lote_min);
else 
    sugestao := 0;
end if;

estoque := est;
std_consumo_medio := sdv_csm;

end if;

return next;
end;

$function$

