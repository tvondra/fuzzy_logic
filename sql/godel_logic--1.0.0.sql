CREATE DOMAIN fuzzy_boolean AS FLOAT CHECK (VALUE BETWEEN 0 AND 1);

CREATE FUNCTION godel_conjunction(a fuzzy_boolean, b fuzzy_boolean) RETURNS fuzzy_boolean AS $$
	SELECT least($1, $2)::fuzzy_boolean;
$$ LANGUAGE SQL;

CREATE FUNCTION godel_disjunction(a fuzzy_boolean, b fuzzy_boolean) RETURNS fuzzy_boolean AS $$
	SELECT (1 - least(1-$1, 1-$2))::fuzzy_boolean;
$$ LANGUAGE SQL;

CREATE FUNCTION godel_residuum(a fuzzy_boolean, b fuzzy_boolean) RETURNS fuzzy_boolean AS $$
	SELECT (CASE WHEN $2 >= $1 THEN 1 ELSE $2 END)::fuzzy_boolean;
$$ LANGUAGE SQL;

CREATE FUNCTION godel_negation(a fuzzy_boolean) RETURNS fuzzy_boolean AS $$
	SELECT (CASE WHEN $1 = 0 THEN 1 ELSE 0 END)::fuzzy_boolean;
$$ LANGUAGE SQL;

CREATE OPERATOR & (
	PROCEDURE = godel_conjunction,
	LEFTARG = fuzzy_boolean,
	RIGHTARG = fuzzy_boolean,
    COMMUTATOR = &);

CREATE OPERATOR | (
	PROCEDURE = godel_disjunction,
	LEFTARG = fuzzy_boolean,
	RIGHTARG = fuzzy_boolean,
    COMMUTATOR = |);

CREATE OPERATOR -> (
	PROCEDURE = godel_residuum,
	LEFTARG = fuzzy_boolean,
	RIGHTARG = fuzzy_boolean);

CREATE OPERATOR ! (
	PROCEDURE = godel_negation,
	RIGHTARG = fuzzy_boolean);
