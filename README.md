
# Simple-Library
[![Docker CI](https://github.com/felipeejunges/simple-library/actions/workflows/dockerci.yml/badge.svg?branch=main)](https://github.com/felipeejunges/simple-library/actions/workflows/dockerci.yml?query=branch%3Amain)

This project is a library manager.

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

## Instructions

This instructions shows how to initialize the project and using it with [docker](https://docs.docker.com/engine/install/ubuntu/)

- Run command `docker-compose build` to configure the project
- Run command `docker-compose up` to initialize the project
- You can run tests, to do this, you have to be inside docker bash container with command `rspec`

## Default user
- Librarian
  - email: first@librarian.com
  - password: 123
- Member
  - email: person@member.com
  - password: 123

## Postman collection

https://elements.getpostman.com/redirect?entityId=3064842-36151482-e53f-4e3f-a6ea-8b6458917aa1&entityType=collection

## Presentation With UI

https://www.loom.com/share/9ae4e928d8524ec79f535a274f8fafc9

## Coverage

![image](https://github.com/felipeejunges/simple-library/assets/20795458/97de249f-22f1-4618-aeee-df7bd9ad5e60)

<sub><sup>Sorry about the merges not be squashed</sup></sub>
