# Harbour Import process

We modelled the Harbour import process as a BPMN model where the Participants are the workers of the previous Lab. We introduced a Pool with a single swimlane for every Parcipant, we modelled the tasks with BPMN tasks and the communication among the Participants with Send and Receive Tasks. We decided not to use Message Events.

## What BPMN makes easy (compared to UML)

BPMN offered a more high-level view of the process and it makes explicit who is doing what. In the UML activity diagram, the swimlanes are not in the standard UML. By looking at a BPMN pool is easier to grasp the behavior of a single Participant. What BPMN makes generally easier is to have a complete picture of a process in a single Diagram.

Something else that is easier with BPMN is to see when a conditional is evaluated and what kind of events are happening that drive the process. Expressing something like "after 60 minutes" with UML would not be easy.

It is also easier to describe the private Business Processes, or at least the notation is more uniform.

By using the Conversation diagram it's easier with BPMN to get a even higher-level view of the communications happening in the process.

Other things that may be really helpful in describing a Business Process are the Transactions and Call Activity Tasks. The first one is not easy to replicate with UML while the second offers an interesting possibility to encapsulate some grouped tasks.

## What BPMN cannot do

Apparently what we were unable to do with BPMN was to get a more detailed view of the process. For instance it's not possible to express the equivalent of a Behavior view and highlight the states of a Participant. It's also not possible to create the equivalent of a Class Diagram. In a way it's more difficult to see the details of a single Participant instead of focusing on the whole Proces.

Also a language like OCL is not provided by the BPMN specifications to define pre and post conditions and invariants. These may be only expressed with informal language.

There is also no native support for modelling something like goals or an operative view. The first may be modelled anyway (as it is not included in UML as well) while the second would appear much more clumsy.

Our general opinion is that BPMN is easier to use and more expressive in its (more limited) domain while UML is more general and complete but less suited to model Business processes.
