BEGIN;
    -- tables to store (individual file) ratings in
    CREATE TABLE file_rating (
        id                  SERIAL                      PRIMARY KEY,
        created             timestamp with time zone    NOT NULL
                            DEFAULT CURRENT_TIMESTAMP,

        file_id             integer                     NOT NULL
                            REFERENCES file(id),
        rating              integer                     NOT NULL,
--      rated_by            integer                     NOT NULL
--                          REFERENCES person(id)

        ip_addr             inet                        NOT NULL
    );
    ALTER TABLE file_rating OWNER TO cleavages;

    -- table to store rating summaries
    CREATE TABLE file_rating_summary (
        id                  SERIAL                      PRIMARY KEY,
        file_md5            text                        NOT NULL,
        current_rating      real                        NOT NULL
                            DEFAULT 0,
        votes_made          integer                     NOT NULL
                            DEFAULT 1,

        -- only one summary per file
        UNIQUE(file_md5)
    );
    ALTER TABLE file_rating_summary OWNER TO cleavages;

    -- ADD fk from file to its rating summary
    ALTER TABLE file
        ADD COLUMN rating_summary integer NULL
            REFERENCES file_rating_summary(id);
COMMIT;
