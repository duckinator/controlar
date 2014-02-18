require 'controlar'

describe Controlar::Speech do
  # Because, apparently, Google thinks this is okay?
  # Can't complain but so much, I guess, since they're giving us a free
  # speech-recognition API.
  it "handles two-line responses, where each line is JSON" do
    # This is an actual result I got from Google.
    json = '{"status":5,"id":"","hypotheses":[]}
{"status":0,"id":"","hypotheses":[{"utterance":"play on","confidence":0.86495697}]}'

    Controlar::Speech.send(:parse_response, json).should_be [
      {'status' => 5, 'id' => '', 'hypotheses' => []},
      {'status' => 0, 'id' => '', 'hypotheses' => [
        {'utterance' => 'play on', 'confidence' => 0.86495697}
      ]}
    ]
  end
end
