class ThankYouCard
  def text_wrap(text, chars: 80)
    text.each_line.flat_map do |line|
      counter = nil
      result = line.split(' ').slice_before do |elt|
        counter = elt.size if counter.nil?

        if counter + elt.size > chars
          counter = elt.size
          true
        else
          counter += elt.size
          false
        end
      end

      result = result.map do |line_arr|
        line_arr.join(' ')
      end

      if result.empty?
        " "
      else
        result
      end
    end
  end

  def generate(to: '', from: '', date: nil, text: '', amount: '')
    date ||= Date.today

    path = Rails.root.join('app', 'assets', 'images', 'thank_you_card.png')
    image = MiniMagick::Image.open(path.to_s)

    result = image.combine_options do |b|
      b.gravity "NorthWest"
      b.font 'Helvetica-Bold'
      b.pointsize 45
      b.fill "black"

      b.annotate '+102+584', to
      b.annotate '+167+645', from
      b.annotate '+160+704', "#{date.strftime('%e %B %Y')}        #{amount}"

      lines = text_wrap(text, chars: 32)

      b.pointsize 30

      lines.reduce(40) do |y, line|
        b.annotate "+870+#{y}", line
        y + 45
      end
    end
    result = result.resize("800x")

    result
  end
end
