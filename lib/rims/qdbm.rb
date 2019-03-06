# -*- coding: utf-8 -*-

require 'curia'
require 'depot'
require 'fileutils'
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
          new(depot_open(depot_path, *optional), depot_path)
        end

        def open_with_conf(name, config)
          bnum = config['bnum']
          args = []
          args << bnum if bnum
          open(name, *args)
        end
      end

      def [](key)
        @db[key]
      end

      def []=(key, value)
        @db[key] = value
      end

      def delete(key)
        ret_val = @db[key]
        @db.out(key)
        ret_val
      end

      def key?(key)
        ! @db[key].nil?
      end

      def each_key
        return enum_for(:each_key) unless block_given?
        @db.each_key do |key|
          yield(key)
        end
        self
      end

      def sync
        @db.sync
        self
      end

      def close
        @db.close
        @closed = true
        self
      end

      def destroy
        unless (@closed) then
          raise DepotError_EMISC,  "failed to destroy qdbm-depot that isn't closed: #{@path}"
        end
        File.delete(@path)
        nil
      end
    end
    KeyValueStore::FactoryBuilder.add_plug_in('qdbm_depot', Depot_KeyValueStore)

    class Curia_KeyValueStore < KeyValueStore
      def initialize(curia, path)
        @db = curia
        @path = path
        @closed = false
      end

      class << self
        def exist?(path)
          curia_path = path + '.qdbm_curia'
          File.exist? curia_path
        end

        def curia_open(path, *optional)
          curia = Curia.new(path, Curia::OWRITER | Curia::OCREAT, *optional)
          curia.silent = true
          curia
        end

        def open(name, *optional)
          curia_path = name + '.qdbm_curia'
          new(curia_open(curia_path, *optional), curia_path)
        end

        def open_with_conf(name, config)
          bnum = config['bnum']
          dnum = config['dnum']

          args = []
          unless (dnum) then
            args << bnum if bnum
          else
            args << bnum || -1
            args << dnum
          end

          open(name, *args)
        end
      end

      def [](key)
        @db[key]
      end

      def []=(key, value)
        @db[key] = value
      end

      def delete(key)
        ret_val = @db[key]
        @db.out(key)
        ret_val
      end

      def key?(key)
        ! @db[key].nil?
      end

      def each_key
        return enum_for(:each_key) unless block_given?
        @db.each_key do |key|
          yield(key)
        end
        self
      end

      def sync
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
          raise CuriaError_EMISC,  "failed to destroy qdbm-curia that isn't closed: #{@path}"
        end
        FileUtils.rm_rf(@path)
        nil
      end
    end
    KeyValueStore::FactoryBuilder.add_plug_in('qdbm_curia', Curia_KeyValueStore)
  end
end

# Local Variables:
# mode: Ruby
# indent-tabs-mode: nil
# End:
