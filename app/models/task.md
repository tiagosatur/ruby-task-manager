## How status validation works?

```ruby
  validates :status, inclusion: { in: %w[pending in_progress done] }

  after_initialize :set_default_status, if: :new_record?

  private

  def set_default_status
    self.status ||= "pending"
  end
```

- It needs to be pending, in_progress or done.
- `after_initialize`: runs after new Task object is created in memory
- `if: :new_record?`: only runs for new records (not when loading existing ones from DB)
- `self.status ||= "pending"`: sets tatus do "pending" only if it's nil/empty

### O que é `||=`?

O `||=` é chamado **operador de atribuição condicional**.

Isso `self.status ||= "pending"`,
é o equivalente a `self.satus = self.status || "pending"`.
