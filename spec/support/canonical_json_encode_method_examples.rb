shared_examples "a canonical json encode method" do
  it "encodes post" do
    expect(described_class.encode(post)).to eq(encoded_post)
  end
end
