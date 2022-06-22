use Test::More tests => 35;
use JSON::Streaming::Reader::TestUtil;

test_parse "Empty string", "", [];

test_parse "Empty object", "{}", [ [ 'start_object' ], [ 'end_object' ] ];
test_parse "Empty array", "[]", [ [ 'start_array' ], [ 'end_array' ] ];

test_parse "Empty string", '""', [ [ 'add_string', '' ] ];
test_parse "Non-empty string", '"hello"', [ [ 'add_string', 'hello' ] ];

test_parse "String with escapes", "\"hello\\nworld\"", [ [ 'add_string', "hello\nworld" ] ];
test_parse "String with literal quotes and backslahes", "\"hello\\\\\\\"world\\\"\"", [ [ 'add_string', "hello\\\"world\"" ] ];

# Tests everything because it's an entirely different parser
test_parse "String with u escape for A", "\"\\u0041 Unicode A\"", [ [ 'add_string', "A Unicode A"] ];
test_parse "String with u escape and escapes", "\"\\u0041hello\\nworld\"", [ [ 'add_string', "Ahello\nworld" ] ];

test_parse "String with u escape for utf16", "\"\\ud834\\udd1e Unicode symbol\"", [ [ 'add_string', "\N{MUSICAL SYMBOL G CLEF} Unicode symbol" ] ];
test_parse "String with short u escape", "\"\\u5d symbol\"", [ [ 'add_string', "] symbol" ] ];
test_parse "String with u escapes and escapes", "\"\\u0041hello\\nworld\"", [ [ 'add_string', "Ahello\nworld" ] ];
test_parse "String with u escapes literal quotes and backslahes", "\"\\u0041hello\\\\\\\"world\\\"\\u0041\"", [ [ 'add_string', "Ahello\\\"world\"A" ] ];

test_parse "Zero", '0', [ [ 'add_number', 0 ] ];
test_parse "One", '1', [ [ 'add_number', 1 ] ];
test_parse "One point 5", '1.5', [ [ 'add_number', 1.5 ] ];
test_parse "One thousand using uppercase exponent", '1E3', [ [ 'add_number', 1000 ] ];
test_parse "One thousand using lowercase exponent", '1e3', [ [ 'add_number', 1000 ] ];
test_parse "One thousand using lowercase exponent with plus", '1e+3', [ [ 'add_number', 1000 ] ];
test_parse "Nought point 1 using exponent", '1e-1', [ [ 'add_number', 0.1 ] ];
test_parse "one using exponent", '1e0', [ [ 'add_number', 1 ] ];
test_parse "Negative one", '-1', [ [ 'add_number', -1 ] ];
test_parse "Negative one point 5", '-1.5', [ [ 'add_number', -1.5 ] ];
test_parse "Negative 1000 using exponent", '-1e3', [ [ 'add_number', -1000 ] ];
test_parse "Negative nought point 1 using exponent", '-1e-1', [ [ 'add_number', -0.1 ] ];

test_parse "True", "true", [ [ 'add_boolean', 1 ] ];
test_parse "False", "false", [ [ 'add_boolean', 0 ] ];
test_parse "Null", "null", [ [ 'add_null' ] ];

test_parse "Array containing number", "[1]", [ [ 'start_array' ], [ 'add_number', 1 ], [ 'end_array' ] ];
test_parse "Array containing two numbers", "[1,4]", [ [ 'start_array' ], [ 'add_number', 1 ], [ 'add_number', 4 ], [ 'end_array' ] ];
test_parse "Array containing null", "[null]", [ [ 'start_array' ], [ 'add_null' ], [ 'end_array' ] ];
test_parse "Array containing an empty array", "[[]]", [ [ 'start_array' ], [ 'start_array' ], [ 'end_array' ], [ 'end_array' ] ];
test_parse "Array containing an empty object", "[{}]", [ [ 'start_array' ], [ 'start_object' ], [ 'end_object' ], [ 'end_array' ] ];
test_parse "Object containing a string property", '{"hello":"world"}', [
    [ 'start_object' ],
    [ 'start_property', 'hello' ],
    [ 'add_string', 'world' ],
    [ 'end_property' ],
    [ 'end_object' ],
];
test_parse "Object containing a property whose value is an empty object", '{"hello":{}}', [
    [ 'start_object' ],
    [ 'start_property', 'hello' ],
    [ 'start_object' ],
    [ 'end_object' ],
    [ 'end_property' ],
    [ 'end_object' ],
];
