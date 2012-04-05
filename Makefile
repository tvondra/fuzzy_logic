EXTENSION = godel_logic lukasiewicz_logic product_logic
DATA = sql/godel_logic--1.0.0.sql sql/lukasiewicz_logic--1.0.0.sql sql/product_logic--1.0.0.sql

CFLAGS=`pg_config --includedir-server`

TESTS        = $(wildcard test/sql/*.sql)
REGRESS      = $(patsubst test/sql/%.sql,%,$(TESTS))
REGRESS_OPTS = --inputdir=test

PG_CONFIG = pg_config
PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)

