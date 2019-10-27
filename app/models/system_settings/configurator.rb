# frozen_string_literal: true

module SystemSettings
  class Configurator
    class << self
      def from_file(file_name, kernel_class: Kernel)
        file_name = file_name.to_path if file_name.respond_to?(:to_path)
        raise SystemSettings::Errors::SettingsReadError, "The file name must either be a String or implement #to_path" unless file_name.is_a?(String)
        raise SystemSettings::Errors::SettingsReadError, "#{file_name} file does not exist" unless File.exist?(file_name)
        raise SystemSettings::Errors::SettingsReadError, "#{file_name} file not readable" unless File.readable?(file_name)
        SystemSettings.instrument("system_settings.from_file", path: file_name) do |payload|
          file_content = File.read(file_name)
          new(kernel_class: kernel_class).tap do |obj|
            obj.instance_eval(file_content, file_name, 1)
            payload[:items] = obj.items
          end
        end
      end

      def purge
        new.purge
      end
    end

    attr_reader :items

    def initialize(kernel_class: Kernel, &block)
      @items = []
      @kernel_class = kernel_class
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

    def persist(only: [])
      SystemSettings.instrument("system_settings.persist", items: @items) do |payload|
        if settings_table_exists?
          SystemSettings::Setting.transaction do
            if only.empty?
              @items.each { |item| create_or_update_item(item) }
            else
              only.each do |wanted_name|
                item = @items.find { |i| i[:name] == wanted_name } || begin
                  loaded_names = @items.empty? ? "(none)" : @items.map{ |i| i[:name] }.join("\n")
                  message = <<~MESSAGE.strip
                    Couldn't persist system setting #{wanted_name}. There are no items by this name. Could it be a typo?

                    Configurator has loaded following items:
                    #{loaded_names}
                  MESSAGE
                  raise(SystemSettings::Errors::NotLoadedError, message)
                end
                create_or_update_item(item)
              end
            end
          end
          payload[:success] = true
        else
          warn "SystemSettings: Settings table has not been created!"
          payload[:success] = false
        end
      end
    end

    def purge
      SystemSettings.instrument("system_settings.purge") do |payload|
        if settings_table_exists?
          SystemSettings::Setting.delete_all
          payload[:success] = true
        else
          payload[:success] = false
        end
      end
    end

    private

    def warn(*args)
      @kernel_class.warn(*args)
    end

    def settings_table_exists?
      SystemSettings::Setting.table_exists?
    end

    def add(name, class_const, value:, description:)
      value = yield(value) if block_given?
      value = value.call if value.is_a?(Proc)
      @items.push(name: name, class: class_const, value: value, description: description)
    end

    def create_or_update_item(item)
      persisted_record = SystemSettings::Setting.find_by(name: item[:name])
      if persisted_record
        if persisted_record.class == item[:class]
          persisted_record.update!(description: item[:description])
        else
          warn "SystemSettings: Type mismatch detected! Previously #{item[:name]} had type #{persisted_record.class.name} but you are loading #{item[:class].name}"
        end
      else
        item[:class].create!(name: item[:name], value: item[:value], description: item[:description])
      end
    end
  end
end
