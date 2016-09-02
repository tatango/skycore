require 'builder'

class Skycore
  class PayloadBuilder
    attr_reader :api_key

    def initialize(api_key)
      @api_key = api_key
    end

    # http://apidocs.skycore.com/HTTP_API/MESSAGING/saveMMS.html
    #
    # Builds following:
    #
    # <REQUEST>
    #   <ACTION>saveMMS</ACTION>
    #   <API_KEY>my_key</API_KEY> <!-- api_key -->
    #   <NAME>tatango_test</NAME>
    #   <FALLBACKSMSTEXT>Hello</FALLBACKSMSTEXT> <!-- fallback_text -->
    #   <SLIDE>
    #     <TEXT>Hello</TEXT> <!-- text -->
    #     <!-- for each attachment -->
    #     <IMAGE>
    #       <URL>http://app.tatango.com/tatango_logo.png</URL>
    #     </IMAGE>
    #     <!-- / for each attachment -->
    #   </SLIDE>
    # </REQUEST>
    def build_save_mms(text, fallback_text, attachments)
      api_key = @api_key

      x = Builder::XmlMarkup.new
      x.instruct!
      x.REQUEST {
        x.ACTION "saveMMS"
        x.API_KEY api_key
        x.NAME "tatango_test"
        x.FALLBACKSMSTEXT fallback_text
        x.SLIDE {
          x.TEXT text
          attachments.each do |attachment|
            x.tag!(attachment[:type]) do
              x.URL attachment[:url]
            end
          end
        }
      }
    end

    # http://apidocs.skycore.com/HTTP_API/MESSAGING/sendSavedMMS.html
    #
    # <REQUEST>
    #   <ACTION>sendSavedMMS</ACTION>
    #   <API_KEY>qTFkykO9JTfahCOqJ0V2Wf5Cg1t8iWlZ</API_KEY>
    #   <TO>16501234123</TO>
    #   <FROM>60856</FROM>
    #   <CAMPAIGNREF>1337</CAMPAIGNREF>
    #   <MMSID>35674</MMSID>
    #   <OPERATORID>4</OPERATORID>
    # </REQUEST>
    def build_send_saved_mms(from, to, mms_id, fallbacksmstext, operator_id=nil, campaignref=nil)
      x = Builder::XmlMarkup.new
      x.instruct!
      x.REQUEST {
        x.ACTION "sendSavedMMS"
        x.API_KEY @api_key
        x.MMSID mms_id
        x.TO to
        x.FALLBACKSMSTEXT fallbacksmstext
        x.OPERATORID operator_id if operator_id
        x.FROM from
        x.CAMPAIGNREF campaignref if campaignref
      }
    end
  end
end
