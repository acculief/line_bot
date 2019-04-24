class SampleController < ApplicationController
include QiitaApiManager
  def hoge
    hoges = []
    hoges = search("hoge")
    kami = hoges.map {|items| "#{items['title']} #{items['url']}"}
    render json: { status: 200 , message: kami }
  end
end
