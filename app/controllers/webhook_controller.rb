class WebhookController < ApplicationController
include QiitaApiManager
protect_from_forgery :except => [:callback]

require 'line/bot'
require 'net/http'

def client
     client = Line::Bot::Client.new { |config|
config.channel_secret = '95346c19953b65bd9e06bcf7ec3805e5'
config.channel_token = 'mhvmByfOKPVr2HZyB4ZdwvAGQYpYNCk+cSA8u9mSoas7eLoYWR+/gyJnU4pPJzN0cNtfJ/KAxbAOsnUKij4+XGElFFZB3UG3PMfz3bVqJH3zwaivJAZu/aTkdcJbXC0uUVX9Mvm/eTuR6B5jakvDTwdB04t89/1O/w1cDnyilFU='
}
end



def callback

body = request.body.read

signature = request.env['HTTP_X_LINE_SIGNATURE']

event = params["events"][0]
event_type = event["type"]

#送られたテキストメッセージをinput_textに取得
input_text = event["message"]["text"]

events = client.parse_events_from(body)

events.each { |event|

  case event
    when Line::Bot::Event::Message
      case event.type
        #テキストメッセージが送られた場合、そのままおうむ返しする
        when Line::Bot::Event::MessageType::Text
          qiita_res = []
          qiita_res = search(input_text)
          qiita_reses = qiita_res.map {|items| "#{items['title']} #{items['url']}"}
          puts qiita_reses
           message = {
                type: 'text',
                text: input_text
                }

        #画像が送られた場合、適当な画像を送り返す
        #画像を返すには、画像が保存されたURLを指定する。
        #なお、おうむ返しするには、１度AWSなど外部に保存する必要がある。ここでは割愛する
        when Line::Bot::Event::MessageType::Image
          image_url = "https://XXXXXXXXXX/XXX.jpg"  #httpsであること
            message = {
                type: "image",
                originalContentUrl: image_url,
                previewImageUrl: image_url
                }
       end #event.type
       #メッセージを返す
       client.reply_message(event['replyToken'],message)
  end #event
} #events.each

end  #def
end
