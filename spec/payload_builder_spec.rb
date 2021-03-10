require 'spec_helper'

describe Skycore::PayloadBuilder do
  let (:api_key) { "my_key" }
  let (:builder) { Skycore::PayloadBuilder.new(api_key) }

  context '#build_save_mms' do
    # Accepts (subject, text, fallback_text, attachments)as argument
    # `attachments` looks for the `type` and `url` parameters

    it "has correct api_key" do
      payload = builder.build_save_mms("", "Hello", "Fallback SMS", [])
      parsed = Crack::XML.parse(payload)
      expect(parsed["REQUEST"]["API_KEY"]).to eq(api_key)
    end

    it "includes fallback text" do
      payload = builder.build_save_mms("", "Hello", "Fallback SMS", [])
      parsed = Crack::XML.parse(payload)
      expect(parsed["REQUEST"]["FALLBACKSMSTEXT"]).to eq("Fallback SMS")
    end

    it "builds simple text" do
      payload = builder.build_save_mms("", "Hello", "Fallback SMS", [])
      parsed = Crack::XML.parse(payload)
      slide = parsed["REQUEST"]["SLIDE"]
      subject = parsed["REQUEST"]["SUBJECT"]
      expect(slide.keys.size).to eq(1)
      expect(subject).to eq(nil)
      expect(slide["TEXT"]).to eq("Hello")
    end

    it "builds subject and text" do
      payload = builder.build_save_mms("Hi", "Hello", "Fallback SMS", [])
      parsed = Crack::XML.parse(payload)
      slide = parsed["REQUEST"]["SLIDE"]
      subject = parsed["REQUEST"]["SUBJECT"]
      expect(slide.keys.size).to eq(1)
      expect(subject).to eq("Hi")
      expect(slide["TEXT"]).to eq("Hello")
    end

    it "builds text + image" do
      image_url = "http://app.tatango.com/tatango_logo.png"
      payload = builder.build_save_mms("", "Hello", "Fallback SMS", [
        {
          type: "IMAGE",
          url: image_url
        }
      ])
      parsed = Crack::XML.parse(payload)
      slide = parsed["REQUEST"]["SLIDE"]
      expect(slide.keys.size).to eq(2)
      expect(slide["TEXT"]).to eq("Hello")
      expect(slide["IMAGE"]["URL"]).to eq(image_url)
    end
  end

  context '#build_save_mms_v2' do
    # Accepts (subject, fallbacktext, slide) as argument
    # `slide` looks for the `type`, `content`, `kind`, and/or `url` parameters
    #  `type` should be `text` or `attachment` and `kind` should be `image`
    image_url = "http://app.tatango.com/tatango_logo.png"

    it "has correct api_key" do
      payload = builder.build_save_mms_v2("", "Hello", [])
      parsed = Crack::XML.parse(payload)
      expect(parsed["REQUEST"]["API_KEY"]).to eq(api_key)
    end

    it "builds two slides" do
      payload = builder.build_save_mms_v2("", "Fallback SMS", [
        {
          type: "attachment",
          kind: "IMAGE",
          url: image_url
        },
        {
          type: "text",
          content: "Hello"
        }
      ])
      parsed = Crack::XML.parse(payload)
      slides = parsed["REQUEST"]["SLIDE"]
      expect(slides.size).to eq(2)
    end

    it "builds the image slide before the text slide" do
      
      payload = builder.build_save_mms_v2("", "Fallback SMS", [
        {
          type: "attachment",
          kind: "IMAGE",
          url: image_url
        },
        {
          type: "text",
          content: "Hello"
        }
      ])
      parsed = Crack::XML.parse(payload)
      slides = parsed["REQUEST"]["SLIDE"]
      expect(slides[0]["IMAGE"]["URL"]).to eq(image_url)
      expect(slides[1]["TEXT"]).to eq("Hello")
    end

    it "builds the image slide after the text slide" do
      payload = builder.build_save_mms_v2("", "Fallback SMS", [
        {
          type: "text",
          content: "Hello"
        },
        {
          type: "attachment",
          kind: "IMAGE",
          url: image_url
        }
      ])
      parsed = Crack::XML.parse(payload)
      slides = parsed["REQUEST"]["SLIDE"]
      expect(slides[1]["IMAGE"]["URL"]).to eq(image_url)
      expect(slides[0]["TEXT"]).to eq("Hello")
    end

  end

  context "#build_send_saved_mms" do
    let (:from) { "41044" }
    let (:to) { "12062746599" }
    let (:parsed) { 
      payload = builder.build_send_saved_mms(from, to, 123, "fallback", 4, 1337)
      Crack::XML.parse(payload)
    }

    it "builds correct api key" do
      expect(parsed["REQUEST"]["API_KEY"]).to eq(api_key)
    end

    it "builds correct TO field" do
      expect(parsed["REQUEST"]["TO"]).to eq(to)
    end

    it "builds correct FALLBACKSMSTEXT field" do
      expect(parsed["REQUEST"]["FALLBACKSMSTEXT"]).to eq("fallback")
    end

    it "builds correct FROM field" do
      expect(parsed["REQUEST"]["FROM"]).to eq(from)
    end

    it "builds correct OPERATORID field" do
      expect(parsed["REQUEST"]["OPERATORID"]).to eq("4")
    end
  end

  context "#build_send_saved_mms_v2" do
    image_url = "http://app.tatango.com/tatango_logo.png"
    let (:from) { "51044" }
    let (:to) { "12062746598" }
    let (:parsed) { 
      payload = builder.build_send_saved_mms_v2(from, to, 123, "Fallback SMS", 4, 1337, [
        {
          type: "text",
          content: "Hello"
        },
        {
          type: "attachment",
          kind: "IMAGE",
          url: image_url
        }
      ])
      Crack::XML.parse(payload)
    }

    it "builds correct api key" do
      expect(parsed["REQUEST"]["API_KEY"]).to eq(api_key)
    end

    it "builds the correct FALLBACKSMSTEXT field" do
      expect(parsed["REQUEST"]["FALLBACKSMSTEXT"]).to eq("Fallback SMS")
    end

    it "contains text content" do
      expect(parsed["REQUEST"]["CUSTOMTEXT"]["VALUE"]).to eq("Hello")
    end

    it "contains image content" do
      expect(parsed["REQUEST"]["IMAGE"]["URL"]).to eq(image_url)
    end
  end
end
