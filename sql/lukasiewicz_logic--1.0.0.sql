CREATE DOMAIN fuzzy_boolean AS FLOAT CHECK (VALUE BETWEEN 0 AND 1);

CREATE FUNCTION lukasiewicz_conjunction(a fuzzy_boolean, b fuzzy_boolean) RETURNS fuzzy_boolean AS $$
	SELECT greatest(0, $1 + $2 - 1)::fuzzy_boolean;
$$ LANGUAGE SQL;

CREATE FUNCTION lukasiewicz_weak_conjunction(a fuzzy_boolean, b fuzzy_boolean) RETURNS fuzzy_boolean AS $$
	SELECT least($1, $2)::fuzzy_boolean;
$$ LANGUAGE SQL;

CREATE FUNCTION lukasiewicz_disjunction(a fuzzy_boolean, b fuzzy_boolean) RETURNS fuzzy_boolean AS $$
	SELECT least(1, $1 + $2)::fuzzy_boolean;
$$ LANGUAGE SQL;

CREATE FUNCTION lukasiewicz_weak_disjunction(a fuzzy_boolean, b fuzzy_boolean) RETURNS fuzzy_boolean AS $$
	SELECT greatest($1, $2)::fuzzy_boolean;
$$ LANGUAGE SQL;

CREATE FUNCTION lukasiewicz_residuum(a fuzzy_boolean, b fuzzy_boolean) RETURNS fuzzy_boolean AS $$
	SELECT least(1, 1 - $1 + $2)::fuzzy_boolean;
$$ LANGUAGE SQL;

CREATE FUNCTION lukasiewicz_negation(a fuzzy_boolean) RETURNS fuzzy_boolean AS $$
	SELECT (1 - $1)::fuzzy_boolean;
$$ LANGUAGE SQL;

CREATE OPERATOR & (
	PROCEDURE = lukasiewicz_conjunction,
	LEFTARG = fuzzy_boolean,
	RIGHTARG = fuzzy_boolean,
    COMMUTATOR = &);

CREATE OPERATOR && (
	PROCEDURE = lukasiewicz_weak_conjunction,
	LEFTARG = fuzzy_boolean,
	RIGHTARG = fuzzy_boolean,
    COMMUTATOR = &&);

CREATE OPERATOR | (
	PROCEDURE = lukasiewicz_disjunction,
	LEFTARG = fuzzy_boolean,
	RIGHTARG = fuzzy_boolean,
    COMMUTATOR = |);

CREATE OPERATOR || (
	PROCEDURE = lukasiewicz_weak_disjunction,
	LEFTARG = fuzzy_boolean,
	RIGHTARG = fuzzy_boolean,
    COMMUTATOR = ||);

CREATE OPERATOR -> (
	PROCEDURE = lukasiewicz_residuum,
	LEFTARG = fuzzy_boolean,
	RIGHTARG = fuzzy_boolean);

CREATE OPERATOR ! (
	PROCEDURE = lukasiewicz_negation,
	RIGHTARG = fuzzy_boolean);
