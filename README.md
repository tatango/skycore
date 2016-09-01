# Skycore

skycore api integration gem


## Installation


```ruby
gem 'skycore'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install skycore

## Usage

```ruby
    api_key = 'changeme'
    skycore = Skycore.new(api_key, '41044', true)
    text = "Derek, hello from skycore gem"
    mms = "bdgr" * 1000 + "\n\n Do you see me, derek?"
    res = skycore.save_mms(mms, text, [])
    mmsid = res['MMSID']

    res = skycore.send_saved_mms("12063344012", mmsid, text)
```

Take a look at `lib/skycore.rb` to find out what gem api looks like


## Development

