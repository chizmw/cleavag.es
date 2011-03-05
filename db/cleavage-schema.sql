-- createuser --no-superuser --no-createdb --no-createrole cleavages
-- createdb --encoding=UTF8 --owner=cleavages cleavages
-- psql -d cleavages -f db/cleavage-schema.sql

BEGIN;

    CREATE TABLE person (
        id                  SERIAL      PRIMARY KEY,

        username            text        NOT NULL,
        password            text        NOT NULL,

        email               text        NOT NULL,
        first_name          text,
        last_name           text,

        UNIQUE(username),
        UNIQUE(email)
    );
    ALTER TABLE person OWNER TO cleavages;

    CREATE TABLE gender (
        id                  SERIAL      PRIMARY KEY,
        name                text        NOT NULL,

        UNIQUE(name)
    );
    ALTER TABLE gender OWNER TO cleavages;
    INSERT INTO gender (id, name)
    VALUES
        ( 1, 'Male'   ),
        ( 2, 'Female' )
    ;

    CREATE TABLE cleavage_type (
        id                  SERIAL      PRIMARY KEY,
        name                text        NOT NULL,

        UNIQUE(name)
    );
    ALTER TABLE cleavage_type OWNER TO cleavages;
    INSERT INTO cleavage_type (id, name)
    VALUES
        ( 1, 'Top'    ),
        ( 2, 'Bottom' )
    ;

    CREATE TABLE cleavage_relation (
        id                  SERIAL      PRIMARY KEY,
        name                text        NOT NULL,

        UNIQUE(name)
    );
    ALTER TABLE cleavage_relation OWNER TO cleavages;
    INSERT INTO cleavage_relation (id, name)
    VALUES
        ( 1, 'Mine'    ),
        ( 2, 'Know It' ),
        ( 3, 'Random'  )
    ;

    CREATE TABLE file (
        id                  SERIAL      PRIMARY KEY,
        md5_hex             char(32)    NOT NULL,

        filename            text        NOT NULL,
        filepath            text        NOT NULL,
        mime_type           varchar(50) NOT NULL,

        uploaded_by         integer     NOT NULL    references person(id),
        uploaded            timestamp with time zone NOT NULL
                            DEFAULT CURRENT_TIMESTAMP,

        gender              integer     NOT NULL    references gender(id),
        cleavage_type       integer     NOT NULL    references cleavage_type(id),
        cleavage_relation   integer     NOT NULL    references cleavage_relation(id),

        UNIQUE(md5_hex),
        UNIQUE(filepath)
    );
    ALTER TABLE file OWNER TO cleavages;

COMMIT;
