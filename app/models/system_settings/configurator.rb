module SystemSettings
  class Configurator
    class << self
      def from_file(file_name)
        file_name = file_name.to_path if file_name.respond_to?(:to_path)
        raise Errors::SettingsReadError, "The file name must either be a String or implement #to_path" unless file_name.is_a?(String)
        raise Errors::SettingsReadError, "#{file_name} file does not exist" unless File.exist?(file_name)
        raise Errors::SettingsReadError, "#{file_name} file not readable" unless File.readable?(file_name)
        file_content = File.read(file_name)
        new.tap do |obj|
          obj.instance_eval(file_content, file_name, 1)
        end
      end

      def purge
        new.purge
      end
    end

    attr_reader :items

    def initialize(&block)
      @items = []
      return unless block_given?
      if block.arity == 1
        yield self
      else
        instance_exec(&block)
      end
    end

    def string(name, value: nil, description: nil, &blk)
      add(name, SystemSettings::StringSetting, value: value, description: description, &blk)
    end

    def string_list(name, value: nil, description: nil, &blk)
      add(name, SystemSettings::StringListSetting, value: value || [], description: description, &blk)
    end

    def integer(name, value: nil, description: nil, &blk)
      add(name, SystemSettings::IntegerSetting, value: value, description: description, &blk)
    end

    def integer_list(name, value: nil, description: nil, &blk)
      add(name, SystemSettings::IntegerListSetting, value: value || [], description: description, &blk)
    end

    def boolean(name, value: nil, description: nil, &blk)
      add(name, SystemSettings::BooleanSetting, value: value, description: description, &blk)
    end

    def persist
      if settings_table_exists?
        SystemSettings::Setting.transaction do
          @items.each do |entry|
            persisted_record = entry[:class].find_by(name: entry[:name])
            if persisted_record
              persisted_record.update!(description: entry[:description])
            else
              entry[:class].create!(name: entry[:name], value: entry[:value], description: entry[:description])
            end
          end
        end
        true
      else
        warn "SystemSettings: Settings table has not been created!"
        false
      end
    end

    def purge
      if settings_table_exists?
        SystemSettings::Setting.delete_all
        true
      else
        false
      end
    end

    private

    def settings_table_exists?
      SystemSettings::Setting.table_exists?
    end

    def add(name, class_const, value:, description:)
      value = yield(value) if block_given?
      value = value.call if value.is_a?(Proc)
      @items.push(name: name, class: class_const, value: value, description: description)
    end
  end
end
