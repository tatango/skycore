require "skycore/version"
require "skycore/payload_builder"

require "crack"
require "nokogiri"
require "httparty"

class Skycore
  API_URL = "https://secure.skycore.com/API/wxml/1.3/index.php"

  def initialize(api_key, shortcode, debug=false)
    @api_key = api_key
    @shortcode = shortcode
    @debug = debug
  end

  def save_mms(text, fallback_text, attachments=[])
    do_request builder.build_save_mms(text, fallback_text, attachments)
  end

  def send_saved_mms(to, mms_id, fallbacksmstext, operator_id=nil, campaignref=nil)
    do_request builder.build_send_saved_mms(@shortcode, to, mms_id, fallbacksmstext, operator_id, campaignref)
  end

  protected

  def do_request(payload)
    process_response(send_request(payload))
  end

  def send_request(body)
    dbg "-->"
    dbg body
    res = HTTParty.post(API_URL, {body: body})
    dbg '<--'
    dbg res
    res
  end

  def process_response(xml_string)
    parsed = Crack::XML.parse(xml_string)
    response = parsed["RESPONSE"]

    if response["STATUS"] == "Failure" or response["ERRORCODE"]
      raise "Skycore error: #{response["ERRORCODE"]} - #{response["ERRORINFO"]}"
    end

    response
  end

  def dbg(str)
    puts str if @debug
  end

  def builder
    @builder ||= PayloadBuilder.new(@api_key)
  end
end
