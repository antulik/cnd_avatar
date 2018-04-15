class CardsController < ApplicationController
  helper_method :amount_options

  def show
    @image_url = card_url(
      params: params.permit(:from, :to, :text, :date, :amount),
      format: :png
    )

    params[:date] ||= Date.today
    params[:amount] ||= '$50'

    respond_to do |format|
      format.html {

      }
      format.png {
        date = Date.parse(params[:date]) rescue nil

        file = ThankYouCard.new.generate(
          to: params[:to],
          from: params[:from],
          date: date,
          text: params[:text].to_s,
          amount: params[:amount],
        )

        send_file file.path, disposition: 'inline'
      }
    end
  end

  def amount_options
    ['$50', '500PHP']
  end
end
