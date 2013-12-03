require 'sqlite3'

module Pong
class Database
	@@this = nil

	@@TYPE_LENGTH = 30
	@@VALUE_LENGTH = 100
	@@KEY_LENGTH = 30

	def initialize
		if @@this
			return @@this
		else
			@@this = self
		end

		@db = SQLite3::Database.new('pong.db')

		# Create a main database
		create_database :main

		# Create a config database
		create_database :config
	end

	def connect(name)
		Connection.new @db, name
	end


	class Connection
		@@conversions = { 'Float' => :to_f, 'Fixnum' => :to_i, 'String' => :to_s }
		def initialize(db, name)
			@db = db
			@name = name
		end

		def get(key, default=nil)
			row = @db.get_first_row( "select value, type from #{@name} where key = '#{key}'")
			if row
				row[0].send(@@conversions[row[1]])
			else
				default
			end
		end

		def set(key, value)
			@db.execute "insert or replace into #{@name} values ( ?, ?, ?)", key.to_s, value.to_s, value.class.to_s
		end
	end

private
	
	def create_database(name)
		@db.execute "create table if not exists #{name} (key varchar(#{@@KEY_LENGTH}) unique, value varchar(#{@@VALUE_LENGTH}), type varchar(#{@@TYPE_LENGTH}) );"
	end
end
end