Feature: Point of Interest Page
    Scenario: View Point of Interest Page
        Given I open the side drawer
        And I tap the "Live@UP" button
        When I tap a location icon
        Then I view the Point of Interest Page
    
    Scenario: Student views point of interest's no alert page
        Given I open the side drawer
        And I tap the "Live@UP" button
        When I tap a location icon of a point of interest with no alerts
        Then I view a no alerts page

    Scenario: Student views point of interest's alerts
        Given I open the side drawer
        And I tap the "Live@UP" button
        When I tap a location icon of a point of interest with alerts
        Then I view the alerts of the point of interest
