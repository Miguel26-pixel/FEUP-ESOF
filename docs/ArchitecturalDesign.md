# Architectural Design

The client-server pattern was chosen to implement the product because the system allows multiple clients to interact with each other and one of the most feasible ways to allow this is to have a common server. 

The MVC pattern was chosen for the app development because it is a simple and effective way to develop software, allowing easy planning and maintenance.

## Logical Architecture

In this system, there is present both a horizontal and vertical decomposition, since the horizontal decomposition can define layers and implementation concept and the vertical decomposition can define a hierarchy of subsystems that cover all layers of implementation.

![image](https://user-images.githubusercontent.com/13765599/162593488-7c86ac08-c3da-46d5-9f1c-2ef67a4d89fe.png)


## Physical Architecture

![image](https://user-images.githubusercontent.com/13765599/162593506-5087449c-c08d-46c3-9750-95219f74d4e4.png)

### User Mobile Device

This is the device where the student will access the Live@UP app. This is the application where the student can access and create alerts for various points of interest.

For the app development Flutter was the technology chosen due to its out-of-the-box components, allowing for fast prototyping. It is also the technology used by Uni. 

### API Server Machine

This is the machine which the API for this project will be stored and executed from. The API presents an interface to create, update and erase data on the database stored on the server. The database will store data like points of interest, alerts, alert types, and point of interest types.

The technology chosen for the server was Node.js because it has a lot of available frameworks, allowing a fast development, and it's a widely supported technology. 

Since there are not a lot of relevant relations between different models, and we need a fast and reliable database, MongoDB was chosen due to the characteristics of NoSQL databases.

### Sigarra Server Machine

This is the machine where the Sigarra application and database exist. The login services will be used to authenticate a student so that they can use the application.

## Vertical Prototype

### Map

The application contains a map indicating the current location of the user and several points of interest that the user can view. 

This was implemented using the [Flutter Map Package](https://pub.dev/packages/flutter_map). This package provides a map component using leaflet and OpenMaps. The current location of the user is provided by the [Location Package](https://pub.dev/packages/location). 

The current points of interest are currently being mocked.

<img src="https://user-images.githubusercontent.com/13765599/162593383-b8023562-0e55-45dd-abd0-cf83a966a962.jpg" width=300 />


### Point of Interest Page UI

The application allows one to see a point of interest's page by clicking on its icon on the map. Clicking on the point of interest shows a modal with information about the point of interest like current alerts and name.

Every alert on this page is displayed on a list with its name and icon, along with icon buttons to corroborate or reject it, which effect is not yet implemented.

This page also has icon buttons to subscribe to alerts on the point of interest and to access the statistics page, both of which are not yet implemented.

<img src="https://user-images.githubusercontent.com/64407719/162593110-9e7be32a-8962-4d55-b687-b247220711db.jpg" width=300 />

<img src="https://user-images.githubusercontent.com/64407719/162593122-ffd843c2-771d-4b0d-889d-3ca33ae3cbb3.jpg" width=300 />

<img src="https://user-images.githubusercontent.com/13765599/162593280-4a1c2be2-616a-444f-99e9-a6954caad125.gif" alt="drawing" width="300"/>

