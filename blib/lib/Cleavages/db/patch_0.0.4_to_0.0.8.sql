BEGIN;
    -- add thumbnail column
    ALTER TABLE file
        ADD COLUMN thumbnail text NULL;
COMMIT;
