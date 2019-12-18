# Event Maker

## Description

Event Maker is damned small solution for controlled log files processing. Based on Ruby web framework Sinatra.

## How to install

- `$ git clone git@github.com:aleksb86/event_maker.git`
- `$ cd event_maker`
- `$ bundle install`
- `$ rake init`
- `$ rake db:migrate`

> optional - for testing or development run `$ rake db:seed`
>
> It creates sample log files and events patterns.

## How to use

Run `$ rackup config.ru` - starts web server

Run `$ rake processing:run` - start async task for processing (parsing) input log files and writing generated output files with events records.

## REST endpoints

`GET /event_rules` - List of all event rules

`POST /event_rules` - Add new event rule. Format: `{ "pattern": "regular expression" }`

`POST /event_rules/:id/attribute_rules` - Add new attribute rule to event rule. `:id` - is event rule id. Format: `{ "name": "name", "pattern": "regular expression" }`
