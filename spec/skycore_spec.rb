require 'spec_helper'

describe Skycore do
  it 'has a version number' do
    expect(Skycore::VERSION).not_to be nil
  end

  # it 'sends text to derek' do
  #   api_key = 'changeme'
  #   skycore = Skycore.new(api_key, '41044', true)
  #   text = "Derek, hello from skycore gem"
  #   mms = "bdgr" * 1000 + "\n\n Do you see me, derek?"
  #   res = skycore.save_mms(mms, text, [])
  #   mmsid = res['MMSID']

  #   res = skycore.send_saved_mms("12063344012", mmsid, text)
  # end
end
