#!/usr/bin/env bash
./script/cleavages_create.pl \
    model \
    Cleavages \
    DBIC::Schema \
    Cleavages::Schema \
    create=static \
    dbi:Pg:dbname=cleavages \
    cleavages
