class Lesson < ApplicationRecord
  has_many :enrolled_lessons, dependent: :destroy
  belongs_to :rc_course
  belongs_to :teacher_subject
  has_one_attached :video
  has_one_attached :thumbnail
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  has_many :users, through: :reviews
  has_many :reviews, dependent: :destroy
  monetize :price, as: :price_cents
  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than: 60, less_than: 1_000_000 }
  validates :video, presence: true
  validates :thumbnail, presence: true
  validate :video_validation
  validate :thumbnail_validation

  def video_validation
    return unless video.attached?

    content_types = ['video/mp4', 'video/mpeg', 'video/mov', 'video/ogv', 'video/webm']
    if content_types.none?(video.blob.content_type)
      video.purge
      errors.add(:video, 'type is not compatible. Accepted content types are "video/mp4", "video/mpeg", "video/mov", "video/ogv", "video/webm"')
    elsif video.blob.byte_size > 100_000_000
      logo.purge
      errors.add(:video, 'size is too big')
    end
  end

  def thumbnail_validation
    return unless thumbnail.attached?

    content_types = ['image/png', 'image/jpg', 'image/jpeg']
    if content_types.none?(thumbnail.blob.content_type)
      thumbnail.purge
      errors.add(:thumbnail, 'type is not compatible. Accepted content types are "image/png", "image/jpg", "image/jpeg"')
    elsif thumbnail.blob.byte_size > 100_000_000
      logo.purge
      errors.add(:video, 'size is too big')
    end
  end

  def tag_list
    tags.map(&:name).join(', ')
  end

  def tag_list=(names)
    self.tags = names.split(',').map do |n|
      Tag.where(name: n.strip).first_or_create!
    end
  end

  def avg_score
    if reviews.empty?
      0.0
    else
      reviews.average(:rating).round(2).to_f
    end
  end

  def review_score_percentage
    if reviews.empty?
      0.0
    else
      reviews.average(:rating).round(1).to_f * 96.6 / 6
    end
  end
end
