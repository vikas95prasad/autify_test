class Assertion < ApplicationRecord
  enum status: { pass: 0, fail: 1 }

  validates :url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp, message: 'must be a valid URL' }
  validates :text, presence: true
  validates :num_links, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :num_images, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :status, presence: true

  def as_json(options = {})
    {
      url: url,
      text: text,
      status: status.upcase,
      createdAt: created_at.iso8601,
      numLinks: num_links,
      numImages: num_images
    }
  end
end
