Feature: Create Alert
    Create alert in a point of interest

    Scenario: Create alert
        Given I open the side drawer
        And I tap the "Live@UP" button
        And I tap a location icon
        And I tap the create alert button
        And I choose an alert type
        And I tap the confirm button
        Then I view a warning icon
