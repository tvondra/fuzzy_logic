CREATE DOMAIN fuzzy_boolean AS FLOAT CHECK (VALUE BETWEEN 0 AND 1);

CREATE FUNCTION product_conjunction(a fuzzy_boolean, b fuzzy_boolean) RETURNS fuzzy_boolean AS $$
	SELECT ($1*$2)::fuzzy_boolean;
$$ LANGUAGE SQL;

CREATE FUNCTION product_disjunction(a fuzzy_boolean, b fuzzy_boolean) RETURNS fuzzy_boolean AS $$
	SELECT ($1 + $2 - $1*$2)::fuzzy_boolean;
$$ LANGUAGE SQL;

CREATE FUNCTION product_residuum(a fuzzy_boolean, b fuzzy_boolean) RETURNS fuzzy_boolean AS $$
	SELECT (CASE WHEN ($1 > $2) THEN least(1, $2/$1) ELSE 1 END)::fuzzy_boolean;
$$ LANGUAGE SQL;

CREATE FUNCTION product_negation(a fuzzy_boolean) RETURNS fuzzy_boolean AS $$
	SELECT (CASE WHEN $1 = 0 THEN 1 ELSE 0 END)::fuzzy_boolean;
$$ LANGUAGE SQL;

CREATE OPERATOR & (
	PROCEDURE = product_conjunction,
	LEFTARG = fuzzy_boolean,
	RIGHTARG = fuzzy_boolean,
    COMMUTATOR = &);

CREATE OPERATOR | (
	PROCEDURE = product_disjunction,
	LEFTARG = fuzzy_boolean,
	RIGHTARG = fuzzy_boolean,
    COMMUTATOR = |);

CREATE OPERATOR -> (
	PROCEDURE = product_residuum,
	LEFTARG = fuzzy_boolean,
	RIGHTARG = fuzzy_boolean);

CREATE OPERATOR ! (
	PROCEDURE = product_negation,
	RIGHTARG = fuzzy_boolean);
