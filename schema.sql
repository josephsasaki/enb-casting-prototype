
DROP TABLE IF EXISTS ballet CASCADE;
DROP TABLE IF EXISTS act    CASCADE;
DROP TABLE IF EXISTS group  CASCADE;
DROP TABLE IF EXISTS role   CASCADE;
DROP TABLE IF EXISTS dancer CASCADE;
DROP TABLE IF EXISTS dancer CASCADE;


--- REFERENCE ---

CREATE TABLE gender (
    gender_id SMALLINT GENERATED ALWAYS AS IDENTITY,
    gender_title VARCHAR(32) NOT NULL,
    PRIMARY KEY (gender_id)
)

CREATE TABLE rank (
    rank_id SMALLINT GENERATED ALWAYS AS IDENTITY,
    rank_name VARCHAR(32) NOT NULL,
    PRIMARY KEY (rank_id)
)

CREATE TABLE act_type (
    act_type_id SMALLINT GENERATED ALWAYS AS IDENTITY,
    act_type_name VARCHAR(32) NOT NULL,
    PRIMARY KEY (act_type_id)
)

CREATE TABLE rule_type (
    rule_type_id SMALLINT GENERATED ALWAYS AS IDENTITY,
    rule_type_name VARCHAR(32) NOT NULL,
    PRIMARY KEY (rule_type_id)
)

CREATE TABLE position (
    position_id SMALLINT GENERATED ALWAYS AS IDENTITY,
    position_row SMALLINT NOT NULL,
    position_column SMALLINT NOT NULL,
    PRIMARY KEY (position_id),
    UNIQUE (position_row, position_column),
)

--- DANCERS ---

CREATE TABLE dancer (
    dancer_id SMALLINT GENERATED ALWAYS AS IDENTITY, 
    first_name VARCHAR(32) NOT NULL CHECK (LENGTH(first_name) > 0),
    last_name VARCHAR(32) NOT NULL CHECK (LENGTH(first_name) > 0),
    rank_id SMALLINT NOT NULL,
    PRIMARY KEY (dancer_id),
    CONSTRAINT fk_rank FOREIGN KEY(rank_id) REFERENCES rank(rank_id),
)


--- BALLET STRUCTURE ---

CREATE TABLE ballet (
    ballet_id SMALLINT GENERATED ALWAYS AS IDENTITY, 
    ballet_name VARCHAR(32) NOT NULL UNIQUE CHECK (LENGTH(ballet_name) > 0),
    date_created DATE NOT NULL,
    PRIMARY KEY (ballet_id)
)

CREATE TABLE act (
    act_id SMALLINT GENERATED ALWAYS AS IDENTITY,
    ballet_id SMALLINT NOT NULL,
    act_type_id SMALLINT NOT NULL,
    PRIMARY KEY (act_id),
    CONSTRAINT fk_ballet FOREIGN KEY(ballet_id) REFERENCES ballet(ballet_id),
    CONSTRAINT fk_act_type FOREIGN KEY(act_type_id) REFERENCES act_type(act_type_id)
)

CREATE TABLE group (
    group_id SMALLINT GENERATED ALWAYS AS IDENTITY,
    group_name VARCHAR(64) NOT NULL UNIQUE CHECK (LENGTH(group_name) > 0),
    act_id SMALLINT NOT NULL,
    gender_id SMALLINT NOT NULL,
    PRIMARY KEY (group_id),
    CONSTRAINT fk_act FOREIGN KEY(act_id) REFERENCES act(act_id),
    CONSTRAINT fk_gender FOREIGN KEY(gender_id) REFERENCES gender(gender_id)
)

CREATE TABLE role (
    role_id SMALLINT GENERATED ALWAYS AS IDENTITY,
    role_name VARCHAR(64) NOT NULL UNIQUE CHECK (LENGTH(role_name) > 0),
    group_id SMALLINT NOT NULL,
    position_id SMALLINT, -- we would want to check roles and full mirrors within a ballet have unique positions
    PRIMARY KEY (role_id),
    CONSTRAINT fk_group FOREIGN KEY(group_id) REFERENCES group(group_id),
    CONSTRAINT fk_position FOREIGN KEY(position_id) REFERENCES position(position_id),
)

--- BALLET OTHER ---


CREATE TABLE cast_option (
    cast_option_id SMALLINT GENERATED ALWAYS AS IDENTITY,
    role_id SMALLINT NOT NULL,
    dancer_id SMALLINT NOT NULL,
    cast_option_costume VARCHAR(32) DEFAULT 'Default Costume',
    PRIMARY KEY (cast_option_id),
    CONSTRAINT fk_role FOREIGN KEY(role_id) REFERENCES role(role_id),
    CONSTRAINT fk_dancer FOREIGN KEY(dancer_id) REFERENCES dancer(dancer_id)
)

CREATE TABLE cast_rule (
    cast_rule_id SMALLINT GENERATED ALWAYS AS IDENTITY,
    ballet_id SMALLINT NOT NULL,
    rule_type_id SMALLINT NOT NULL,
    group_one_id SMALLINT NOT NULL,
    group_two_id SMALLINT NOT NULL,
    PRIMARY KEY (cast_rule_id),
    CHECK (group_one_id <> group_two_id),
    CONSTRAINT fk_ballet FOREIGN KEY(ballet_id) REFERENCES ballet(ballet_id),
    CONSTRAINT fk_rule_type FOREIGN KEY(rule_type_id) REFERENCES rule_type(rule_type_id),
    CONSTRAINT fk_group_one FOREIGN KEY(group_one_id) REFERENCES group(group_id),
    CONSTRAINT fk_group_two FOREIGN KEY(group_two_id) REFERENCES group(group_id)
)

CREATE TABLE full_mirror (
    full_mirror_id SMALLINT GENERATED ALWAYS AS IDENTITY,
    role_id SMALLINT NOT NULL,
    position_id SMALLINT NOT NULL, -- we would want to check roles and full mirrors within a ballet have unique positions
    CONSTRAINT fk_position FOREIGN KEY(position_id) REFERENCES position(position_id)
)


--