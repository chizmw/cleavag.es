BEGIN;
    -- add "remain anonymous" column
    ALTER TABLE file
        ADD COLUMN remain_anonymous boolean
            NOT NULL
            DEFAULT FALSE;
    -- add "yes, I as allowed to upload" column
    ALTER TABLE file
        ADD COLUMN verified_permission boolean
            NOT NULL
            DEFAULT FALSE;
COMMIT;
