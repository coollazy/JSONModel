import XCTest

import MD5Tests

var tests = [XCTestCaseEntry]()
tests += MD5Tests.allTests()
XCTMain(tests)
