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
- DD (Date)

## Goals

The Goals of the Enterprise were not present in the initial model of the system.

## Business Processes

The Business Processes were not made explicit in the initial model.

The Business Processes includes several Business Process Models that were not present in the initial model.

The Business Processes are built out of a set of **Tasks**.

The Import Process may be modelled as a Business Process. We will present a high level of the overview of the tasks now making up the Import Process.

## The Import Process

An Agent starts the Import Process by generating an ENS (*ENS generation*), then the ENS is submitted to the Customs (*ENS submission*) that generates the MRNs (*MRNs generation*) and consigns the MRNs to the Agent (*MRNs consignement*).

After this the Agent generates a Policy (*Policy generation*) that uses to generate an MMA (*MMA generation*) that is then submitted to the Customs (*MMA submission*). The customs generates the A3s (*A3s generation*) and consigns the A3s to the Agent (*A3s consignement*).

After this, an Agent chooses a Customs Clearance Agent (*Customs Clearance Agent Choice*) and appoints him (*Appointment*).

After this, 3 parallel processes start.

The first one is carried out by an Agent that generates a Delivery Order (*Delivery Order generation*) and consigns the Delivery Order to the Customs Clearance Agent (*Delivery Order Consignment*).

The second parallel task is carried out by the Customs Clearance Agent that generates a Customs Declaration (*Customs Declaration generation*) and consigns it to the Customs.
The Customs may refuse to give Clearance (*Clearance Refused*) or generate a Clearance Code (*Clear Code generation*) and give Clearance (*Clearance OK*) to the Customs Clearance Agent.

The third parallel task is carried out by the Customs Clearance Agent that asks to the Terminal to book a Pickup (*Pickup booking*). The Terminal may refuse (*Pickup refusal*) or agree to book a Pickup (*Pickup OK*).

When the three parallel processes are all finished, the Customs Clearance Agent chooses a Delivery Service (*Delivery Service choice*), generates a WayBill (*Waybill generation*) and makes a Shipment Request to the Delivery Service (*Shipment Request*). The Delivery Service may refuse the Shipment (*Shipment refusal*) or make a Transport Request to the Deliverer (*Transport Request*). The Deliverer may refuse the Transport (*Transport Refusal*).

If the Deliverer tells the Delivery Service to agree with the transport request (*Transport OK*) than the Delivery Service gives its okay to the Customs Clearance Agent (*Shipment OK*). The CCA consigns the Leave Documentation (*Leave Documentation consignment*, were was the Leave Documentation generated?) to the Gate that can both reject the request (*Leave refusal*) or accept it (*Leave OK*). In this last case, the CCA books the Leave (*Leave booking*). The Gate checks if there is availability (*Availability Checking*). If not, it hey rejects the request (*Booking refusal*), otherwise it gives its ok (*Booking OK*).

After this, 2 parallel processes start.

The first process starts with the Deliverer asking access to the Terminal (*Access request*). The Terminal may refuse (*GateIn refusal*) or accept (*GateIn OK*). In this case the Deliverer enters the Terminal (*Terminal entering*) and it's loaded by the Terminal (*Truck loading*).

The second parallel task is started by the Gate asking to the Finance Police a Leave Permission (*Leave Permission request*) that may be rejected (*Leave Permission refusal*) or accepted (*Leave Permission OK*). In this case the Leave Permission is consigned to the Gate and the Deliverer (*Leave Permission consignment*).

When both these 2 tasks have been completed and the Deliverer receives an OK to leave the Terminal (*GateOut OK*) it exits the Terminal (*Terminal exiting*) and the Import Process is completed.

## Errors, problems, unclear points

The first thing we noticed was the lack of the necessary high level view of the Enterprise. Goals and Business Process were not made explicit and we had to add them by ourselves.

### Goals

We thought that the main goal (G) of the system was to "To make as many shipments as possible by following the correct procedures". This can be divided in 3 subgoals, "To make the necessary Delivery Order by following the correct procedures" (G1),  and "To setup the necessary leave authorizations and permissions for the shipment" (G2) and "To carry out the shipment by following the correct procedures" (G3).

### Business Processes

#### Business overview

The Business overview was not provided and we had to add it by ourselves.

We used the goals established in the previous step. For everyone of the subgoals G1, G2 and G3 we created a Business Process. For the goal G1 we create a Process "Generate and Send a Delivery Order" (P1), for the goal G2 we created a Process "Generate the necessary leave authorizations and permissions" (P2) and for the goal G3 we create the process "Perform the shipment and truck loading" (P3).

The process P1 requires as **Participants** an Agent, the Customs and a Customs Clearance Agent and produces a Delivery Order.

The process P2 requires as **Participants** the Customs and a Customs Clearance Agent, a Delivery Service, a Gate, a Terminal and a Deliverer.

The process P3 requires as **Participants** a Gate, a Terminal, a Deliverer and the Finance Police.

#### Inconsistensies in the views

In the "Agent static and Behaviour" the operation Custom.sendEns(ENS) that is called, does not exist. It should be Custom.eNS(ENS).

In the "Finance Police static and behavior" we needed to add the requestLeavePermission operation.

In the "Process import task" view (with the swimlanes) we had to rearrange the task in the correct swimlanes. We adopted the convention that the task had to be put under the swinlanes of the worker executing the task and had to point to the worker executing the task.

#### Errors

The behaviour view of the Customs Clearange Agent didn't make explicit that some activieties happened cuncurrently. We rewrote it to make it clear.







