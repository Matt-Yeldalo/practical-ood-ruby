# Designing Classes with a Single Responsibility - Chapter 2

## What belongs in a class?

- You can't possible get it right first go

- Easy changes can be defined as:

- - Changes have no unexpected side effects
- - Small changes in requirements require correspondingly small changes in code
- - Existing code is easy to reuse

- These qualities can also be defined as TRUE

- Transparent
- - The consequences of change should be obvious in the code that is changing

- Reasonable
- - The cost of any change should be proportional to the benefits the change achieves

- Usable
- - Existing code can be easily used in new and unexpected contexts

- Exemplary
- - The code itself should encourage those who change it to perpetuate these qualities

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

- - ✔️ "Mr. Gear, what is your ratio?"

- - ❌ "Mr. Gear, what is your tire (size)?"

- Attempt to describe the class in a single sentence

- - If the explanation uses the word 'and', the class likely has more than one responsibility

- - If it uses the word 'or', the class likely has more than one responsibility
(may be unrelated)

- This concept is called *cohesion*. Everything in a class is related to its 
central purpose

- Related to Responbility-Driven Design (RDD). A class has responbilities that 
fufill its purpose

### When to make design decesions

- Do not feel compelled to make design decisions prematurely

- Ask yourself: "What is the future cost of doing nothing today?"

## Writing Code that Embraces Change
