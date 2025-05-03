# Creating Flexible Interfaces

It's tempting to think of object-oriented application as being sum of their
classes. Classes are so very visible; design discussions often revolve around class
responsibility and dependencies.

- Not just defined by classes, but defined by messages
- Design, therefore, must be concerned with the messages that pass between objects.

## Understand Interfaces

- Reveal as little as possible and know as little as possible

## Finding the Public Interface

### Example Bicyle Touring Company

FastFeed Services:
- road bike trips
- mountain bike trips

Domain Objects:
- bike
- route
  - difficulty  
- user
- rent

- Domain object are easy to find, but they are not at the design center of your application.
- Caution, if fixate on domain object you tend to coerce behavior into them.
- Design expert *notice* domain object, without concentrating on them.
- A good design will focus on the messages that pass between them.
- These messages are guides that lead you to discover other objects ones that are not as obvious.
- Before typing, form an intention about the object and the messages needed to satify this use case.

- Drawing this sequence diagram exposes the message passing between the 
  Customer Moe and the Trip class and prompts you to ask the question: “Should 
  Trip be responsible for figuring out if an appropriate bicycle is available for each 
  suitable trip?” or more generally, “Should this receiver be responsible for responding 
  to this message?”

- Therein lies the value of sequence diagrams. They explicitly specify the messages 
  that pass between objects, and because objects should only communicate using pub
  lic interfaces, sequence diagrams are a vehicle for exposing, experimenting with, and 
  ultimately defining those interfaces

- Also, notice now that you have drawn a sequence diagram, this design conversa
  tion has been inverted. The previous design emphasis was on classes and who and 
  what they knew. Suddenly, the conversation has changed; it is now revolving around 
  messages. Instead of deciding on a class and then figuring out its responsibilities, you 
  are now deciding on a message and figuring out where to send it.

- This transition from class-based design to message-based design is a turning 
  point in your design career. The message-based perspective yields more flexible 
  applications than does the class-based perspective. Changing the fundamental design 
  question from “I know I need this class, what should it do?” to “I need to send this 
message, who should respond to it?” is the first step in that direction.
