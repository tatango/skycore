require 'spec_helper'

describe Skycore::PayloadBuilder do
  let (:api_key) { "my_key" }
  let (:builder) { Skycore::PayloadBuilder.new(api_key) }

  context '#build_save_mms' do
    it "has correct api_key" do
      payload = builder.build_save_mms("", "Hello", "Hello", [])
      parsed = Crack::XML.parse(payload)
      expect(parsed["REQUEST"]["API_KEY"]).to eq(api_key)
    end

    it "includes fallback text" do
      payload = builder.build_save_mms("", "Hello", "Fallback SMS", [])
      parsed = Crack::XML.parse(payload)
      expect(parsed["REQUEST"]["FALLBACKSMSTEXT"]).to eq("Fallback SMS")
    end

    it "builds simple text" do
      payload = builder.build_save_mms("", "Hello", "Hello", [])
      parsed = Crack::XML.parse(payload)
      slide = parsed["REQUEST"]["SLIDE"]
      subject = parsed["REQUEST"]["SUBJECT"]
      expect(slide.keys.size).to eq(1)
      expect(subject).to eq(nil)
      expect(slide["TEXT"]).to eq("Hello")
    end

    it "builds subject and text" do
      payload = builder.build_save_mms("Hi", "Hello", "Hello", [])
      parsed = Crack::XML.parse(payload)
      slide = parsed["REQUEST"]["SLIDE"]
      subject = parsed["REQUEST"]["SUBJECT"]
      expect(slide.keys.size).to eq(1)
      expect(subject).to eq("Hi")
      expect(slide["TEXT"]).to eq("Hello")
    end

    it "builds text + image" do
      image_url = "http://app.tatango.com/tatango_logo.png"
      payload = builder.build_save_mms("", "Hello", "Hello", [
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
end
