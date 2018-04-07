class Image
  attr_reader :params
  KEYS = %w[bg body fur eyes mouth accessories]

  def initialize(params)
    @params = params.permit(*KEYS).to_h
  end

  def images_folder
    Rails.root.join('app', 'assets', 'images')
  end

  def folders
    images_folder.each_child
      .select(&:directory?)
      .sort_by { |path| KEYS.index path.basename.to_s }
  end

  def listed_files
    KEYS.map do |key|
      if params.key? key
        path = images_folder.join(key, "#{params[key]}.png")
        path if path.exist?
      end
    end.compact
  end

  def process
    result = listed_files.reduce(nil) do |memo, item|
      image = MiniMagick::Image.open(item).resize("256x256").format("png")
      if memo
        memo.composite image
      else
        image
      end
    end

    result
  end

  def next_options
    next_missing_key = (KEYS - params.keys).first

    return [] if next_missing_key.nil?

    images_folder.join(next_missing_key).each_child.map do |child_path|
      params.merge(
        next_missing_key => child_path.basename(".*").to_s
      )
    end
  end
end
