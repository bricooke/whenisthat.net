require 'whenisthat/db'

Sequel::Migrator.apply(DB, './whenisthat/db/migrate')
