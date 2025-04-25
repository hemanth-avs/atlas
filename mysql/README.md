# Instructions

1. Install Atlas CLI

```
brew install ariga/tap/atlas
```

2. Identify the current SQL files of the Databases
3. Generate the Migration Script needed
	1. Have the Schema in schema.sql

```sh
atlas migrate diff initial \
  --to file://schema.sql \
  --dev-url "docker://mysql/8/dev" \
  --format '{{ sql . "  " }}'
```

3. It created the migration folder with files in below structure
	1. ./migrations/20250425035139_initial.sql
	2. ./migrations/atlas.sum
	
4. Created Account in [Atlas Pro Cloud](https://auth.atlasgo.cloud/create-organization)
	1. Create Repository Name - MySQLApp
	2. Driver - MySQL

5. Pushing migrations to Atlas Registry

```sh
atlas login hemanth

atlas migrate push mysqlapp --dev-url "docker://mysql/8/dev" # Single Schema
or 
atlas migrate push mysqlapp --dev-url "docker://mysql/8" # Multiple Schemas
```

6. Applying migrations
	1. Create a Local SQL Database using docker container for applying the migrations
	2. Create Atlas configuration file to store the setting on sql container environment
		1. atlas.hcl

```sh
docker run --rm -d --name atlas-demo -e MYSQL_ROOT_PASSWORD=pass -e MYSQL_DATABASE=example -p 3306:3306 mysql
```

```sh
# The "local" environment represents our local testings.
env "local" {
  url = "mysql://root:pass@:3306/example"
  migration {
    dir = "atlas://atlas-intro"
  }
}
```

```sh
atlas migrate apply --env local
```

7. Verify the migration is done on database

```sh
docker exec -it atlas-demo mysql -u root -ppass -e "SHOW databases;"

docker exec -it atlas-demo mysql -u root -ppass -e "SHOW COLUMNS FROM example.users;"

docker exec -it atlas-demo mysql -u root -ppass -e "SHOW COLUMNS FROM example.repos;"
```

8. Make changes to the schema
	1. Updated schema in schema-v1.sql

9. Generate the migration files based on updated schema

```sh
atlas migrate diff add_commits \
  --to file://schema-v1.sql \
  --dev-url "docker://mysql/8/dev" \
  --format '{{ sql . "  " }}'
```

10. It created the migration folder with files in below structure
	1. ./migrations/20250425043949_add_commits.sql
	2. ./migrations/atlas.sum - updated

11. Push the migrations to the atlas cloud

```sh
atlas migrate push mysqlapp \
  --dev-url "docker://mysql/8/dev"
```

12. Let's apply our latest migration and check our database again

```sh
atlas migrate apply --env local
```

13. Verify the migration is done on database

```sh
docker exec -it atlas-demo mysql -u root -ppass -e "SHOW databases;"

docker exec -it atlas-demo mysql -u root -ppass -e "SHOW COLUMNS FROM example.repos;"

docker exec -it atlas-demo mysql -u root -ppass -e "SHOW COLUMNS FROM example.commits;"
```
# Atlas Plans

- Starter
	- MySQL, MariaDB, PostgreSQL and SQLite
- Pro
	- MS SQL
