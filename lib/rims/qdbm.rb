# -*- coding: utf-8 -*-

require 'depot'
require 'rims'
require 'rims/qdbm/version'

module RIMS
  module QDBM
    class Depot_KeyValueStore < KeyValueStore
      def initialize(depot, path)
        @db = depot
        @path = path
        @closed = false
      end

      class << self
        def exist?(path)
          depot_path = path + '.qdbm_depot'
          File.exist? depot_path
        end

        def depot_open(path, *optional)
          depot = Depot.new(path, Depot::OWRITER | Depot::OCREAT, *optional)
          depot.silent = true
          depot
        end

        def open(name, *optional)
          depot_path = name + '.qdbm_depot'
          new(depot_open(depot_path), depot_path)
        end

        def open_with_conf(name, config)
          bnum = config['bnum']
          args = []
          args << bnum if bnum
          open(name, *args)
        end
      end

      def [](key)
        @closed and raise 'closed'
        @db[key]
      end

      def []=(key, value)
        @closed and raise 'closed'
        @db[key] = value
      end

      def delete(key)
        @closed and raise 'closed'
        ret_val = @db[key]
        @db.out(key)
        ret_val
      end

      def key?(key)
        @closed and raise 'closed'
        ! @db[key].nil?
      end

      def each_key
        @closed and raise 'closed'
        return enum_for(:each_key) unless block_given?
        @db.each_key do |key|
          yield(key)
        end
        self
      end

      def sync
        @closed and raise 'closed'
        @db.sync
        self
      end

      def close
        @closed and raise 'closed'
        @db.close
        @closed = true
        self
      end

      def destroy
        unless (@closed) then
          raise "failed to destroy qdbm-depot that isn't closed: #{@path}"
        end
        File.delete(@path)
        nil
      end
    end
    KeyValueStore::FactoryBuilder.add_plug_in('qdbm_depot', Depot_KeyValueStore)
  end
end

# Local Variables:
# mode: Ruby
# indent-tabs-mode: nil
# End:
