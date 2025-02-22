# frozen_string_literal: true

class GuestUser
  # Add any methods that your policy might need to check
  def admin?
    false
  end

  def guest?
    true
  end
end
