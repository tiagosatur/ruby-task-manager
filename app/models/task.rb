class Task < ApplicationRecord
  validates :title, presence: true, length: { minimum: 2 }
  validates :status, inclusion: { in: %w[pending in_progress done] }

  after_initialize :set_default_status, if: :new_record?

  private

  def set_default_status
    self.status ||= "pending"
  end
end
