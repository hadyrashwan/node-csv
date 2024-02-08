
import { parse } from '../lib/index.js'

describe 'Option `delimiter_auto`', ->
  
  it 'using tab', (next) ->
    parse  """
    abc\t\tde\tf\t
    \thij\tklm\t\t
    """,    { delimiter_auto: true }, (err, records) ->
      return next err if err
      records.should.eql [
        [ 'abc','','de','f','']
        [ '','hij','klm','','']
      ]
      next()
  it 'using comma', (next) ->
    parse  """
    abc,,de,f,
    ,hij,klm,,
    """,    { delimiter_auto: true }, (err, records) ->
      return next err if err
      records.should.eql [
        [ 'abc','','de','f','']
        [ '','hij','klm','','']
      ]
      next()
  it 'using semicolumn', (next) ->
    parse  """
    abc;;de;f;
    ;hij;klm;;
    """,    { delimiter_auto: true }, (err, records) ->
      return next err if err
      records.should.eql [
        [ 'abc','','de','f','']
        [ '','hij','klm','','']
      ]
      next()
  it 'using a pipe', (next) ->
    parse  """
    abc||de|f|
    |hij|klm||
    """,    { delimiter_auto: true }, (err, records) ->
      return next err if err
      records.should.eql [
        [ 'abc','','de','f','']
        [ '','hij','klm','','']
      ]
      next()
