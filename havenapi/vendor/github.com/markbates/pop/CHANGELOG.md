# Change Log

## [v3.41.0](https://github.com/markbates/pop/tree/v3.41.0) (2017-11-19)
[Full Changelog](https://github.com/markbates/pop/compare/v3.40.1...v3.41.0)

**Closed issues:**

- Whats the correct type to map money. [\#156](https://github.com/markbates/pop/issues/156)

**Merged pull requests:**

- Remove information about default value from struct-tag description [\#157](https://github.com/markbates/pop/pull/157) ([seblw](https://github.com/seblw))

## [v3.40.1](https://github.com/markbates/pop/tree/v3.40.1) (2017-11-03)
[Full Changelog](https://github.com/markbates/pop/compare/v3.39.4...v3.40.1)

**Closed issues:**

- Fail to parse \<\> comparison operator in SQL migration [\#151](https://github.com/markbates/pop/issues/151)
- empty `schema.sql` when migrating down [\#150](https://github.com/markbates/pop/issues/150)
- Add CockroachDB Support [\#149](https://github.com/markbates/pop/issues/149)
- Mysql Connection String is broken [\#116](https://github.com/markbates/pop/issues/116)

**Merged pull requests:**

- Revert "Make timestamp to match MySQL's timestamp type." [\#155](https://github.com/markbates/pop/pull/155) ([markbates](https://github.com/markbates))
- Make timestamp to match MySQL's timestamp type. [\#154](https://github.com/markbates/pop/pull/154) ([calavera](https://github.com/calavera))
- Add model parameter for generate struct tags [\#153](https://github.com/markbates/pop/pull/153) ([seblw](https://github.com/seblw))
- improve database migrations [\#148](https://github.com/markbates/pop/pull/148) ([endihunter](https://github.com/endihunter))
- Some documentation on callbacks. [\#147](https://github.com/markbates/pop/pull/147) ([barrongineer](https://github.com/barrongineer))

## [v3.39.4](https://github.com/markbates/pop/tree/v3.39.4) (2017-10-22)
[Full Changelog](https://github.com/markbates/pop/compare/v3.39.3...v3.39.4)

## [v3.39.3](https://github.com/markbates/pop/tree/v3.39.3) (2017-10-21)
[Full Changelog](https://github.com/markbates/pop/compare/v3.39.2...v3.39.3)

**Closed issues:**

- "\<" is HTML encoded [\#146](https://github.com/markbates/pop/issues/146)

**Merged pull requests:**

- add Query.ExecWithCount to return affectedrows [\#112](https://github.com/markbates/pop/pull/112) ([u007](https://github.com/u007))

## [v3.39.2](https://github.com/markbates/pop/tree/v3.39.2) (2017-10-20)
[Full Changelog](https://github.com/markbates/pop/compare/v3.39.1...v3.39.2)

**Merged pull requests:**

- Handle remaining golint issues [\#144](https://github.com/markbates/pop/pull/144) ([stanislas-m](https://github.com/stanislas-m))
- \[MySQL\] Use SQL instead of mysql client for create and drop DB [\#142](https://github.com/markbates/pop/pull/142) ([stanislas-m](https://github.com/stanislas-m))
- Fix some golint issues [\#141](https://github.com/markbates/pop/pull/141) ([stanislas-m](https://github.com/stanislas-m))

## [v3.39.1](https://github.com/markbates/pop/tree/v3.39.1) (2017-10-17)
[Full Changelog](https://github.com/markbates/pop/compare/v3.39.0...v3.39.1)

## [v3.39.0](https://github.com/markbates/pop/tree/v3.39.0) (2017-10-17)
[Full Changelog](https://github.com/markbates/pop/compare/v3.38.3...v3.39.0)

**Closed issues:**

- concurrency hashmap write issue [\#136](https://github.com/markbates/pop/issues/136)
- id entered multiple times with model generate [\#87](https://github.com/markbates/pop/issues/87)
- If id field is provided to soda, default ID should not be generated [\#73](https://github.com/markbates/pop/issues/73)

**Merged pull requests:**

- \[PostgreSQL\] Use SQL instead of psql for create and drop DB [\#140](https://github.com/markbates/pop/pull/140) ([stanislas-m](https://github.com/stanislas-m))
- Fix \#136: Race condition on columnCache [\#139](https://github.com/markbates/pop/pull/139) ([stanislas-m](https://github.com/stanislas-m))
- Fix \#73: prevent auto ID if a custom one is provided [\#138](https://github.com/markbates/pop/pull/138) ([stanislas-m](https://github.com/stanislas-m))

## [v3.38.3](https://github.com/markbates/pop/tree/v3.38.3) (2017-10-13)
[Full Changelog](https://github.com/markbates/pop/compare/v3.38.2...v3.38.3)

## [v3.38.2](https://github.com/markbates/pop/tree/v3.38.2) (2017-10-13)
[Full Changelog](https://github.com/markbates/pop/compare/v3.38.1...v3.38.2)

## [v3.38.1](https://github.com/markbates/pop/tree/v3.38.1) (2017-10-12)
[Full Changelog](https://github.com/markbates/pop/compare/v3.38.0...v3.38.1)

**Closed issues:**

- count sql with group by and having? [\#137](https://github.com/markbates/pop/issues/137)
- Can't create migration [\#134](https://github.com/markbates/pop/issues/134)

**Merged pull requests:**

- Updated instructions on how to generate migrations [\#135](https://github.com/markbates/pop/pull/135) ([fdonzello](https://github.com/fdonzello))

## [v3.38.0](https://github.com/markbates/pop/tree/v3.38.0) (2017-10-01)
[Full Changelog](https://github.com/markbates/pop/compare/v3.37.2...v3.38.0)

**Merged pull requests:**

- added AfterFind callback hook [\#133](https://github.com/markbates/pop/pull/133) ([markbates](https://github.com/markbates))
- Escape postgres database name [\#132](https://github.com/markbates/pop/pull/132) ([duckbrain](https://github.com/duckbrain))

## [v3.37.2](https://github.com/markbates/pop/tree/v3.37.2) (2017-09-28)
[Full Changelog](https://github.com/markbates/pop/compare/v3.37.1...v3.37.2)

## [v3.37.1](https://github.com/markbates/pop/tree/v3.37.1) (2017-09-25)
[Full Changelog](https://github.com/markbates/pop/compare/v3.37.0...v3.37.1)

**Closed issues:**

- Default id column for models generation should be an integer [\#33](https://github.com/markbates/pop/issues/33)

**Merged pull requests:**

- Postgresql database creation [\#131](https://github.com/markbates/pop/pull/131) ([spankie](https://github.com/spankie))

## [v3.37.0](https://github.com/markbates/pop/tree/v3.37.0) (2017-09-23)
[Full Changelog](https://github.com/markbates/pop/compare/v3.36.1...v3.37.0)

## [v3.36.1](https://github.com/markbates/pop/tree/v3.36.1) (2017-09-22)
[Full Changelog](https://github.com/markbates/pop/compare/v3.36.0...v3.36.1)

**Merged pull requests:**

- Feature/fix migrator down [\#129](https://github.com/markbates/pop/pull/129) ([barrongineer](https://github.com/barrongineer))

## [v3.36.0](https://github.com/markbates/pop/tree/v3.36.0) (2017-09-20)
[Full Changelog](https://github.com/markbates/pop/compare/v3.35.0...v3.36.0)

**Closed issues:**

- soda: when generate model, can't use single char in  [\#128](https://github.com/markbates/pop/issues/128)

## [v3.35.0](https://github.com/markbates/pop/tree/v3.35.0) (2017-09-19)
[Full Changelog](https://github.com/markbates/pop/compare/v3.34.0...v3.35.0)

## [v3.34.0](https://github.com/markbates/pop/tree/v3.34.0) (2017-09-13)
[Full Changelog](https://github.com/markbates/pop/compare/v3.33.0...v3.34.0)

**Merged pull requests:**

- Fix comment [\#126](https://github.com/markbates/pop/pull/126) ([corylanou](https://github.com/corylanou))

## [v3.33.0](https://github.com/markbates/pop/tree/v3.33.0) (2017-08-30)
[Full Changelog](https://github.com/markbates/pop/compare/v3.32.1...v3.33.0)

**Closed issues:**

- c.ValidateAndSave error classification [\#117](https://github.com/markbates/pop/issues/117)

**Merged pull requests:**

- fixed mysql url parser using underlying driver's parser. [\#119](https://github.com/markbates/pop/pull/119) ([sio4](https://github.com/sio4))
- handle url configuration for mysql properly [\#118](https://github.com/markbates/pop/pull/118) ([sio4](https://github.com/sio4))
- create/drop db via psql, trust auth not required [\#115](https://github.com/markbates/pop/pull/115) ([j0hnsmith](https://github.com/j0hnsmith))

## [v3.32.1](https://github.com/markbates/pop/tree/v3.32.1) (2017-08-22)
[Full Changelog](https://github.com/markbates/pop/compare/v3.32.0...v3.32.1)

## [v3.32.0](https://github.com/markbates/pop/tree/v3.32.0) (2017-08-22)
[Full Changelog](https://github.com/markbates/pop/compare/v3.31.0...v3.32.0)

**Closed issues:**

- introduce dep for vendor management [\#90](https://github.com/markbates/pop/issues/90)
- add\_column not supported on same migration file as create [\#80](https://github.com/markbates/pop/issues/80)

## [v3.31.0](https://github.com/markbates/pop/tree/v3.31.0) (2017-08-17)
[Full Changelog](https://github.com/markbates/pop/compare/v3.30.1...v3.31.0)

**Closed issues:**

- Custom field type possible? [\#111](https://github.com/markbates/pop/issues/111)

## [v3.30.1](https://github.com/markbates/pop/tree/v3.30.1) (2017-08-08)
[Full Changelog](https://github.com/markbates/pop/compare/v3.30.0...v3.30.1)

**Closed issues:**

- Killed: 9 running test [\#110](https://github.com/markbates/pop/issues/110)
- \[feature\] new cache? [\#109](https://github.com/markbates/pop/issues/109)
- soda pg migrate change\_column to uuid fails [\#107](https://github.com/markbates/pop/issues/107)

## [v3.30.0](https://github.com/markbates/pop/tree/v3.30.0) (2017-07-27)
[Full Changelog](https://github.com/markbates/pop/compare/v3.29.1...v3.30.0)

**Merged pull requests:**

- select distinct query [\#106](https://github.com/markbates/pop/pull/106) ([u007](https://github.com/u007))

## [v3.29.1](https://github.com/markbates/pop/tree/v3.29.1) (2017-07-26)
[Full Changelog](https://github.com/markbates/pop/compare/v3.29.0...v3.29.1)

## [v3.29.0](https://github.com/markbates/pop/tree/v3.29.0) (2017-07-26)
[Full Changelog](https://github.com/markbates/pop/compare/v3.28.0...v3.29.0)

**Closed issues:**

- select columns doesnt support raw select [\#105](https://github.com/markbates/pop/issues/105)
- pop.Query.ToSQL does not support columns with concat [\#57](https://github.com/markbates/pop/issues/57)

## [v3.28.0](https://github.com/markbates/pop/tree/v3.28.0) (2017-07-24)
[Full Changelog](https://github.com/markbates/pop/compare/v3.27.1...v3.28.0)

**Merged pull requests:**

- having clauses [\#104](https://github.com/markbates/pop/pull/104) ([u007](https://github.com/u007))

## [v3.27.1](https://github.com/markbates/pop/tree/v3.27.1) (2017-07-23)
[Full Changelog](https://github.com/markbates/pop/compare/v3.27.0...v3.27.1)

**Closed issues:**

- nulls.Float64 translates to float64 for db column should be float [\#103](https://github.com/markbates/pop/issues/103)
- Add JSON support to fizz [\#99](https://github.com/markbates/pop/issues/99)

## [v3.27.0](https://github.com/markbates/pop/tree/v3.27.0) (2017-07-19)
[Full Changelog](https://github.com/markbates/pop/compare/v3.26.0...v3.27.0)

**Merged pull requests:**

- Docker based test environment [\#102](https://github.com/markbates/pop/pull/102) ([lchausmann](https://github.com/lchausmann))
- Add default\_raw to fizz/README [\#101](https://github.com/markbates/pop/pull/101) ([slomek](https://github.com/slomek))

## [v3.26.0](https://github.com/markbates/pop/tree/v3.26.0) (2017-07-17)
[Full Changelog](https://github.com/markbates/pop/compare/v3.25.3...v3.26.0)

**Merged pull requests:**

- CountByField support [\#97](https://github.com/markbates/pop/pull/97) ([u007](https://github.com/u007))

## [v3.25.3](https://github.com/markbates/pop/tree/v3.25.3) (2017-07-12)
[Full Changelog](https://github.com/markbates/pop/compare/v3.25.2...v3.25.3)

**Merged pull requests:**

- Fixing everytime misspelling [\#96](https://github.com/markbates/pop/pull/96) ([ianwalter](https://github.com/ianwalter))

## [v3.25.2](https://github.com/markbates/pop/tree/v3.25.2) (2017-07-10)
[Full Changelog](https://github.com/markbates/pop/compare/v3.25.1...v3.25.2)

## [v3.25.1](https://github.com/markbates/pop/tree/v3.25.1) (2017-07-05)
[Full Changelog](https://github.com/markbates/pop/compare/v3.25.0...v3.25.1)

## [v3.25.0](https://github.com/markbates/pop/tree/v3.25.0) (2017-07-05)
[Full Changelog](https://github.com/markbates/pop/compare/v3.24.0...v3.25.0)

## [v3.24.0](https://github.com/markbates/pop/tree/v3.24.0) (2017-07-03)
[Full Changelog](https://github.com/markbates/pop/compare/v3.23.3...v3.24.0)

**Closed issues:**

- migration nulls.\<TYPE\> wrong naming [\#88](https://github.com/markbates/pop/issues/88)
- Find/First to return sql.ErrNoRows ? [\#84](https://github.com/markbates/pop/issues/84)

**Merged pull requests:**

- Quote database name on mysql [\#94](https://github.com/markbates/pop/pull/94) ([alexcarol](https://github.com/alexcarol))
- Refactored the entire migration system to make it easier to add new types of migrators [\#92](https://github.com/markbates/pop/pull/92) ([markbates](https://github.com/markbates))
- improve error messages when db create/drop fail. [\#91](https://github.com/markbates/pop/pull/91) ([glycerine](https://github.com/glycerine))

## [v3.23.3](https://github.com/markbates/pop/tree/v3.23.3) (2017-06-27)
[Full Changelog](https://github.com/markbates/pop/compare/v3.23.2...v3.23.3)

**Closed issues:**

- How to use callbacks? [\#83](https://github.com/markbates/pop/issues/83)

## [v3.23.2](https://github.com/markbates/pop/tree/v3.23.2) (2017-06-19)
[Full Changelog](https://github.com/markbates/pop/compare/v3.23.1...v3.23.2)

## [v3.23.1](https://github.com/markbates/pop/tree/v3.23.1) (2017-06-16)
[Full Changelog](https://github.com/markbates/pop/compare/v3.23.0...v3.23.1)

## [v3.23.0](https://github.com/markbates/pop/tree/v3.23.0) (2017-06-16)
[Full Changelog](https://github.com/markbates/pop/compare/v3.22.0...v3.23.0)

## [v3.22.0](https://github.com/markbates/pop/tree/v3.22.0) (2017-06-11)
[Full Changelog](https://github.com/markbates/pop/compare/v3.21.1...v3.22.0)

## [v3.21.1](https://github.com/markbates/pop/tree/v3.21.1) (2017-06-09)
[Full Changelog](https://github.com/markbates/pop/compare/v3.21.0...v3.21.1)

**Closed issues:**

- User specific value for 'ID' [\#75](https://github.com/markbates/pop/issues/75)
- Mysql Connection String does not appear to work [\#71](https://github.com/markbates/pop/issues/71)

**Merged pull requests:**

- Fix MySQL connection string not working, fixes \#71 [\#72](https://github.com/markbates/pop/pull/72) ([koesie10](https://github.com/koesie10))
- fix migrate down causes index -1 [\#70](https://github.com/markbates/pop/pull/70) ([u007](https://github.com/u007))
- Query join support [\#58](https://github.com/markbates/pop/pull/58) ([u007](https://github.com/u007))

## [v3.21.0](https://github.com/markbates/pop/tree/v3.21.0) (2017-04-19)
[Full Changelog](https://github.com/markbates/pop/compare/v3.20.0...v3.21.0)

**Closed issues:**

- Proposal: migrate status [\#62](https://github.com/markbates/pop/issues/62)

**Merged pull requests:**

- Callback support for models [\#69](https://github.com/markbates/pop/pull/69) ([Michsior14](https://github.com/Michsior14))

## [v3.20.0](https://github.com/markbates/pop/tree/v3.20.0) (2017-04-19)
[Full Changelog](https://github.com/markbates/pop/compare/v3.19.0...v3.20.0)

**Closed issues:**

- Mysql create with int64 primary key [\#63](https://github.com/markbates/pop/issues/63)

**Merged pull requests:**

- added the ability to shell out to an external command during a fizz migration [\#68](https://github.com/markbates/pop/pull/68) ([markbates](https://github.com/markbates))
- fixes markbates/pop\#63, allowing int64 IDs on models [\#67](https://github.com/markbates/pop/pull/67) ([markbates](https://github.com/markbates))
- Adding Migrate Status command [\#66](https://github.com/markbates/pop/pull/66) ([kushwiz](https://github.com/kushwiz))

## [v3.19.0](https://github.com/markbates/pop/tree/v3.19.0) (2017-04-14)
[Full Changelog](https://github.com/markbates/pop/compare/v3.18.0...v3.19.0)

## [v3.18.0](https://github.com/markbates/pop/tree/v3.18.0) (2017-04-14)
[Full Changelog](https://github.com/markbates/pop/compare/v3.17.0...v3.18.0)

## [v3.17.0](https://github.com/markbates/pop/tree/v3.17.0) (2017-04-11)
[Full Changelog](https://github.com/markbates/pop/compare/v3.16.0...v3.17.0)

## [v3.16.0](https://github.com/markbates/pop/tree/v3.16.0) (2017-04-11)
[Full Changelog](https://github.com/markbates/pop/compare/v3.15.0...v3.16.0)

**Closed issues:**

- Address struct will become addres table name [\#61](https://github.com/markbates/pop/issues/61)

## [v3.15.0](https://github.com/markbates/pop/tree/v3.15.0) (2017-04-11)
[Full Changelog](https://github.com/markbates/pop/compare/v3.14.1...v3.15.0)

## [v3.14.1](https://github.com/markbates/pop/tree/v3.14.1) (2017-04-10)
[Full Changelog](https://github.com/markbates/pop/compare/v3.14.0...v3.14.1)

## [v3.14.0](https://github.com/markbates/pop/tree/v3.14.0) (2017-04-10)
[Full Changelog](https://github.com/markbates/pop/compare/v3.13.7...v3.14.0)

**Closed issues:**

- Cannot generate a config and cannot update pop [\#60](https://github.com/markbates/pop/issues/60)
- How can I exec a raw sql query? [\#59](https://github.com/markbates/pop/issues/59)

## [v3.13.7](https://github.com/markbates/pop/tree/v3.13.7) (2017-04-04)
[Full Changelog](https://github.com/markbates/pop/compare/v3.13.6...v3.13.7)

**Closed issues:**

- count is currently taking order sql [\#56](https://github.com/markbates/pop/issues/56)
- Add model generation example [\#19](https://github.com/markbates/pop/issues/19)

## [v3.13.6](https://github.com/markbates/pop/tree/v3.13.6) (2017-03-29)
[Full Changelog](https://github.com/markbates/pop/compare/v3.13.5...v3.13.6)

**Closed issues:**

- allow raw sql for default value [\#53](https://github.com/markbates/pop/issues/53)
- Generated model with an already plural name fails to compile [\#37](https://github.com/markbates/pop/issues/37)
- model generation fails to compile [\#32](https://github.com/markbates/pop/issues/32)

## [v3.13.5](https://github.com/markbates/pop/tree/v3.13.5) (2017-03-28)
[Full Changelog](https://github.com/markbates/pop/compare/v3.13.4...v3.13.5)

**Merged pull requests:**

- fix migrate down to correctly step down [\#54](https://github.com/markbates/pop/pull/54) ([u007](https://github.com/u007))

## [v3.13.4](https://github.com/markbates/pop/tree/v3.13.4) (2017-03-27)
[Full Changelog](https://github.com/markbates/pop/compare/v3.13.3...v3.13.4)

**Closed issues:**

- migration down roll back all? [\#47](https://github.com/markbates/pop/issues/47)

**Merged pull requests:**

- add uuid support for sqlite [\#52](https://github.com/markbates/pop/pull/52) ([u007](https://github.com/u007))

## [v3.13.3](https://github.com/markbates/pop/tree/v3.13.3) (2017-03-24)
[Full Changelog](https://github.com/markbates/pop/compare/v3.13.2...v3.13.3)

## [v3.13.2](https://github.com/markbates/pop/tree/v3.13.2) (2017-03-21)
[Full Changelog](https://github.com/markbates/pop/compare/v3.13.1...v3.13.2)

**Closed issues:**

- transaction with destroy: error committing or rolling back transaction: sql: Transaction has already been committed or rolled back [\#48](https://github.com/markbates/pop/issues/48)

**Merged pull requests:**

- Changed config templates to use env in test case [\#51](https://github.com/markbates/pop/pull/51) ([stanislas-m](https://github.com/stanislas-m))

## [v3.13.1](https://github.com/markbates/pop/tree/v3.13.1) (2017-03-19)
[Full Changelog](https://github.com/markbates/pop/compare/v3.13.0...v3.13.1)

## [v3.13.0](https://github.com/markbates/pop/tree/v3.13.0) (2017-03-19)
[Full Changelog](https://github.com/markbates/pop/compare/v3.12.1...v3.13.0)

## [v3.12.1](https://github.com/markbates/pop/tree/v3.12.1) (2017-03-17)
[Full Changelog](https://github.com/markbates/pop/compare/v3.11.7...v3.12.1)

**Merged pull requests:**

- Dump load [\#50](https://github.com/markbates/pop/pull/50) ([markbates](https://github.com/markbates))

## [v3.11.7](https://github.com/markbates/pop/tree/v3.11.7) (2017-03-17)
[Full Changelog](https://github.com/markbates/pop/compare/v3.11.6...v3.11.7)

**Closed issues:**

- reflect: call of reflect.Value.Elem on struct Value [\#45](https://github.com/markbates/pop/issues/45)

**Merged pull requests:**

- set default migrate down to run only single migration. [\#49](https://github.com/markbates/pop/pull/49) ([u007](https://github.com/u007))

## [v3.11.6](https://github.com/markbates/pop/tree/v3.11.6) (2017-03-06)
[Full Changelog](https://github.com/markbates/pop/compare/v3.11.5...v3.11.6)

## [v3.11.5](https://github.com/markbates/pop/tree/v3.11.5) (2017-03-06)
[Full Changelog](https://github.com/markbates/pop/compare/v3.12.0...v3.11.5)

**Closed issues:**

- Panic running soda config [\#44](https://github.com/markbates/pop/issues/44)

## [v3.12.0](https://github.com/markbates/pop/tree/v3.12.0) (2017-03-01)
[Full Changelog](https://github.com/markbates/pop/compare/v3.11.4...v3.12.0)

**Merged pull requests:**

- Xela rellum xela rellum/remove connections singleton 2 [\#42](https://github.com/markbates/pop/pull/42) ([markbates](https://github.com/markbates))

## [v3.11.4](https://github.com/markbates/pop/tree/v3.11.4) (2017-03-01)
[Full Changelog](https://github.com/markbates/pop/compare/v3.11.3...v3.11.4)

**Closed issues:**

- Generated model with a name beginning with "b" fails to compile [\#38](https://github.com/markbates/pop/issues/38)

**Merged pull requests:**

- Fixed issue \#38. [\#39](https://github.com/markbates/pop/pull/39) ([stanislas-m](https://github.com/stanislas-m))
- Fix model.PrimaryKeyType returning invalid type if ID column not found [\#36](https://github.com/markbates/pop/pull/36) ([SheepGoesBaa](https://github.com/SheepGoesBaa))
- Typo fixes in README [\#30](https://github.com/markbates/pop/pull/30) ([srt32](https://github.com/srt32))

## [v3.11.3](https://github.com/markbates/pop/tree/v3.11.3) (2017-02-04)
[Full Changelog](https://github.com/markbates/pop/compare/v3.11.2...v3.11.3)

**Merged pull requests:**

- Avoid wrapping mysql table names in strings [\#29](https://github.com/markbates/pop/pull/29) ([rbutler](https://github.com/rbutler))

## [v3.11.2](https://github.com/markbates/pop/tree/v3.11.2) (2017-02-03)
[Full Changelog](https://github.com/markbates/pop/compare/v3.11.1...v3.11.2)

## [v3.11.1](https://github.com/markbates/pop/tree/v3.11.1) (2017-02-02)
[Full Changelog](https://github.com/markbates/pop/compare/v3.11.0...v3.11.1)

**Closed issues:**

- Transaction wrapper for tests ignores Rollback result [\#26](https://github.com/markbates/pop/issues/26)

**Merged pull requests:**

- Distinguish between empty strings and NULL \(?\) [\#28](https://github.com/markbates/pop/pull/28) ([hypirion](https://github.com/hypirion))
- Mem patch 3 [\#24](https://github.com/markbates/pop/pull/24) ([markbates](https://github.com/markbates))
- Update import path for nulls [\#23](https://github.com/markbates/pop/pull/23) ([mem](https://github.com/mem))
- Add soda generate model documentation to README.md [\#22](https://github.com/markbates/pop/pull/22) ([mem](https://github.com/mem))
- Escape . in nrx regexp [\#21](https://github.com/markbates/pop/pull/21) ([mem](https://github.com/mem))

## [v3.11.0](https://github.com/markbates/pop/tree/v3.11.0) (2017-01-13)
[Full Changelog](https://github.com/markbates/pop/compare/v3.10.1...v3.11.0)

**Merged pull requests:**

- UUID [\#18](https://github.com/markbates/pop/pull/18) ([markbates](https://github.com/markbates))

## [v3.10.1](https://github.com/markbates/pop/tree/v3.10.1) (2017-01-10)
[Full Changelog](https://github.com/markbates/pop/compare/v3.10.0...v3.10.1)

**Closed issues:**

- mysql dialect doesn't respect port and host parameters [\#15](https://github.com/markbates/pop/issues/15)
- sqlite example incorrect? [\#13](https://github.com/markbates/pop/issues/13)
- Add "Generated by ..." comment to top of generated files [\#9](https://github.com/markbates/pop/issues/9)

**Merged pull requests:**

- break on first error in db create [\#17](https://github.com/markbates/pop/pull/17) ([lumost](https://github.com/lumost))
- specify host and port for mysql dialect creation and drop [\#16](https://github.com/markbates/pop/pull/16) ([slashk](https://github.com/slashk))
- Fix sqlite example in README [\#14](https://github.com/markbates/pop/pull/14) ([slava-vishnyakov](https://github.com/slava-vishnyakov))

## [v3.10.0](https://github.com/markbates/pop/tree/v3.10.0) (2017-01-05)
[Full Changelog](https://github.com/markbates/pop/compare/3.9.9...v3.10.0)

## [3.9.9](https://github.com/markbates/pop/tree/3.9.9) (2017-01-04)
[Full Changelog](https://github.com/markbates/pop/compare/3.9.8...3.9.9)

## [3.9.8](https://github.com/markbates/pop/tree/3.9.8) (2016-12-30)
[Full Changelog](https://github.com/markbates/pop/compare/3.9.2...3.9.8)

**Closed issues:**

- Inconsistency in README.md [\#12](https://github.com/markbates/pop/issues/12)
- Documentation on `default databases` clarification [\#10](https://github.com/markbates/pop/issues/10)
- Vendoring strategy for pop/sqlx [\#7](https://github.com/markbates/pop/issues/7)

**Merged pull requests:**

- Update README.md [\#11](https://github.com/markbates/pop/pull/11) ([webRat](https://github.com/webRat))

## [3.9.2](https://github.com/markbates/pop/tree/3.9.2) (2016-11-27)
[Full Changelog](https://github.com/markbates/pop/compare/v3.8.0...3.9.2)

**Closed issues:**

- Roadmap or feature-complete? [\#8](https://github.com/markbates/pop/issues/8)

## [v3.8.0](https://github.com/markbates/pop/tree/v3.8.0) (2016-08-30)
[Full Changelog](https://github.com/markbates/pop/compare/v3.7.2...v3.8.0)

## [v3.7.2](https://github.com/markbates/pop/tree/v3.7.2) (2016-08-26)
[Full Changelog](https://github.com/markbates/pop/compare/v3.7.1...v3.7.2)

## [v3.7.1](https://github.com/markbates/pop/tree/v3.7.1) (2016-08-26)
[Full Changelog](https://github.com/markbates/pop/compare/v3.7.0...v3.7.1)

## [v3.7.0](https://github.com/markbates/pop/tree/v3.7.0) (2016-08-26)
[Full Changelog](https://github.com/markbates/pop/compare/v3.6.2...v3.7.0)

## [v3.6.2](https://github.com/markbates/pop/tree/v3.6.2) (2016-08-26)
[Full Changelog](https://github.com/markbates/pop/compare/v3.6.1...v3.6.2)

## [v3.6.1](https://github.com/markbates/pop/tree/v3.6.1) (2016-08-26)
[Full Changelog](https://github.com/markbates/pop/compare/v3.6.0...v3.6.1)

## [v3.6.0](https://github.com/markbates/pop/tree/v3.6.0) (2016-08-26)
[Full Changelog](https://github.com/markbates/pop/compare/v3.5.1.1...v3.6.0)

## [v3.5.1.1](https://github.com/markbates/pop/tree/v3.5.1.1) (2016-08-26)
[Full Changelog](https://github.com/markbates/pop/compare/v3.5.1...v3.5.1.1)

## [v3.5.1](https://github.com/markbates/pop/tree/v3.5.1) (2016-08-26)
[Full Changelog](https://github.com/markbates/pop/compare/v3.5.2...v3.5.1)

## [v3.5.2](https://github.com/markbates/pop/tree/v3.5.2) (2016-08-26)
[Full Changelog](https://github.com/markbates/pop/compare/v3.5.0...v3.5.2)

## [v3.5.0](https://github.com/markbates/pop/tree/v3.5.0) (2016-08-25)
[Full Changelog](https://github.com/markbates/pop/compare/v3.4.1...v3.5.0)

## [v3.4.1](https://github.com/markbates/pop/tree/v3.4.1) (2016-08-25)
[Full Changelog](https://github.com/markbates/pop/compare/v3.4.0...v3.4.1)

## [v3.4.0](https://github.com/markbates/pop/tree/v3.4.0) (2016-08-25)
[Full Changelog](https://github.com/markbates/pop/compare/v3.3.1...v3.4.0)

## [v3.3.1](https://github.com/markbates/pop/tree/v3.3.1) (2016-08-23)
[Full Changelog](https://github.com/markbates/pop/compare/v3.3.0...v3.3.1)

## [v3.3.0](https://github.com/markbates/pop/tree/v3.3.0) (2016-08-19)
**Closed issues:**

- Add dialect detection via the Parse function [\#1](https://github.com/markbates/pop/issues/1)

**Merged pull requests:**

- Fizz [\#6](https://github.com/markbates/pop/pull/6) ([markbates](https://github.com/markbates))
- Remove unused column cache [\#5](https://github.com/markbates/pop/pull/5) ([timraymond](https://github.com/timraymond))
- Sqlite [\#4](https://github.com/markbates/pop/pull/4) ([markbates](https://github.com/markbates))
- Thread Safety Dance [\#3](https://github.com/markbates/pop/pull/3) ([timraymond](https://github.com/timraymond))
- Use url scheme as ConnectionDetails' dialect [\#2](https://github.com/markbates/pop/pull/2) ([jboursiquot](https://github.com/jboursiquot))



\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*