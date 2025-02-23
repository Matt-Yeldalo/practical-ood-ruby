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
