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

This technique is known as *dependency injection*

- *Gear* previously had explicit dependencies on the *Wheel* class and other factors
such as type and order of initializer

- Using DI, *Gear* has reduced it to a single dependency; The diameter method

- To implement this you need the ability to distinguish between the messages
and the classes that respond to them

- Just because *Gear* needs to send diameter somewhere, does note mean that
*Gear* should know about *Wheel*

## Isolating Dependencies

- If you can't change the code to inject the *Wheel*, you should isolate the creation

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
    ratio * wheel.diameter
  end

  def wheel
    @wheel ||= Wheel.new(rim, tire)
  end
end
```

- This is also a simple example of the **Lazy Initialization** pattern
- In both these examples, *Gear* still knows too much, taking init args

### Isolate Vulnerable External Messages

After spending some time with external class names, it's time to
focus on external *messages*

- This refers to messages that are sent to someone other than *self*

### Using Keyword Arguments

```ruby
class Gear
  attr_reader :chainring, :cog, :wheel
  def initialize(chainring:, cog: wheel:)
    @chainring = chainring
    @cog = cog
    @wheel = wheel
  end
end
Gear.new(chainring: 'chain', cog: 'cog', wheel: Wheel.new)
```

Using keyword arguments requires the sender and the receiver of a message to
state the keyword names. This results in explicit documentation at both ends of the
message. Future maintainers will be grateful for this information.

- Keyword arguemtns are so flexible that the general rule is that you should
*prefer* them.

### Explicitly Define Defaults

```ruby
class Gear
  attr_reader :chainring, :cog, :wheel
  def initialize(chainring: default_chainring, cog: 18, wheel:)
    @chainring = chainring
    @cog = cog
    @wheel = wheel
  end
  def default_chainring
    (100 * 20) / 50 # random code
  end
end

puts Gear.new(wheel: Wheel.new(26, 1.5)).chainring
```

The key to understanding the above code is to recognize that initialize
executes in the new instance of *Gear*. It is therefore appropriate for
initialize to send messages to self.

- Don't hesitate to send a message to self if you require more logic
  when initializing defaults

### Isolate Multiparameter Initialization

So far, all the examples of removing argument-order dependencies have
been for situations where you control the signature of the method that
needs to change. You will not always have this luxury

In this example:

- `SomeFramework::Gear` is not owned by your application.
- It is part of an external framework
- *GearWrapper* was created to avoid having multiple dependencies
- *GearWrapper* isolates all knowledge of the external interface
  in one place and equally important, it provides an improved
  interface for your application.

```ruby
module SomeFramework
  class Gear
    attr_reader :chainring, :cog, :wheel
    def initialize(chainring, cog, wheel)
      @chainring = chainring
      @cog = cog
      @wheel = wheel
    end
  end
end

module GearWrapper
  def self.gear(chainring:, cog:, wheel:)
    SomeFramework::Gear.new(chainring, cog, wheel)
  end
end

puts GearWrapper.gear(chainring: 52, cog: 11, wheel: Wheel.new(26, 1.5)).gear_inches
```

- If you are unable to change the method, wrap it to protect it

## Managing Dependency Direction

- Dependencies have a direction, how do you decide on the direction?

### Reversing Dependencies

Every example used thus far show *Gear* depending on *Wheel* or diameter,
but the code could have been written with the direction of the dependencies reversed

Wheel could instead depend on *Gear* or ratio. The following example illustrates one
possible form of the reversal.

Here *Wheel* has been changed to depend on Gear and gear_inches. Gear is still responsible
for the actual calculation, but it expects a diameter argument to be passed

## Summary

Dependency management is core to creating future-proof applications. Injecting
dependencies creates loosely coupled object that can be reused in novel ways.
Isolating dependencies allows objects to quickly adapt to unexpected changes.
Depending on abstractions decreases the likelihood of facing these changes.

The key to managing dependencies is to control their direction.

Ensure the if a depends on b, b changes less often than a
