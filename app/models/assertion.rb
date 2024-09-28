class Assertion < ApplicationRecord
  def as_json(options = {})
    {
      url: url,
      text: text,
      status: status,
      createdAt: created_at.iso8601,
      numLinks: num_links,
      numImages: num_images,
      snapshotUrl: "/snapshots/#{id}/index.html"  # Add snapshot URL
    }
  end
end
