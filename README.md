Fuzzy logic
===========
This extension provides basic logical operators (conjunction, disjunction,
implication and negation) for three basic fuzzy logics - Łukasiewicz, Gödel
and product. For the Łukasiewicz logic, there are also operators for weak
conjunction and disjunction.


Installation
------------
Technically, there are three extensions - one for each logic. You have to
choose just one of them, as all of them define the same operators. 

* `godel_logic` - Gödel logic
* `lukasiewicz_logic` - Łukasiewicz logic
* `product_logic` - product logic

So let's say you've chosen Łukasiewicz logic, therefore you want to install
the `lukasiewicz_logic` extension. If you're on 9.1 (or newer), all you need
to do to install it is

    $ make install

and then

    db=# CREATE EXTENSION lukasiewicz_logic;

This should create a `fuzzy_boolean` data type (technically a FLOAT domain)
and four basic logical operators (shared by all three extensions):

* `&` - conjunction (AND)
* `|` - disjunction (OR)
* `!` - negation (NOT)
* `->` - implication

and two logical operators (just for Łukasiewicz logic)

* `&&` - weak conjunction
* `||` - weak disjunction

So now when the logic is installed, let's use it.


Usage
-----
Using the extension is quite straightforward - get somewhere a fuzzy boolean
value and apply the operators to it. E.g. you can do this

    db=# SELECT (0.5 & 0.5) -> (!0.3 | 0.3);

     result 
    --------
          1

or you may create a table with `fuzzy_boolean` column. Or maybe you can
define predicates - functions returning `fuzzy_boolean` values and then use
them like this

    db=# SELECT is_fast(speed) & (! is_expensive(price)) FROM cars;

and so on.


Drawbacks
---------
The first thing to realize is that with fuzzy logic the world is not just
black and white anymore. There's not just perfect truth and falsehood - there're
many degrees of truth. The unpleasant consequence is that the indexing does not
work as efficiently as with plain boolean values.

You can make it work with simple conditions like these

    db=# SELECT * FROM cars WHERE is_fast > 0.8

or with a predicate and an expression index

    db=# SELECT * FROM cars WHERE is_fast(speed) > 0.8

But once you start combining the conditions, the indexing does not work. Consider
for example this query

    db=# SELECT * FROM cars WHERE is_fast & (! is_expensive) > 0.75

With plain boolean conditions, it could be evaluated using a bitmap index scan,
but with fuzzy logic that's not possible.
