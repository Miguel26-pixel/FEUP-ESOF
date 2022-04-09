# Architectural Design

The client-server pattern was chosen to implement the product because the system allows multiple clients interacting with each other and one of the most feasible ways to allow this is to have a common server. 

The MVC pattern was chosen to the app development because it is a simple and effective way to develop software, allowing easy planning and maintenece.

## Logical Architecture

In this system there is present both a horizontal and vertical decomposition, since the horizontal decomposition can define layers and implementatin concept and the vertical decomposition can define a hierarchy of subsystems that cover all layers of implementation.

## Physical Architecture

For the app development Flutter was the technology chosen due to it's out of the box components, allowing for a fast prototyping. It is also the technology used by Uni. 

The technology chosen for the server was Node.js because it has a lot of available frameworks, allowing a fast development, and it's a widely supported technology. 

Since there are not a lot of relevant relations between diferent models, and we need a fast and reliable database, MongoDB was chosen due to the characteristics of NoSQL databases.


## Vertical Prototype

### Map

The application contains a map indicating the current location of the user and several points of interest that the user can view. 

This was implemented using the [Flutter Map Package](https://pub.dev/packages/flutter_map). This package provides a map component using leaflet and OpenMaps. The current location of the user is provided by the [Location Package](https://pub.dev/packages/location). 

The current points of interest are currently being mocked.

### Point of Interest Page UI

The application allows to see a point of interest's page by clicking on its icon on the map. Clicking on the point of interest shows a modal with information about the point of interest like current alerts, and name.

Every alert on this page is displayed on a list with its name and icon, along with icon buttons to corroborate or reject it, which effect is not yet implemented.

This page also has icon buttons to subscribe to alerts on the point of interest and to access the statistics page, both of which are not yet implemented.

<img src="https://user-images.githubusercontent.com/64407719/162593110-9e7be32a-8962-4d55-b687-b247220711db.jpg" width=300 />

<img src="https://user-images.githubusercontent.com/64407719/162593122-ffd843c2-771d-4b0d-889d-3ca33ae3cbb3.jpg" width=300 />
![ezgif com-gif-maker(1)](https://user-images.githubusercontent.com/13765599/162593280-4a1c2be2-616a-444f-99e9-a6954caad125.gif)


