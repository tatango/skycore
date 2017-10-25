require "skycore/version"
require "skycore/payload_builder"

require "crack"
require "httparty"

class Skycore
  API_URL = "https://secure.skycore.com/API/wxml/1.3/index.php"

  def initialize(api_key, shortcode, debug=false)
    @api_key = api_key
    @shortcode = shortcode
    @debug = debug
  end

  def save_mms(subject, text, fallback_text, attachments=[])
    do_request builder.build_save_mms(subject, text, fallback_text, attachments)
  end

  def save_mms_v2(subject, fallback_text, attachments=[])
    do_request builder.build_save_mms_v2(subject, fallback_text, attachments)
  end

  def send_saved_mms(to, mms_id, fallbacksmstext, operator_id, subject=nil, content=nil)
    do_request builder.build_send_saved_mms(@shortcode, to, mms_id, fallbacksmstext, operator_id, subject, content)
  end

  def send_saved_mms_v2(to, mms_id, fallbacksmstext, operator_id, subject=nil, content=nil, slides=[])
    do_request builder.build_send_saved_mms_v2(@shortcode, to, mms_id, fallbacksmstext, operator_id, subject, content, slides)
  end

  def login_user
    do_request builder.build_login_user
  end

  protected

  def do_request(payload)
    process_response(send_request(payload))
  end

  def send_request(body)
    dbg "-------------------->"
    dbg body

    res = HTTParty.post(API_URL, {body: body})

    dbg "<--------------------"
    dbg res

    res
  end

  def process_response(xml_string)
    parsed = Crack::XML.parse(xml_string)
    response = parsed["RESPONSE"]

    # Success usually looks like
    #
    # <RESPONSE>
    #   <STATUS>Success</STATUS>
    #   <TO>15551234888</TO>
    #   <MMSID>35674</MMSID>
    # </RESPONSE>
    #
    # Whereas error is usually
    #
    # <RESPONSE>
    #   <STATUS>Failure</STATUS>
    #   <ERRORCODE>E111</ERRORCODE>
    #   <TO>15551234888</TO>
    #   <ERRORINFO>Invalid shortcode</ERRORINFO>
    # </RESPONSE>
    #
    # Raise error with errorcode and errorinfo if things dont go smoothly
    if response["STATUS"] == "Failure" or response["ERRORCODE"]
      raise "Skycore error: #{response["ERRORCODE"]} - #{response["ERRORINFO"]}"
    end

    # Otherwise return serialized response (ruby hash)
    response
  end

  def dbg(str)
    puts str if @debug
  end

  def builder
    @builder ||= PayloadBuilder.new(@api_key)
  end
end
