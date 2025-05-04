# Reducing Costs with Duck Typing

Duck types are public interfaces that are not tied to any class, they are defined by their behaviour rather than their class.

## Understanding Duck Typing

### Overlooking the Duck

```ruby
class Trip
  attr_reader :bicycles, :customers, :vehicle

  def prepeare(mechanic)
  end
```
