class HomeController < ApplicationController

  def index
  end

  def paramdata
    begin
      s = UNIXSocket.open "/tmp/ftree.sock"
      s.send params['data'].to_json.to_str, 0
    rescue Exception=>e 
    end
    render json: true
  end

end
