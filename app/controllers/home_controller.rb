class HomeController < ApplicationController

  def index
  end

  def paramdata
    render json: true
    p params
    s = UNIXSocket.open "/tmp/ftree.sock"
    s.send params['data'].to_json.to_str, 0
  end

end
