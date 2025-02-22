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

Subclasses should be substitutable for their base class without breaking functionality.

Bad Example:

```ruby
class Bird
  def fly
    puts "Flying!"
  end
end

class Penguin < Bird
  def fly
    raise "Penguins can't fly!"
  end
end

```

Good Example:

```ruby
 class Bird
 end

 class FlyingBird < Bird
   def fly
     puts "Flying!"
   end
 end

 class Penguin < Bird
     def swim
         puts "Swimming!"
     end
 end
```

### Interface Segregation

A class should not be forced to implement interfaces it does not use.

Bad Example:

```ruby
class Worker
    def work
        puts 'working...'
    end

    def eat
        puts 'eating...'
    end
end

class RobotWorker < Worker
    def eat
        raise 'robots do not eat'
    end
end
```

Good Example:

```ruby
module Workable
    def work
        puts 'working...'
    end
end

module Eatable
    def eat
        puts 'eating...'
    end
end

class HumanWorker
    include Workable
    include Eatable
end

class RobotWorker
    include Workable
end
```

### Dependency Inversion

High-level modules should not depend on low-level modules. Both should depend on abstractions.

Bad Example:

```ruby
class MySqlDatabase
    def connect
        puts 'connecting to mysql database'
    end
end

class UserService
    def initialize
        @db = MySqlDatabase.new
    end

    def fetch_user
        @db.connect
        puts 'fetching user'
    end
end
```

Good Exmaple:

```ruby
class Database
    def connect
        raise NotImplementedError
    end
end

class MySqlDatabase < Database
    def connect
        puts 'connecting to mysql database'
    end
end

class PostgresDatabase < Database
    def connect
        puts 'connecting to postgres database'
    end
end

class UserService
    def initialize(db)
        @db = db
    end

    def fetch_user
        @db.connect
        puts 'fetching user'
    end
end

db = MySqlDatabase.new
service = UserService.new(db)
service.fetch_user
```


