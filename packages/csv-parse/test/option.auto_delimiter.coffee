
import { parse } from '../lib/index.js'

describe 'Option `auto_delimiter`', ->
  
  it 'using tab', (next) ->
    parse """
    abc\t\tde\tf\t
    \thij\tklm\t\t
    """, (err, records) ->
      return next err if err
      records.should.eql [
        [ 'abc','','de','f','']
        [ '','hij','klm','','']
      ]
      next()
