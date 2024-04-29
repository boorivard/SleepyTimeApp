//
//  SplashScreenUITests.swift
//  SleepyTimeAppUITests
//
//  Created by Jared Rivard on 4/28/24.
//

import XCTest
@testable import SleepyTimeApp
import FirebaseFirestoreInternal

final class SplashScreenUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    func testSplashScreenTransition() {
            // Test that the splash screen transitions to ContentView when isActive is true
            app.launchArguments.append("-isActive") // Set the launch argument to simulate isActive being true
            app.launch()

            let contentView = app.otherElements["ContentView"]
            XCTAssertTrue(contentView.exists, "ContentView should be displayed")
        }
}
class AuthenticationViewUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testSignInWithValidCredentials() throws {
        // Navigate to AuthenticationView
        app.buttons["Sign In"].tap()
        
        // Fill in email and password
        let emailTextField = app.textFields["Email"]
        emailTextField.tap()
        emailTextField.typeText("validemail@example.com")

        let passwordTextField = app.secureTextFields["Password"]
        passwordTextField.tap()
        passwordTextField.typeText("validpassword")

        // Tap Sign In button
        app.buttons["Sign In"].tap()

        // Assert that user is logged in
        XCTAssertTrue(app.staticTexts["SleepyTime App"].exists)
    }

    func testSignUpWithInvalidCredentials() throws {
        // Navigate to AuthenticationView
        app.buttons["Sign In"].tap()
        
        // Tap "Don't have an account? Sign up"
        app.buttons["Don't have an account? Sign up"].tap()

        // Fill in invalid email and password
        let emailTextField = app.textFields["Email"]
        emailTextField.tap()
        emailTextField.typeText("invalidemail")

        let passwordTextField = app.secureTextFields["Password"]
        passwordTextField.tap()
        passwordTextField.typeText("short")

        // Tap Sign Up button
        app.buttons["Sign Up"].tap()

        // Assert that error alert is displayed
        XCTAssertTrue(app.alerts["Error Signing Up"].exists)
    }

    override func tearDownWithError() throws {
        app = nil
        try super.tearDownWithError()
    }
}
// AuthenticationViewUITests
extension AuthenticationViewUITests {
    func testSignOut() {
        // Navigate to AuthenticationView
        app.buttons["Sign In"].tap()

        // Sign in with valid credentials
        let emailTextField = app.textFields["Email"]
        emailTextField.tap()
        emailTextField.typeText("validemail@example.com")

        let passwordTextField = app.secureTextFields["Password"]
        passwordTextField.tap()
        passwordTextField.typeText("validpassword")

        app.buttons["Sign In"].tap()

        // Assert user is logged in
        XCTAssertTrue(app.staticTexts["SleepyTime App"].exists)

        // Sign out
        app.buttons["Sign Out"].tap()

        // Assert user is signed out
        XCTAssertTrue(app.buttons["Sign In"].exists)
    }

    func testToggleSignUpSignIn() {
        // Navigate to AuthenticationView
        app.buttons["Sign In"].tap()

        // Tap "Don't have an account? Sign up"
        app.buttons["Don't have an account? Sign up"].tap()

        // Assert sign-up view is displayed
        XCTAssertTrue(app.buttons["Sign Up"].exists)

        // Tap "Already have an account? Sign in"
        app.buttons["Already have an account? Sign in"].tap()

        // Assert sign-in view is displayed
        XCTAssertTrue(app.buttons["Sign In"].exists)
    }
}
// SplashScreenUITests
extension SplashScreenUITests {
    func testSplashScreenShowsActivityIndicator() {
        // Test that the splash screen shows the activity indicator
        app.launch()

        let activityIndicator = app.activityIndicators.firstMatch
        XCTAssertTrue(activityIndicator.exists, "Activity indicator should be displayed on the splash screen")
    }

    func testSplashScreenDismissalOnDataNotLoaded() {
        // Test that the splash screen dismisses when data is not loaded
        app.launchArguments.append("-dataNotLoaded") // Set the launch argument to simulate data not being loaded
        app.launch()

        let splashScreen = app.otherElements["SplashScreen"]
        XCTAssertFalse(splashScreen.exists, "Splash screen should dismiss when data is not loaded")
    }
}
// AuthenticationViewUITests
extension AuthenticationViewUITests {
    func testSignInWithEmptyFields() {
        // Navigate to AuthenticationView
        app.buttons["Sign In"].tap()

        // Tap Sign In button without filling in email and password
        app.buttons["Sign In"].tap()

        // Assert that error alert is displayed
        XCTAssertTrue(app.alerts["Default_Title"].exists)
    }

    func testSignUpWithValidCredentials() {
        // Navigate to AuthenticationView
        app.buttons["Sign In"].tap()

        // Tap "Don't have an account? Sign up"
        app.buttons["Don't have an account? Sign up"].tap()

        // Fill in valid email and password
        let emailTextField = app.textFields["Email"]
        emailTextField.tap()
        emailTextField.typeText("newuser@example.com")

        let passwordTextField = app.secureTextFields["Password"]
        passwordTextField.tap()
        passwordTextField.typeText("newpassword")

        // Tap Sign Up button
        app.buttons["Sign Up"].tap()

        // Assert that success alert is displayed
        XCTAssertTrue(app.alerts["Account Successfully Created"].exists)
    }

    func testSignInWithInvalidCredentials() {
        // Navigate to AuthenticationView
        app.buttons["Sign In"].tap()

        // Fill in invalid email and password
        let emailTextField = app.textFields["Email"]
        emailTextField.tap()
        emailTextField.typeText("invaliduser@example.com")

        let passwordTextField = app.secureTextFields["Password"]
        passwordTextField.tap()
        passwordTextField.typeText("invalidpassword")

        // Tap Sign In button
        app.buttons["Sign In"].tap()

        // Assert that error alert is displayed
        XCTAssertTrue(app.alerts["Account Not Found"].exists)
    }
}
