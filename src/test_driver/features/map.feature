<<<<<<< HEAD
Feature: View Map
=======
Feature: Test
>>>>>>> main
    Map shows when Live@UP menu is selected

    Scenario: View map
        Given I open the side drawer
        And I tap the "Live@UP" button
        Then I view a location icon 
        And I view a warning icon
