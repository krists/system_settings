module SystemSettings
  class Engine < ::Rails::Engine
    class << self
      def frontend_build_path
        File.join(root, "frontend", "build")
      end

      def frontend_build_index_html_path
        File.join(frontend_build_path, "index.html")
      end
    end

    isolate_namespace SystemSettings
    config.generators.api_only = true
    config.middleware.use ActionDispatch::Static, frontend_build_path
  end
end
