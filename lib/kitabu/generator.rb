module Kitabu
  # The Kitabu::Generator class will create a new book structure.
  #
  #   ebook = Kitabu::Generator.new
  #   ebook.destination_root = "/some/path/book-name"
  #   ebook.invoke_all
  #
  class Generator < Thor::Group
    include Thor::Actions

    desc "Generate a new e-Book structure"

    def self.source_root
      File.dirname(__FILE__) + "/../../templates"
    end

    def copy_assets
      copy_file "html.scss", "assets/styles/html.scss"
      copy_file "epub.scss", "assets/styles/epub.scss"
      copy_file "_fonts.scss", "assets/styles/_fonts.scss"
      empty_directory "assets/images"
      empty_directory "assets/fonts"
    end

    def copy_html_templates
      copy_file "layout.erb"  , "templates/html/layout.erb"
    end

    def copy_epub_templates
      copy_file "cover.erb"   , "templates/epub/cover.erb"
      copy_file "epub.erb"    , "templates/epub/page.erb"
    end

    def copy_config_file
      @name = full_name
      @uid = Digest::MD5.hexdigest("#{Time.now}--#{rand}")
      @year = Date.today.year
      template "config.erb", "config/kitabu.yml"
    end

    def copy_helper_file
      copy_file "helper.rb", "config/helper.rb"
    end

    def create_directories
      empty_directory "output"
      empty_directory "text"
    end

    def create_git_files
      create_file ".gitignore" do
        "output/*.{html,epub,pdf}\noutput/tmp"
      end

      create_file "output/.gitkeep"
    end

    private
    # Retrieve user's name using finger.
    # Defaults to <tt>John Doe</tt>.
    #
    def full_name
      name = `finger $USER 2> /dev/null | grep Login | colrm 1 46`.chomp
      name.present? ? name.squish : "John Doe"
    end
  end
end
