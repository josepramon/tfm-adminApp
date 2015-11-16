faker = require 'faker'

module.exports = ->
  id             : faker.random.uuid()
  token          : faker.random.uuid()
  token_iat      : parseInt faker.date.recent().getTime(), 10
  token_exp      : parseInt faker.date.future().getTime(), 10
  username       : faker.internet.userName()
  email          : faker.internet.email()
