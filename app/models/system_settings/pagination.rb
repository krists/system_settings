module SystemSettings
  module Pagination
    def max_per_page
      100
    end

    def default_per_page
      25
    end

    def page(number = nil, per_page: nil)
      sanitized_per_page = per_page.presence.to_i || default_per_page
      sanitized_per_page = max_per_page if sanitized_per_page > max_per_page
      sanitized_per_page = default_per_page unless sanitized_per_page.positive?
      limit(sanitized_per_page).offset(sanitized_per_page * ((number = number.to_i - 1).negative? ? 0 : number))
    end
  end
end
