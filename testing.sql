DROP TABLE IF EXISTS test;

CREATE TABLE test (
    test_id SMALLINT,
    x SMALLINT,
    y SMALLINT
    --PRIMARY KEY (test_id)
);

INSERT INTO test
    (test_id, x, y)
SELECT ROW_NUMBER() OVER (), a, b
FROM generate_series(1, 10) AS a
CROSS JOIN generate_series(1, 10) AS b;