CREATE OR REPLACE FUNCTION public.processar_prismas_grupo(p_dataref date DEFAULT ('now'::text)::date)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
declare
rec_dados record;

begin 


       
  	for rec_dados in (
  	     select gf.id_grupo,idproduto,data_ref,min(substring(arvore_decisao,1,1))||max(substring(arvore_decisao,2,1))||min(substring(arvore_decisao,3,1))||min(substring(arvore_decisao,4,1)) arv_decisao_grupo,
		   getFes(min(substring(arvore_decisao,1,1))||max(substring(arvore_decisao,2,1))||min(substring(arvore_decisao,3,1))||min(substring(arvore_decisao,4,1))) as fes_grupo,
		   getnivelservico(min(substring(arvore_decisao,1,1))||max(substring(arvore_decisao,2,1))||min(substring(arvore_decisao,3,1))||min(substring(arvore_decisao,4,1))) nivel_servico
		   from prismas_filiais pf
		   inner join grupo_filial gf 
		   on gf.filial = pf.filial 
		   where data_ref=first_day(p_dataref)
		   group by gf.id_grupo,idproduto,data_ref
  	)
      loop
      
        UPDATE prismas_grupos pf
		SET arvore_decisao=rec_dados.arv_decisao_grupo,fes=rec_dados.fes_grupo,nivel_servico=rec_dados.nivel_servico
		WHERE pf.id_grupo=rec_dados.id_grupo AND pf.idproduto=rec_dados.idproduto and pf.data_ref = first_day(p_dataref);

	   if not found then
	   
	   	 INSERT INTO prismas_grupos
			(id_grupo, idproduto, arvore_decisao,data_ref,fes,nivel_servico )
			VALUES(rec_dados.id_grupo,rec_dados.idproduto,rec_dados.arv_decisao_grupo,first_day(p_dataref),rec_dados.fes_grupo,rec_dados.nivel_servico);
	   
	   
	   end if;
      
      
      end loop;
       


end;$function$

