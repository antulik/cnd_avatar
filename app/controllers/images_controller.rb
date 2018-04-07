class ImagesController < ApplicationController
  def show
    respond_to do |format|
      format.html {
        @image = Image.new(params)
      }
      format.png {
        path = Image.new(params).process.path
        send_file path, disposition: 'inline'
      }
    end
  end
end
