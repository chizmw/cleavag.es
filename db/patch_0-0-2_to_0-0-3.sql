BEGIN;
    CREATE TABLE sessions (
        id              CHAR(72) PRIMARY KEY,
        session_data    TEXT,
        expires         INTEGER,

        -- we like to know when a session was created
        created         timestamp with time zone
                        default CURRENT_TIMESTAMP
                        not null
    );
    ALTER TABLE sessions OWNER TO cleavages;
COMMIT;
