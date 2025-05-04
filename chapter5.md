# Reducing Costs with Duck Typing

Duck types are public interfaces that are not tied to any class, they are defined by their behaviour rather than their class.

## Understanding Duck Typing

### Overlooking the Duck

```ruby
class Trip
  attr_reader :bicycles, :customers, :vehicle

  # 'mechanic' param could be of any class
  def prepare(mechanic)
    mechanic.prepare_bicycles(bicycle)
  end
end

# Trip currently only works with the mechanic
class Mechanic

  def prepare_bicycles(bicycles)
    bicycles.each {|bicycle| prepare_bicycle(bicycle)}
  end

  def prepare_bicycle
  end
end

```

### Finding the Duck

- Don't focus on what each argument's class does, think about what prepare *needs*.
- Considering from prepares point of view, it becomes straight forward.

## Writing Code that Relies on Ducks

How to recognise hidden ducks from common coding patterns, patterns such as:

- Case statements that switch on class
- `kind_of?` and `is_a?`
- `responds_to?`

### Case statements
