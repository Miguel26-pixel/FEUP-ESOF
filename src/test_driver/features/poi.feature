Feature: Point of Interest Page
    Scenario: View Point of Interest Page
        Given I open the side drawer
        And I tap the "Live@UP" button
        When I tap a location icon
        Then I view the Point of Interest Page