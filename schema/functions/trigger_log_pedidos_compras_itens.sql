CREATE OR REPLACE FUNCTION public.trigger_log_pedidos_compras_itens()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
	pedido_compra record;
	parametros_compra record;
BEGIN
	-- No DELETE apenas a coluna de deleted_at é atualizada e a função é interrompida
	IF (TG_OP = 'DELETE') THEN -- TG_OP: OPERACAO_TRIGGER: INSERT, UPDATE, DELETE

		UPDATE log_pedidos_compras_itens
		SET deleted_at = current_timestamp
		WHERE
			idpedido = OLD.idpedido
			AND idproduto = OLD.idproduto
			AND deleted_at IS NULL;

		RETURN OLD;

	END IF;

	-- Atualiza ou cria novo registro. TG_OP = INSERT OU UPDATE

	-- Busca o pedido de compra
	SELECT grupo, filial_compra AS filial INTO pedido_compra
	FROM pedidos_compras pc
	WHERE pc.idpedido = NEW.idpedido;

	-- Busca os parametros de compra
	SELECT
	    COALESCE(sum(p.estoque * p.fator_conversao), 0) AS estoque,
	    COALESCE(sum(p.estoque_seguranca * p.fator_conversao), 0) AS eseg,
	    COALESCE(sum(p.ponto_pedido * p.fator_conversao), 0) AS pp,
	    COALESCE(sum(p.estoque_maximo * p.fator_conversao), 0) AS emax,
	    COALESCE(sum(p.consumo_medio_mensal * p.fator_conversao), 0) AS cmm,
	    COALESCE(avg(p.tempo_medio_ressuprimento), 0) AS tr
	    INTO
	    parametros_compra
	FROM produtos_filial p
		INNER JOIN grupo_filial gf ON gf.filial = p.filial
	WHERE
		gf.id_grupo = pedido_compra.grupo
		AND (p.filial = pedido_compra.filial OR pedido_compra.filial = 0)
		AND p.idproduto = NEW.idproduto;


	UPDATE public.log_pedidos_compras_itens
	SET
		estoque = parametros_compra.estoque,
		eseg = parametros_compra.eseg,
		pp = parametros_compra.pp,
		emax = parametros_compra.emax,
		cmm = parametros_compra.cmm,
		tr = parametros_compra.tr,
		sugerido = COALESCE(NEW.sugerido, 0),
		qtde_pedido = COALESCE(NEW.qtde_pedido, 0),
		updated_at = current_timestamp
	WHERE
		idpedido = NEW.idpedido
		AND idproduto = NEW.idproduto
		AND deleted_at IS NULL;

	IF (NOT FOUND) THEN

		INSERT INTO public.log_pedidos_compras_itens (
			idpedido,
			idproduto,
			estoque,
			eseg,
			pp,
			emax,
			cmm,
			tr,
			sugerido,
			qtde_pedido,
			tipo_compra,
			created_at,
			updated_at
		)
		VALUES (
			NEW.idpedido,
			NEW.idproduto,
			parametros_compra.estoque,
			parametros_compra.eseg,
			parametros_compra.pp,
			parametros_compra.emax,
			parametros_compra.cmm,
			parametros_compra.tr,
			COALESCE(NEW.sugerido, 0),
			COALESCE(NEW.qtde_pedido, 0),
			NEW.tipo_compra,
			current_timestamp,
			current_timestamp
		);

	END IF;

	RETURN NEW;
END
$function$

