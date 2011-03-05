BEGIN;
    -- add URL to comply with attribution usage requirements
    ALTER TABLE file
        ADD COLUMN attribution_url text
            NULL;
COMMIT;
