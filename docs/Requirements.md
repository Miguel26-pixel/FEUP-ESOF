
## Requirements

### Use case model 


<p align="center" justify="center">
  <img src="https://github.com/LEIC-ES-2021-22/3LEIC09T2/images/usecase.png"/>
</p>

|     |     |
| --- | --- |
| *Name* | View Points of Interest |
| *Actor* |  Student | 
| *Description* | The student views a map with the predefined points of interest and other alerts nearby |
| *Preconditions* | None |
| *Postconditions* | - The student views the map. <br>- If the student decides to search for the name of a point of interest or filter according to the type of point of interest, only the corresponding points will be shown in the map.|
| *Normal flow* | 1. The student accesses the app. <br> 2. The app shows a map of FEUP and nearby points of interest or other alerts. <br> 3. The student can select the search bar and provide the name of the desired point of interest <br>4. The student can select the filters button and choose the filters that best descibe what they're looking for (ex: place to eat, coffee machine, etc ) <br> 5. The points of interests available in the map will change according to the information provided |
| *Alternative flows and exceptions* | |

|     |     |
| --- | --- |
| *Name* | View Alert |
| *Actor* |  Student | 
| *Description* | The student views an alert. He can optionally validate the alert. |
| *Preconditions* | None |
| *Postconditions* | - The student views information about the alert. <br>- If the student decides to confirm the alert, the information will be kept.<br>- If enough students decide to reject the alert, it will be removed from the system and other students won't be able to see it anymore.|
| *Normal flow* | 1. The student accesses the app. <br> 2. The app shows a map of FEUP and nearby points of interest or other alerts. <br> 3. The student selects a nearby point of interest in the map and the app shows its page.<br> 4. The system provides a list of alerts relative to that point of interest.<br> 6. The student selects one of the alerts<br> 7. The student visualizes the relevant information about the alert. <br> 8. The student may confirm or reject an alert, keeping information in the system up to date. |
| *Alternative flows and exceptions* | 1. [Spontaneous Alert] If, in step 3 of the normal flow the user selects an alert without a specific point of interest, the student will be redirected to step 7. |


|     |     |
| --- | --- |
| *Name* | View Point of Interest's Page |
| *Actor* |  Student | 
| *Description* | The student views information about a point of interest. He can optionally view statistics and subscribe to alerts. |
| *Preconditions* | None |
| *Postconditions* | - The student views information about the point of interest. <br>- If the student decides to view statistics, the system will show an analysis of the alerts over time.<br>- If the student decides to subscribe to alerts in the point of interet, whenever a new alert is created, the student will receive a notification.|
| *Normal flow* | 1. The student accesses the app. <br> 2. The app shows a map of FEUP and nearby points of interest or other alerts. <br> 3. The student selects a nearby point of interest in the map and the app shows its page.<br> 4. The system provides information about the selected point of interest and a list of its alerts.<br> 5. The student may choose to view statistics about the alerts of the selected point of intereset, giving the students the possibiliy of, for example, checking availability over time. <br> 7. The student may subscribe to notifications in order to receive updates when a new alert is created.|
| *Alternative flows and exceptions* | |

|     |     |
| --- | --- |
| *Name* | Create Alert |
| *Actor* |  Student | 
| *Description* | The student creates an alert on a point of interest from a set of predefined alert types. |
| *Preconditions* | - The student must be close to the point of interest. <br> - The student can't have negative reputation. |
| *Postconditions* | - The created alert is added to the point of interest's page. <br> - Notifications are sent to students who are subscribed to that point of interest. <br> - Nearby students receive a message asking if the alert is valid. |
| *Normal flow* | 1. The student accesses the app. <br> 2. The app shows a map of FEUP and nearby points of interest or other alerts. <br> 3. The student selects a nearby point of interest in the map and the app shows its page. <br> 4. The student creates an alert, choosing an alert type. |
| *Alternative flows and exceptions* |  |


|     |     |
| --- | --- |
| *Name* | Create Spontaneous Alert |
| *Actor* |  Student | 
| *Description* | The student creates an alert in their location, which is not assigned to one of the predefined points of interest|
| *Preconditions* | - The student must not be in any predefined points of interest. <br> - The student can't have negative reputation. |
| *Postconditions* | - The created alert is added to the map in the student's location.  <br> - Nearby students receive a message asking if the alert is valid. |
| *Normal flow* | 1. The student accesses the app. <br> 2. The app shows a map of FEUP and nearby points of interest or other alerts. <br> 3. The student selects the option to create an alert <br> 4. The student creates a custom alert giving it a description. |
| *Alternative flows and exceptions* |- If in step 3 the student is nearby one of the pre defined points of interest, the student is redirected to the point of interest's page. |

|     |     |
| --- | --- |
| *Name* | Manage Points of Interest |
| *Actor* |  Admin | 
| *Description* | The app administrator creates, edits or deletes points of interest. |
| *Preconditions* | - None. |
| *Postconditions* | - Point of interest's information is updated, created or deleted. |
| *Normal flow* | 1. The administrator opens the administration dashboard.<br> 2. The dashboard contains information of existing points of interest and how to create new ones.<br> 3. The admin chooses a point of interest to edit, delete or creates a new one.<br> 4. The admin confirms their choice and complete the action.<br> 5. The system shows the updated information. |
| *Alternative flows and exceptions* | 1. [Edit Point of Interest] If, in step 3, the admin chooses a point of interest, they can edit the point of interest's information, such as name, location and type, and continue to step 4. <br> 2. [Create Point of Interest] If, in step 3, the admin creates a point of interest, they can supply information about the new point of interest, such as name, location and type, and continue to step 4. <br> 3. [Delete Point of Interest] If, in step 3, the admin chooses a point of interest, they can delete that point of interest and continue to step 4.|

|     |     |
| --- | --- |
| *Name* | Manage Alert Types |
| *Actor* |  Admin | 
| *Description* | The app administrator creates, edits or deletes types of alerts. |
| *Preconditions* | - None. |
| *Postconditions* | - A type of alert is updated, created or deleted. |
| *Normal flow* | 1. The administrator opens the administration dashboard.<br> 2. The dashboard contains information of existing alert types and how to create new ones.<br> 3. The admin chooses an alert type or creates a new one.<br> 4. The admin confirms their choice and completes the action.<br> 5. The system shows the updated information. |
| *Alternative flows and exceptions* | 1. [Edit Alert Type] If, in step 3, the admin chooses an alert type , they can edit the alert type's information, such as name and category, and continue to step 4. <br> 2. [Create Alert Type] If, in step 3, the admin creates an alert type, they can supply information about the new alert type, such as name and category, and continue to step 4. <br> 3. [Delete Alert Type] If, in step 3, the admin chooses an alert type, they can delete that alert type and continue to step 4.|
