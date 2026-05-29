CREATE OR REPLACE FUNCTION public.update_cotacao_transacao_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
            BEGIN
                NEW.updated_at = CURRENT_TIMESTAMP;
                RETURN NEW;
            END;
            $function$

