Feature: Spontaneous Alert
    Scenario: View Spontaneous Alert
        Given I open the side drawer
        And I tap the "Live@UP" button
        When I tap a warning icon
        Then I view the Spontaneous Alert page

    Scenario: View Create Spontaneous Alert Page
        Given I open the side drawer
        And I tap the "Live@UP" button
        When I tap the create spontaneous button
        Then I view the Create Spontaneous Alert Page