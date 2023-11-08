
# FJ Manager
[![Docker CI](https://github.com/felipeejunges/simple-library/actions/workflows/dockerci.yml/badge.svg?branch=main)](https://github.com/felipeejunges/simple-library/actions/workflows/dockerci.yml?query=branch%3Amain)

This project is a client-invoice manager.

## Technologies

- Ruby v3.2.1
- Ruby on Rails v7.0.4
- Bootstrap 5
- SQLite3
- Docker
- Rspec
- FactoryBot
- Faker
- Simplecov
- Pagy
- Annotate
- GitActions for CI
- Pundit
- Sorcery
- Swagger

## Instructions

This instructions shows how to initialize the project and using it with [docker](https://docs.docker.com/engine/install/ubuntu/)

- Run command `docker-compose build` to configure the project
- Run command `docker-compose up` to initialize the project
- You can run tests, to do this, you have to be inside docker bash container with command `rspec`
    - Specs may not working correctly without docker, as it depends on sidekiq, redis and selenium

## Project presentation
Link with project presentation: https://www.loom.com/share/1db6084de0d44b05a73b824f14b452b7

## Default user
- Librarian
  - email: first@librarian.com
  - password: 123
- Member
  - email: person@member.com
  - password: 123

## Postman collection

https://elements.getpostman.com/redirect?entityId=3064842-36151482-e53f-4e3f-a6ea-8b6458917aa1&entityType=collection