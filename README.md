# Practical Object Oriented Design in Ruby

## SOLID Principles

* represents a set of five principles that, when all applied together, intend to
make it more likely that a programmer will create a system that is easy to maintain and extend over time.

### Single Responsibility

A class should have only one reason to change. One responsibility.

Bad Example:

```ruby
    class Report
        def generate
            puts 'generate report'
        end

        def save_to_file
            puts 'save to file'
        end
    end
```

Good Example:

```ruby
    class Report
        def generate
            puts 'generate report'
        end
    end

    class ReportSaver
        def save_to_file
            puts 'save to file'
        end
    end
```

### Open/Closed

A class should be open for extension but closed for modification.
You should be able to add new functionality to an object without modifying its structure.

Bad Example:

```ruby
    class Discount
        def apply(type, price)
            if type == :holiday
                price * 0.5
            elsif type == :clearance
                price * 0.8
            else
                price
            end
        end
    end
```

Good Example:

```ruby
    class Discount
        def apply(price)
            price
        end
    end

    class HolidayDiscount < Discount
        def apply(price)
            price * 0.5
        end
    end

    class ClearanceDiscount < Discount
        def apply(price)
            price * 0.8
        end
    end
```

### Liskov Substitution

### Interface Segregation

### Dependency Inversion
