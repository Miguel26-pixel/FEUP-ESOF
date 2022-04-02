# Domain Model 
<p align="center" justify="center">
  <img src="https://github.com/LEIC-ES-2021-22/3LEIC09T2/blob/main/images/domainmodel.png"/>
</p>


**Student** - saves the general information of the student and their reputation that will influence what they are able to do in the app. 

**Administrator** - saves the general login information of the admin.

**Point of interest type** - defines groups of points of interest according to their purpose, for example study, food, printers etc. 

**Point of interest** - defines the point of interest, the attributes are name, position and floor so it can be properly shown in the map.

**Alert type** - defines a type of alert, it has a predefined message and duration. Different alert types are associated with different point of interest types. 

**General Alert** - saves the start time, finish time and updated score, which will determine for how long the alarm stays up. 

**Spontaneous Alert** - saves the custom message and inherits the attributes of general alert. 

**Alert** - inherits the attributes of the geral alert and it has a type of point of interest associated. 

**Notification** - only saves the time it was created and the student and alerts associated. 

