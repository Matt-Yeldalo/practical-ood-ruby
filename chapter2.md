# Designing Classes with a Single Responsibility - Chapter 2

## What belongs in a class?

- You can't possible get it right first go

- Easy changes can be defined as:

  - Changes have no unexpected side effects
  - Small changes in requirements require correspondingly small changes in code
  - Existing code is easy to reuse

- These qualities can also be defined as TRUE

- Transparent
  - The consequences of change should be obvious in the code that is changing

- Reasonable
  - The cost of any change should be proportional to the benefits the change achieves

- Usable
  - Existing code can be easily used in new and unexpected contexts

- Exemplary
  - The code itself should encourage those who change it to perpetuate these qualities

## Single Responsibility Classes

- A class should do the smallest possible useful thing; i.e. it should have a
single responsibility

### Bikes Example

- Bikes can be broken down into parts, such as wheels, gears, and chains

```ruby
class Gear
    attr_reader :chainring, :cog, :rim, :tire
    def initialize(chainring, cog, rim, tire)
        @chainring = chainring
        @cog = cog
        @rim = rim
        @tire = tire
    end

    def ratio
        chainring / cog.to_f
    end

    def gear_inches
        ratio * (rim + (tire * 2))
    end
end

Gear.new(52, 11, 26, 1.5).gear_inches
Gear.new(52, 11).ratio # This used to work, but now it doesn't
```

### Why it matters

- Easy to change applications consist reusable classes (pluggable units of
well-defined behaviour with few entablgements)

- A class that has more than one resonsibility is difficult to reuse

- One bad option is duplicating the code - This leads to additional maintenance
and increased bugs

- Another bad option is to inherit from the class - This leads to a class that is
difficult to understand and maintain

- If the class youre working on is difficult to understand, it's likely that the
class has more than one responsibility

### Determining if a class has a single responsibility

- Pretend the class is sentient and interrogate it, rephrase methods as a question

  - ✔️ "Mr. Gear, what is your ratio?"

  - ❌ "Mr. Gear, what is your tire (size)?"

- Attempt to describe the class in a single sentence

  - If the explanation uses the word 'and', the class likely has more than one responsibility

  - If it uses the word 'or', the class likely has more than one responsibility
    (may be unrelated)

- This concept is called *cohesion*. Everything in a class is related to its
central purpose

- Related to Responbility-Driven Design (RDD). A class has responbilities that
fufill its purpose

### When to make design decesions

- Do not feel compelled to make design decisions prematurely

- Ask yourself: "What is the future cost of doing nothing today?"

## Writing Code that Embraces Change

- You can arrange code so that Gear will be easy to change

## Depend on behaviour, not data

- When creating a SR class, every bit of behaviour lives in one and only one place

- Related to DRY (Don't Repeat Yourself)

- Hide Instance Variables
  - Always wrap instance variables in accessor methods instead of direct reference.
  - do **NOT** do this:

  - ```ruby
     class Gear
       def initialize(chainring, cog)
        @chainring = chainring
        @cog = cog
       end

       def ration
         @chainring / @cog.to_f # <-- bad
       end
     end
    ```

  - Hide the variables by utilising attr_reader
  - do **THIS**:

  - ```ruby
      class Gear
        attr_reader :chainring, :cog
        def initialize(chainring, cog)
          @chainring = chainring
          @cog = cog
        end

        def ratio
          chainring / cog.to_f
        end
      end
    ```

- This can allow for changing the implementation of cog

  - ```ruby
      def cog
        @cog * unanticipated_adjustment_factor
      end
    ```

- Hide data from yourself to protect the code from unpexpected changes

### Hide Data

- Avoid depending on a complicated data structure

```ruby
class ObscuringReferences
  attr_reader :data
  def initialize(data)
    @data = data
  end

  def diameters
    # 0 is the rim, 1 is the tire
    data.collect { |cell|
      cell[0] + (cell[1] * 2)
    }
  end
end
```

- This code is difficult to understand because it depends on the structure of
the data
- When you have data in a an array, it is not long until you have references to said array

- References are leaky, they esacpe the class and spread throughout the codebase, not DRY

- Direct references into complicated strucures are confusing and error-prone, they obscure

- In Ruby it's easy to sepearate the structure from the data, using a method wrapper

- This can be done by using the Struct class to wrap a structure. New implementation:

```ruby
  class RevealingReferences
    attr_reader :wheels
    def initialize(data)
      @wheels = wheelify(data)
    end

    def diameters
      wheels.collect { |wheel|
        wheel.rim + (wheel.tire * 2)
      }
    end

    # now everyone can send rim/tire to wheel
    Wheel = Struct.new(:rim, :tire)
    def wheelify(data)
      data.collect { |cell|
        Wheel.new(cell[0], cell[1])
      }
    end
  end
```


