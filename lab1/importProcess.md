# The Harbour Import Process

According to the **"Precise enterprise modelling with UML"** we can model the harbour import process as an Enterprise.

An Enterprise is primarily composed by Business Entities, Business Processes and Goals.

## Business Entities

The Business Entities of the Enterprise can be of four types:

- workers
- system
- business objects
- organizational units

The Workers of the the harbour Enterprise presented in the initial model (in the Static View) were:

- Agents
- Customs
- Customs Clearance Agents (CCA)
- Deliverers
- Finance Police
- Deliverers
- Delivery Services
- Gates
- Terminals

There are no systems in the Enterprise.

The Organizational Units are:

- Harbour

The Business Objects of the Enterprise presented in the initial model (in the Static View) were:

- ENS (Entry Summary Declarations)
- MMA
- Waybill
- Permission
- Delivery Order
- Container
- Policy
- Customs Declaration (CD)
- Truck
- Clearance Code (CC)
- AIDA
- Terminal Area
- A3


We found some more Business Objects were necessary for the Import Process:

- MRNs (Movement Reference Number)
- DD

## Goals

The Goals of the Enterprise were not present in the initial model of the system.

## Business Processes

The Business Processes were not made explicit in the initial model.

The Business Processes includes several Business Process Models that were not present in the initial model.

The Business Processes are built out of a set of **Tasks**.

The Import Process may be modelled as a Business Process. We will present a high level of the overview of the tasks now making up the Import Process.

## The Import Process

An Agent starts by generating an ENS (*ENS generation*), then the ENS is submitted to the Customs (*ENS submission*) that generates the MRNs (*MRNs generation*) and consigns the MRNs to an Agent (*MRNs consignement*).

An Agent generates a Policy (*Policy generation*) used to generate an MMA (*MMA generation*) that is then submitted to the Customs (*MMA submission*) that in turns generates the A3s (*A3s generation*) and consigns the A3s to an Agent (*A3s consignement*).

After this an Agent chooses a Customs Clerance Agent (*Customs Clearance Agent Choice*) and appoints him (*Appointment*).

After this, 3 parallel processes starts.

The first one is carried out by an Agent generates a Delivery Order (*Delivery Order generation*) and consigns the Delivery Order to the Customs Clerance Agent (*Delivery Order Consignment*).

The second parallel task is carried out by the Customs Clearance Agent that generates a Customs Declaration (*Customs Declaration generation*) and consigns it to the Customs.
The Customs may refuse to give Clearance (*Clearance Refused*) or generate a Clearance Code (*Clear Code generation*) and give Clearance (*Clearance OK*) to the Customs Clearance Agent.

The third parallel task is carried out by the Customs Clearance Agent that asks to the Terminal to book a Pickup (*Pickup booking*, this operation returns a DD in the initial model, it should be a Deliverer, a D). The Terminal may refuse (*Pickup refusal*) or agree to book a Pickup (*Pickup OK*).

When the three parallel process are all finished, the Customs Clearance Agent chooses a Delivery Service (*Delivery Service choice*), generates a WayBill (*Waybill generation*) and makes a Shipment Request to a Terminal (*Shipment Request*). The Terminal may refuse the Shipment (*Shipment refusal*) or make a Transport Request to the Delivery Services(*Transport Request*). In this case the Delivery Service and the Deliverer may refuse the Transport (*Transport Refusal*).

If they tell the Terminal they are okay with the Transport Request (*Transport OK*) than the Terminal authorize the Shipment to a Customs Clearance Agent (*Shipment OK*). The CCA consigns the Leave Documentation (*Leave Documentation consignment*, were was the Leave Documentation generated?) to the Gate that can both reject the request (*Leave refusal*) or accept it (*Leave OK*). In this last case, the CCA books the Leave (*LEAVE booking*). The Gate and the Deliverer check if there is availability (*Availability Checking*). If not they reject the request (*Booking refusal*), otherwise the give their ok (*Booking OK*).

After this, 2 parallel processes starts.

The first process starts with the Deliverer asking access to a Terminal (*Access request*). The Terminal may refuse (*GateIn refusal*) or accept (*GateIn OK*). In this case the Deliver enters the Terminal (*Terminal entering*) and it's unloaded by the Terminal (*Truck unloading*).

The second parallel task is started by the Gate asking to the Finance Police a Leave Permission (*Leave Permission request*) that may be rejected (*Leave Permission refusal*) or accepted (*Leave Permission OK*). In this case the Leave Permission is consigned to the Gate and the Deliverer (*Leave Permission consignment*).

When both these 2 tasks have been completed the Deliverer receives an OK to leave the Terminal (*GateOut OK*) and exits the Terminal (*Terminal exiting*).

## Errors, problems, unclear points

The first thing we noticed was the lack of the necessary high level view of the Enterprise. Goals and Business Process were not made explicit and we had to add them by ourselves.

### Goals

We thought that the main goal of the system was to "To make as many shipments as possible by following the correct procedures". This can be divided in two subgoals, "To make as many shipments as possible" and "To ensure that the correct procedures are followed".



