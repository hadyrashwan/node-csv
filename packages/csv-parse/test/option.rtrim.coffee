
import { parse } from '../lib/index.js'
import { assert_error } from './api.assert_error.coffee'

describe 'Option `rtrim`', ->

  it 'plain text', (next) ->
    # coffeelint: disable=no_trailing_whitespace
    parse """
    a b ,c d 
    e f ,g h 
    """, quote: "'", escape: "'", trim: true, (err, records) ->
      records.should.eql [['a b', 'c d'],['e f', 'g h']] unless err
      next err
    # coffeelint: enable=no_trailing_whitespace

  it 'after quote', (next) ->
    # coffeelint: disable=no_trailing_whitespace
    data = '''
    'a' ,'b' 
    'c' ,'d' 
    '''
    # coffeelint: enable=no_trailing_whitespace
    parser = parse quote: "'", escape: "'", trim: true, (err, records) ->
      records.should.eql [["a", "b"],["c", "d"]] unless err
      next err
    parser.write chr for chr in data
    parser.end()

  it 'quote followed by escape', (next) ->
    # 1st line: with field delimiter
    # 2nd line: with record delimiter
    # 3rd line: with end of file
    # coffeelint: disable=no_trailing_whitespace
    parse """
    'a''' ,'b'''
    'c''','d''' 
    'e''','f''' 
    """, quote: "'", escape: "'", trim: true, (err, records) ->
      records.should.eql [["a'", "b'"],["c'", "d'"],["e'", "f'"]] unless err
      next err
    # coffeelint: enable=no_trailing_whitespace
  
  it 'with whitespaces around quotes', (next) ->
    # coffeelint: disable=no_trailing_whitespace
    data = '''
    "a b "   ,"c d   " 
    "e f " ,"g h   "   
    '''
    # coffeelint: enable=no_trailing_whitespace
    parser = parse rtrim: true, (err, records) ->
      records.should.eql [['a b ', 'c d   '],['e f ', 'g h   ']] unless err
      next err
    parser.write chr for chr in data
    parser.end()

  it 'with tags around quotes', (next) ->
    data = '''
    "a\tb\t"\t\t\t,"c\td\t\t\t"\t
    "e\tf\t"\t,"g\th\t\t\t"\t\t\t
    '''
    parser = parse rtrim: true,auto_delimiter: false, (err, records) ->
      records.should.eql [['a\tb\t', 'c\td\t\t\t'],['e\tf\t', 'g\th\t\t\t']] unless err
      next err
    parser.write chr for chr in data
    parser.end()

  it 'with char after whitespaces', (next) ->
    data = [
      '"a b " x  ,"c d   " x'
      '"e f " x,"g h   "  x '
    ].join '\n'
    parser = parse rtrim: true, (err) ->
      assert_error err,
        message: 'Invalid Closing Quote: found non trimable byte after quote at line 1'
        code: 'CSV_NON_TRIMABLE_CHAR_AFTER_CLOSING_QUOTE'
        column: 0, empty_lines: 0, header: false, index: 0, invalid_field_length: 0,
        quoting: true, lines: 1, records: 0
      next()
    parser.write chr for chr in data
    parser.end()
