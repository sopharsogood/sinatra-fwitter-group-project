class User < ActiveRecord::Base
  has_secure_password
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true

  has_many :tweets

  SLUG_CODEBOOK = {
    "$" => "S",
    "(" => "",
    ")" => "",
    "." => "",
    "&" => "and",
    " " => "-",
    '"' => "",
    "'" => "",
    "+" => "plus"
  }

  def slug
    self.username.gsub(/\W/,SLUG_CODEBOOK).downcase
  end

  def self.find_by_slug(slug)
    self.all.detect do |user|
      user.slug == slug
    end
  end
end
