# Event Maker

(Please don't use this project because it didn't ready)

<img src="http://pngimg.com/uploads/under_construction/under_construction_PNG63.png" alt="under construction" width="50%" height="50"></img>

## Description

Event Maker is damned small solution for controlled log files processing. Based on Ruby web framework Sinatra.

> RU: Ключевые возможности - добавление новых паттернов (регулярных выражений) через REST (см. REST endpoints), получение списка правил для события (включая правила для атрибутов). Выполнение задачи по разбору логов и записи в соответствующие файлы событий.

## How to install

- `$ git clone git@github.com:aleksb86/event_maker.git`
- `$ cd event_maker`
- `$ bundle install`
- Fill in the configuration files (in project root dir): config_dev.yml, config_test.yml, config_prod.yml
- Connect to postgresql and create databases: `event_maker_dev`, `event_maker_test`, `event_maker_prod` (development, test and production):
  - `$ psql -h <host> -p <port> -U <username>`
  - `CREATE DATABASE event_maker_dev;`
  - `CREATE DATABASE event_maker_test;`
  - `CREATE DATABASE event_maker_prod;`
- `$ rake init`
- `$ rake db:migrate`

> * for testing or development purposes - run `$ rake db:seed` It creates sample log files and events patterns.
>
> RU: Сэмплы входных и выходных данных содержатся в каталогах LOGS и EVENTS (внутри каталога приложения). LOGS заполняется выполнением `$ rake db:seed`. EVENTS заполняется после `$ rake processing:run`

## How to use

Run `$ rackup config.ru` - starts web server (you can change port in `config.ru` - default is 5000)

> Production environment: run `$ RACK_ENV=production rackup config.ru` (for production mode it needs to set RACK_ENV to 'production' - e.g. in .bashrc file or .profile or in system-global environment variable)

Run `$ rake processing:run` - start async task for processing (parsing) input log files and writing generated output files with events (JSON) records.

> RU: Работа с сервисом выглядит так: через веб запросы добавляются необходимые правила разбора логов и атрибутов (см. REST endpoints), затем выполняется `$ rake processing:run`. Результаты работы сервиса помещаются в каталоге EVENTS в виде текстовых файлов, содержащих JSON-строки. Имена выходных файлов совпадают с именами входных файлов в каталоге LOGS.

## Tests

Run rspec etc...

## REST endpoints

`GET /event_rules` - List of all event rules

`POST /event_rules` - Add new event rule. Format: `{ "pattern": "regular expression" }`

`POST /event_rules/:id/attribute_rules` - Add new attribute rule to event rule. `:id` - is event rule id. Format: `{ "name": "name", "pattern": "regular expression" }`

## Possible improvements

* Make source code more DRY and clean
* Add tests
* Create Cron task for background job (or another way to automate job)
