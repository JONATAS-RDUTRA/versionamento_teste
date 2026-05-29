CREATE OR REPLACE FUNCTION public.audit_ddl()
 RETURNS event_trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
    r RECORD;
BEGIN

    FOR r IN
        SELECT *
        FROM pg_event_trigger_ddl_commands()
    LOOP

        IF r.command_tag IN (
            'GRANT',
            'REVOKE',
            'COMMENT'
        )
        THEN
            CONTINUE;
        END IF;

        IF r.schema_name IN (
            'pg_catalog',
            'information_schema'
        )
        THEN
            CONTINUE;
        END IF;

        INSERT INTO ddl_changelog (
            usuario,
            comando,
            tipo_objeto,
            objeto,
            schema_nome,
            sql_original
        )
        VALUES (
            session_user,
            r.command_tag,
            r.object_type,
            r.object_identity,
            r.schema_name,
            current_query()
        );

        INSERT INTO ddl_queue (
            schema_nome,
            objeto,
            tipo_objeto,
            comando,
            usuario,
            ultima_alteracao,
            processado
        )
        VALUES (
            r.schema_name,
            r.object_identity,
            r.object_type,
            r.command_tag,
            session_user,
            now(),
            false
        )

        ON CONFLICT (schema_nome, objeto)

        DO UPDATE SET
            tipo_objeto = EXCLUDED.tipo_objeto,
            comando = EXCLUDED.comando,
            usuario = EXCLUDED.usuario,
            ultima_alteracao = now(),
            processado = false;

    END LOOP;

END;
$function$

