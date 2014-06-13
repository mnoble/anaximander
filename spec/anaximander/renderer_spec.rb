require "spec_helper"

describe Anaximander::Renderer do
  include Fakeout::SpecHelpers

  let(:child) { double(url: "http://example.com/foo", assets: ["/root.css", "/child.js"], children: []) }
  let(:root)  { double(url: "http://example.com", assets: ["/root.css"], children: [child]) }

  subject(:renderer) { described_class.new(color: false) }

  before :all do
    Fakeout.activate!
  end

  after :all do
    Fakeout.deactivate!
  end

  it "draws a root node" do
    renderer.draw(root)
    expect(stdout).to include %(└── http://example.com ["/root.css"])
  end

  it "draws a child node whose parent is not a tail" do
    renderer.draw_child(child, "", false)
    expect(stdout).to include %(│   ├── http://example.com/foo ["/root.css", "/child.js"])
  end

  it "draws a child node whose parent is a tail" do
    renderer.draw_child(child, "", true)
    expect(stdout).to include %(    ├── http://example.com/foo ["/root.css", "/child.js"])
  end

  it "draws a tail node whose parent is not a tail node" do
    renderer.draw_tail(child, "", false)
    expect(stdout).to include %(│   └── http://example.com/foo ["/root.css", "/child.js"])
  end

  it "draws a tail node whose parent is also a tail" do
    renderer.draw_tail(child, "", true)
    expect(stdout).to include %(    └── http://example.com/foo ["/root.css", "/child.js"])
  end

  it "draws an entire tree", :endtoend do
    tree = Anaximander::Crawler.new("http://localhost:#{@port}/index.html")
    tree.crawl

    domain = Anaximander::Url.new(tree.root.url).base

    renderer = Anaximander::Renderer.new(color: false)
    renderer.draw(tree.root)

    expect(stdout).to eq <<-TREE
└── #{domain}/index.html ["/main.css", "/application.js"]
    ├── #{domain}/pricing.html ["/main.css", "/application.js"]
    │   ├── #{domain}/pricing/low.html ["/main.css"]
    │   ├── #{domain}/pricing/medium.html ["/main.css"]
    │   └── #{domain}/pricing/high.html ["/main.css"]
    │       ├── #{domain}/pricing/high/sortof_high.html ["/main.css"]
    │       └── #{domain}/pricing/high/super_high.html ["/main.css"]
    └── #{domain}/features.html ["/main.css", "/application.js"]
    TREE
  end
end
