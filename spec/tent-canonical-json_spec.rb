require 'spec_helper'
require 'tent-canonical-json'
require 'support/canonical_json_encode_method_examples'

describe TentCanonicalJson do
  describe ".encode" do
    let(:time) { (Time.now.to_f * 1000).to_i }

    context "with no removable members" do
      let(:post) do
        {
          :id => "d8a3884345df0d6854d4bec893a4649e",
          :entity => "https://entity.example.org",
          :type => "https://example.com/types/foo/v0#",
          :published_at => time,
          :version => {
            :parents => [
              {
                :version => "6438326334656235323631636239633861613938353565646436376431626431",
                :entity => "https://other.example.org",
                :post => "f4fa728bc8daf2a322e47ee4fc865a49",
              },
              {
                :version => "6637666262613665303633366638393065353666626266333238336535323463",
              }
            ],
            :published_at => time,
            :message => "A short description of changes made.",
          },
          :mentions => [
            {
              :post => "23a5b25940d6f3a75748f1edb5628e80",
              :entity => "https://foo.example.com",
            },
            {
              :version => "3963663737376166653332336561393031306331333933356262396438316264",
              :entity => "https://bar.example.org",
              :post => "2c2ca13f2af0b5cb557867ec86e75451",
            }
          ],
          :licenses => [
            {
              :url => "https://somelicense.example.org",
            }
          ],
          :content => {
            :zombies => {
              :kills => 1200,
              :escapes => 32,
              :kills_without_wepon => 100,
            },
            :demons => {
              :kills => 13,
              :kills_without_wepon => 2,
              :escapes => 43,
            },
            :vamps => {
              :kills => 43,
              :kills_without_wepon => 14,
              :escapes => 200,
              :tricked_into_sunlight => 13,
            },
          },
        }
      end

      let(:encoded_post) do
        %({"content":{"demons":{"escapes":43,"kills":13,"kills_without_wepon":2},"vamps":{"escapes":200,"kills":43,"kills_without_wepon":14,"tricked_into_sunlight":13},"zombies":{"escapes":32,"kills":1200,"kills_without_wepon":100}},"entity":"https://entity.example.org","id":"d8a3884345df0d6854d4bec893a4649e","licenses":[{"url":"https://somelicense.example.org"}],"mentions":[{"entity":"https://foo.example.com","post":"23a5b25940d6f3a75748f1edb5628e80"},{"entity":"https://bar.example.org","post":"2c2ca13f2af0b5cb557867ec86e75451","version":"3963663737376166653332336561393031306331333933356262396438316264"}],"published_at":#{time},"type":"https://example.com/types/foo/v0#","version":{"message":"A short description of changes made.","parents":[{"entity":"https://other.example.org","post":"f4fa728bc8daf2a322e47ee4fc865a49","version":"6438326334656235323631636239633861613938353565646436376431626431"},{"version":"6637666262613665303633366638393065353666626266333238336535323463"}],"published_at":#{time}}})
      end

      it_behaves_like "a canonical json encode method"
    end

    context "with removable members" do
      let(:post) do
        {
          :id => "d8a3884345df0d6854d4bec893a4649e",
          :entity => "https://entity.example.org",
          :type => "https://example.com/types/foo/v0#",
          :published_at => time,
          :received_at => time,
          :version => {
            :id => "3963663737376166653332336561393031306331333933356262396438316264",
            :received_at => time,
            :published_at => time,
            :message => "Hello World!",
          },
          :permissions => {
            :public => true
          },
        }
      end

      let(:encoded_post) do
        %({"entity":"https://entity.example.org","id":"d8a3884345df0d6854d4bec893a4649e","published_at":#{time},"type":"https://example.com/types/foo/v0#","version":{"message":"Hello World!","published_at":#{time}}})
      end

      it_behaves_like "a canonical json encode method"
    end

    context "with removable empty members" do
      let(:post) do
        {
          :id => "d8a3884345df0d6854d4bec893a4649e",
          :entity => "https://entity.example.org",
          :type => "https://example.com/types/foo/v0#",
          :published_at => time,
          :version => {
            :published_at => time,
            :parents => [],
            :message => "",
          },
          :content => {},
          :mentions => [],
          :licenses => [],
          :app => {},
          :attachments => [],
        }
      end

      let(:encoded_post) do
        %({"entity":"https://entity.example.org","id":"d8a3884345df0d6854d4bec893a4649e","published_at":#{time},"type":"https://example.com/types/foo/v0#","version":{"published_at":#{time}}})
      end

      it_behaves_like "a canonical json encode method"

      context "with null app members" do
        let(:post) do
          {
            :id => "d8a3884345df0d6854d4bec893a4649e",
            :entity => "https://entity.example.org",
            :type => "https://example.com/types/foo/v0#",
            :published_at => time,
            :version => {
              :published_at => time,
              :parents => [],
              :message => "",
            },
            :content => {},
            :mentions => [],
            :licenses => [],
            :app => {
              :name => nil,
              :url => nil,
              :id => nil
            },
            :attachments => [],
          }
        end

        let(:encoded_post) do
          %({"entity":"https://entity.example.org","id":"d8a3884345df0d6854d4bec893a4649e","published_at":#{time},"type":"https://example.com/types/foo/v0#","version":{"published_at":#{time}}})
        end

        it_behaves_like "a canonical json encode method"
      end
    end

    context "with redundant members" do
      let(:post) do
        {
          :id => "d8a3884345df0d6854d4bec893a4649e",
          :entity => "https://entity.example.org",
          :type => "https://example.com/types/foo/v0#",
          :published_at => time,
          :version => {
            :published_at => time,
            :message => "Hello World!",
            :parents => [
              {
                :version => "6330626530393234306663623531643735623232616166663462663434323163",
                :entity => "https://entity.example.org",
                :post => "d8a3884345df0d6854d4bec893a4649e",
              },
              {
                :version => "3933383165396136376161333631373531636561393031373863303934616436",
                :entity => "https://entity.example.org",
              }
            ],
          },
          :mentions => [
            {
              :post => "d8a3884345df0d6854d4bec893a4649e",
              :entity => "https://entity.example.org",
              :version => "6136643936666130356662323433613133303832613231313935656264313236",
            }
          ],
        }
      end

      let(:encoded_post) do
        %({"entity":"https://entity.example.org","id":"d8a3884345df0d6854d4bec893a4649e","mentions":[{"version":"6136643936666130356662323433613133303832613231313935656264313236"}],"published_at":#{time},"type":"https://example.com/types/foo/v0#","version":{"message":"Hello World!","parents":[{"version":"6330626530393234306663623531643735623232616166663462663434323163"},{"version":"3933383165396136376161333631373531636561393031373863303934616436"}],"published_at":#{time}}})
      end

      it_behaves_like "a canonical json encode method"
    end

    context "with conditional removable members" do
      let(:post) do
        {
          :id => "d8a3884345df0d6854d4bec893a4649e",
          :entity => "https://entity.example.org",
          :type => "https://example.com/types/foo/v0#",
          :published_at => time,
          :mentions => [
            {
              :public => false,
              :entity => "https://foobar.example.com"
            }
          ]
        }
      end

      let(:encoded_post) do
        %({"entity":"https://entity.example.org","id":"d8a3884345df0d6854d4bec893a4649e","published_at":#{time},"type":"https://example.com/types/foo/v0#"})
      end

      it_behaves_like "a canonical json encode method"
    end

    context "with movable members" do
      let(:post) do
        {
          :id => "d8a3884345df0d6854d4bec893a4649e",
          :entity => "https://entity.example.org",
          :original_entity => "https://baz.example.org",
          :type => "https://example.com/types/foo/v0#",
          :published_at => time,
          :version => {
            :parents => [
              {
                :version => "6438326334656235323631636239633861613938353565646436376431626431",
                :entity => "https://other.example.org",
                :original_entity => "https://thefirstother.example.org"
              }
            ],
            :published_at => time,
            :message => "A short description of changes made.",
          },
          :mentions => [
            {
              :entity => "https://foobar.example.com",
              :original_entity => "https://bar.example.com"
            }
          ]
        }
      end

      let(:encoded_post) do
        %({"entity":"https://baz.example.org","id":"d8a3884345df0d6854d4bec893a4649e","mentions":[{"entity":"https://bar.example.com"}],"published_at":#{time},"type":"https://example.com/types/foo/v0#","version":{"message":"A short description of changes made.","parents":[{"entity":"https://thefirstother.example.org","version":"6438326334656235323631636239633861613938353565646436376431626431"}],"published_at":#{time}}})
      end

      it_behaves_like "a canonical json encode method"
    end
  end
end
