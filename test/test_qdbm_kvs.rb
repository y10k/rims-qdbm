# -*- coding: utf-8 -*-

require 'rims/qdbm'
require 'test/unit'

module RIMS::Test
  class QDBMDepot_KeyValueStoreTest < Test::Unit::TestCase
    include KeyValueStoreTestUtility

    def open_database
      RIMS::QDBM::Depot_KeyValueStore.depot_open(@name)
    end

    def make_key_value_store
      RIMS::QDBM::Depot_KeyValueStore.new(@db, @name)
    end

    def db_closed?
      begin
        @db.rnum
        false
      rescue DepotError_EMISC
        true
      end
    end

    def db_key?(key)
      ! @db[key].nil?
    end
  end

  class QDBMDepot_KeyValueStoreOpenCloseTest < Test::Unit::TestCase
    include KeyValueStoreOpenCloseTestUtility

    def get_kvs_name
      'qdbm_depot'
    end

    def get_config
      { 'bnum' => 1000 }
    end
  end
end

# Local Variables:
# mode: Ruby
# indent-tabs-mode: nil
# End:
