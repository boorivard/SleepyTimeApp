//
//  SleepyTimeAppTests.swift
//  SleepyTimeAppTests
//
//  Created by Jared Rivard on 2/18/24.
//

import XCTest
@testable import Unit_testing

final class Unit_testingTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    class AlarmTests: XCTestCase {
        
        // Test setting alarm
        func testSetAlarm() {
            let alarm = Alarm()
            let alarmTime = Date()
            
            alarm.setAlarm(at: alarmTime)
            
            // You can check if the alarm is properly set by checking if it exists in the list of alarms or by accessing the notification center to see if the alarm notification is scheduled.
            XCTAssertTrue(alarm.isAlarmSet)
        }
        
        // Test triggering alarm
        func testTriggerAlarm() {
            let alarm = Alarm()
            let alarmTime = Date()
            
            alarm.setAlarm(at: alarmTime)
            alarm.triggerAlarm()
            
            // You need to assert that the alarm is triggered.
            XCTAssertTrue(alarm.isAlarmTriggered)
        }
        
        // Test playing sound
        func testPlaySound() {
            let alarm = Alarm()
            let expectation = XCTestExpectation(description: "Sound played")
            
            alarm.playSound {
                // Here you can perform any assertions related to sound playing.
                expectation.fulfill()
            }
            
            // Wait for the expectation to be fulfilled, timeout if it doesn't happen.
            wait(for: [expectation], timeout: 5)
        }
    }
    func testAlarmNotSetInitially() {
        let alarm = Alarm()
        XCTAssertFalse(alarm.isAlarmSet)
    }

    func testAlarmNotTriggeredInitially() {
        let alarm = Alarm()
        XCTAssertFalse(alarm.isAlarmTriggered)
    }

    func testSetMultipleAlarms() {
        let alarm = Alarm()
        let alarmTime1 = Date()
        let alarmTime2 = Date().addingTimeInterval(3600) // 1 hour later

        alarm.setAlarm(at: alarmTime1)
        alarm.setAlarm(at: alarmTime2)

        // You can check if both alarms are properly set
        XCTAssertTrue(alarm.isAlarmSet)
    }

    func testTriggerAlarmBeforeSetting() {
        let alarm = Alarm()
        alarm.triggerAlarm()

        // Alarm should not be triggered if it's not set
        XCTAssertFalse(alarm.isAlarmTriggered)
    }

    func testPlaySound() {
        let alarm = Alarm()
        let expectation = XCTestExpectation(description: "Sound played")

        alarm.playSound {
            // Here you can perform any assertions related to sound playing.
            expectation.fulfill()
        }

        // Wait for the expectation to be fulfilled, timeout if it doesn't happen.
        wait(for: [expectation], timeout: 5)
    }
    func testRemoveAlarm() {
        let alarm = Alarm()
        let alarmTime = Date()
        
        alarm.setAlarm(at: alarmTime)
        alarm.removeAlarm()
        
        // After removing the alarm, it should not be set anymore
        XCTAssertFalse(alarm.isAlarmSet)
    }

    func testTriggerAlarmMultipleTimes() {
        let alarm = Alarm()
        let alarmTime = Date()
        
        alarm.setAlarm(at: alarmTime)
        alarm.triggerAlarm()
        alarm.triggerAlarm() // Try to trigger the alarm again
        
        // Alarm should still be triggered only once
        XCTAssertTrue(alarm.isAlarmTriggered)
    }

    func testPlaySoundFailure() {
        let alarm = Alarm()
        let expectation = XCTestExpectation(description: "Sound played")
        
        // Assuming here that the playSound method fails to play the sound due to some reason
        alarm.playSound {
            // Here you can perform any assertions related to sound playing.
            expectation.fulfill()
        }
        
        // Wait for the expectation to be fulfilled, timeout if it doesn't happen.
        wait(for: [expectation], timeout: 5)
    }

    func testRemoveNonExistingAlarm() {
        let alarm = Alarm()
        
        // Attempt to remove an alarm that doesn't exist
        alarm.removeAlarm()
        
        // Removing non-existing alarm should not result in any change
        XCTAssertFalse(alarm.isAlarmSet)
    }

    func testTriggerAlarmWithoutSetting() {
        let alarm = Alarm()
        
        alarm.triggerAlarm()
        
        // Triggering alarm without setting it should have no effect
        XCTAssertFalse(alarm.isAlarmTriggered)
    }

    
}
