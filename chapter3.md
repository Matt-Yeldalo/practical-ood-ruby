# Managing Dependencies - Chapter 3

- Since well-designed object have a single responsibility, their nature requires
that they collaborate to accomplish complex tasks

- To collaborate, objects must know each other, *knowing* creates a dependency

- Poorly managed dependencies have the potential to strangle your application

## Understanding Dependencies

- An object depends on another object if, when one object changes, the
other might be forced to change in turn.

- Modified *Gear* class where Gear is initialized with four familiar arguments

```ruby
class Gear
  attr_reader :chainring, :cog, :rim, :tire
  def initialize(chainring, cog, rim, tire)
    @chainring = chainring
    @cog = cog
    @rim = rim
    @tire = tire
  end

  def gear_inches
    ratio * Wheel.new(rim, tire).diameter
  end

  def ratio
    chainring / cog.to_f
  end
end

class Wheel
  attr_reader :rim, :tire
  def initialize(rim, tire)
    @rim = rim
    @tire = tire
  end

  def diameter
    rim + (tire * 2)
  end
end
```

The *Gear* dependencies:

- Class name - *Gear* expects the class *Wheel* the exist
- Message name - *Gear* expects *Wheel* to respond to .diameter
- Arguments - *Gear* knows *Wheel*.new requires a *rim* and *tire*
- Argument order - *Gear* knows that *Wheel* takes positional arguments

Each of these may result in a situation where *Gear* would be forced to
change if *Wheel* changes.

- Some degree of dependency between these two classes is inevitable
- Most the ones listed above are unnecessary, making the code less *reasonable*
- Your design challenge is to manage dependencies so that each class has the
**fewest possible**

## Writing Loosely Coupled Code

- Every dependency is like a little dot a of glue that causes the class to
stick to things it touches

### Inject Dependencies

- Referring to another class by its name creates a major stick spot

```ruby
class Gear
  attr_reader :chainring, :cog, :rim, :tire
  def initialize(chainring, cog, rim, tire)
    @chainring = chainring
    @cog = cog
    @rim = rim
    @tire = tire
  end

  def gear_inches
    ratio * Wheel.new(rim, tire).diamter
  end
end
```

- On the face of it, this code is fine
- In truth, dealing with the name change is a relatively minor issue. However;
A deeper problem exists that is far less visible and more destructive

When *Gear* hard-codes a reference to Wheel deep inside its gear_inches method,
it is explicitly declaring that it is only willing to calculate gear inches for
instances of *Wheel*.

- *Gear* refuses to collaborate with any other kind of object, event if that object
has a diameter and uses gears.

- The code above exposes an unjustified attachment to type
- It's not the class of the object that's important, it's the **message**
you plan to send to it
- *Gear* needs an object that responds to .diameter, this is a **duck type**
- *Gear* does not care and should not know about the class of that object, it
also does not need tot know about the existence of the *Wheel* class in order
to calculate gear inches
- *Gear* doesn't need to know that *Wheel* expects to be initialized with a rim
and then a tire; it just needs an object that knows diameter

Hanging these unnecessary dependencies on *Gear* simultaneously reduces *Gear's*
re usability and increases the susceptibility to being forced to change unnecessarily

Gear becomes less useful when it knows too much about other object; if it knew less,
it could do more.

New version of Gear:

```ruby
class Gear
  attr_reader :chainring, :cog, :wheel
  def initialize(chainring, cog, wheel)
    @chainring = chainring
    @cog = cog
    @wheel = wheel
  end

  def gear_inches
    ratio * wheel.diameter
  end
end
```

- Gear now uses the **@wheel** variable to hold, and the **wheel** method to access
- Moving *Wheel* creation outside of *Gear* decouples the two classes
- *Gear* can now collaborate with any object that implements diameter
