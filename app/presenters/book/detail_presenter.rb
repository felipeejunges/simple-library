# frozen_string_literal: true

class Book::DetailPresenter < SimpleDelegator
  def self.name_options
    Book::Detail.names.map do |name|
      [name[0].humanize, name[0]]
    end
  end
end
