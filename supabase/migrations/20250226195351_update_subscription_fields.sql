-- Update subscriptions table field names
DO $$
BEGIN
    -- Check if stripe_id exists and polar_id doesn't
    IF EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_schema = 'public' 
        AND table_name = 'subscriptions' 
        AND column_name = 'stripe_id'
    ) AND NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_schema = 'public' 
        AND table_name = 'subscriptions' 
        AND column_name = 'polar_id'
    ) THEN
        ALTER TABLE public.subscriptions RENAME COLUMN stripe_id TO polar_id;
    END IF;

    -- Check if stripe_price_id exists and polar_price_id doesn't
    IF EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_schema = 'public' 
        AND table_name = 'subscriptions' 
        AND column_name = 'stripe_price_id'
    ) AND NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_schema = 'public' 
        AND table_name = 'subscriptions' 
        AND column_name = 'polar_price_id'
    ) THEN
        ALTER TABLE public.subscriptions RENAME COLUMN stripe_price_id TO polar_price_id;
    END IF;
END
$$;

-- Handle indexes for subscriptions table
DO $$
BEGIN
    -- Drop the old index if it exists
    IF EXISTS (
        SELECT 1 FROM pg_indexes 
        WHERE schemaname = 'public' 
        AND tablename = 'subscriptions' 
        AND indexname = 'subscriptions_stripe_id_idx'
    ) THEN
        DROP INDEX public.subscriptions_stripe_id_idx;
    END IF;

    -- Create new index if it doesn't exist
    IF NOT EXISTS (
        SELECT 1 FROM pg_indexes 
        WHERE schemaname = 'public' 
        AND tablename = 'subscriptions' 
        AND indexname = 'subscriptions_polar_id_idx'
    ) THEN
        CREATE INDEX subscriptions_polar_id_idx ON public.subscriptions(polar_id);
    END IF;
END
$$;

-- Update webhook_events table field names
DO $$
BEGIN
    -- Check if stripe_event_id exists and polar_event_id doesn't
    IF EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_schema = 'public' 
        AND table_name = 'webhook_events' 
        AND column_name = 'stripe_event_id'
    ) AND NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_schema = 'public' 
        AND table_name = 'webhook_events' 
        AND column_name = 'polar_event_id'
    ) THEN
        ALTER TABLE public.webhook_events RENAME COLUMN stripe_event_id TO polar_event_id;
    END IF;

    -- Add error column if it doesn't exist
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_schema = 'public' 
        AND table_name = 'webhook_events' 
        AND column_name = 'error'
    ) THEN
        ALTER TABLE public.webhook_events ADD COLUMN error text;
    END IF;
END
$$;

-- Handle indexes for webhook_events table
DO $$
BEGIN
    -- Drop the old index if it exists
    IF EXISTS (
        SELECT 1 FROM pg_indexes 
        WHERE schemaname = 'public' 
        AND tablename = 'webhook_events' 
        AND indexname = 'webhook_events_stripe_event_id_idx'
    ) THEN
        DROP INDEX public.webhook_events_stripe_event_id_idx;
    END IF;

    -- Create new index if it doesn't exist
    IF NOT EXISTS (
        SELECT 1 FROM pg_indexes 
        WHERE schemaname = 'public' 
        AND tablename = 'webhook_events' 
        AND indexname = 'webhook_events_polar_event_id_idx'
    ) THEN
        CREATE INDEX webhook_events_polar_event_id_idx ON public.webhook_events(polar_event_id);
    END IF;
END
$$;
