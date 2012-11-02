require 'titleize'
require 'mini_magick'

module Jekyll

  class FolderGalleryTag < Liquid::Block
    include Convertible
    attr_accessor :content, :data

    def initialize(tag_name, markup, tokens)
      attributes = {}

      # Parse parameters
      markup.scan(Liquid::TagAttributes) do |key, value|
        attributes[key] = value
      end

      @image_path = attributes['name']   || '.'
      @thumb_path = attributes['thumbnails'] || attributes['name'] + "/thumbs"
      @rev  = attributes['reverse'].nil?
      @files = Dir[File.join(@image_path, "*.{jpg,jpeg,png,gif}")]
      @width = attributes['width'] || 100
      @width = Integer(@width)
      @height = attributes['height'] || (@width * 0.6) #use hd aspect as default
      @height = Integer(@height)
      @thumbs = []
      @id = attributes['id'] || 'gallery'
      super
    end

    def create_thunbs(context, photos)
      # Only 
      if !File.directory?(@thumb_path) || Jekyll.configuration({})["rebuild_thumbs"]
        puts "Rebuilding gallery for: " + @image_path
        File.directory?(@thumb_path) || Dir.mkdir(@thumb_path)

        @files.each_with_index do |filename, index|
          basename = File.basename(filename)
          thumb_file = @thumb_path+"/"+basename
          @thumbs.push(thumb_file)
         
          #puts filename
          image = MiniMagick::Image.open(filename)
          size = "#{@width}x#{nil}" #@width+"x"+@height

          str_crop = "#{@width}x#{@height}+0+0"
          image.resize size
          image.crop str_crop
          #resize_and_crop(image, @width)
          image.write thumb_file
          # puts "width: #{image[:width]}"
          # puts "height: #{image[:height]}"
          # puts "compression: #{image["%Q"]}"
        end
      else
        puts "No rebuild"
      end
    end

    # TODO: Make this go in chronological order
    def render(context)
      
      create_thunbs(context, @files)

      context.registers[:gallery] ||= Hash.new(0)
      
      @files.sort! {|x,y| @rev ? y <=> x : x <=> y }
      length = @files.length
      result = []

      output = '<div id="'+@id+'">'

      @files.each_with_index do |filename, index|
        basename = File.basename(filename)
        url  = ['', @image_path, basename] - ['.']
        path = url[-2..-1].join '/'
        url  = url.join '/'
        thumb_file = @thumb_path+"/"+basename
        #output << '<div class="item">'
        output <<   '<a class="item fancybox" href="' + url +'" rel="'+@id+'">'
        output <<     '<img class="thumbnail" width="#{@width}" src="'+thumb_file+'" data-large="'+url+'" />'
        output <<   '</a>'
        #output << '</div>'
      end

      output << "</div>"
      output
    end

  end

end

Liquid::Template.register_tag('foldergallery', Jekyll::FolderGalleryTag)
