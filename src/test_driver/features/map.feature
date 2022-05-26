Feature: Test
    Map shows when Live@UP menu is selected

    Scenario: View map
        Given I open the side drawer
        And I tap the "Live@UP" button
        Then I view a location icon 