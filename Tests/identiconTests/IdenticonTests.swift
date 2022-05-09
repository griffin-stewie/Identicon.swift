import Foundation
import XCTest
@testable import Identicon

final class IdenticonTests: XCTestCase {
    func testBinaryBlocks() throws {
        let output = IdenticonMaker.binaryBlocks(input: "29699789")
        let expects = [
            [false, true, true, true, false],
            [true, false, false, false, true],
            [false, false, true, false, false],
            [false, true, false, true, false],
            [false, true, false, true, false],
        ]
        XCTAssertEqual(output, expects)
    }

    func testASCIITransformer() throws {
        let transformer = ASCIITransformer()
        let output = IdenticonMaker.generate(input: "29699789", transformer: transformer)
        let expects = """
                    01110
                    10001
                    00100
                    01010
                    01010
                    """

        XCTAssertEqual(output, expects)
    }

    func testASCIITransformer2() throws {
        let transformer = ASCIITransformer()
        let output = IdenticonMaker.generate(input: "19229051", transformer: transformer)
        let expects = """
                    01010
                    00000
                    01110
                    00000
                    10001
                    """
        XCTAssertEqual(output, expects)
    }

    func testColor() throws {
        let output = IdenticonMaker.color(from: "19229051")
        XCTAssertTrue(check(a: output.redComponent, b: 0.7215686274509804))
        XCTAssertTrue(check(a: output.greenComponent, b: 0.4352941176470588))
        XCTAssertTrue(check(a: output.blueComponent, b: 0.8))
    }
}

func check(a: Double, b: Double) -> Bool {
    let eps: Double = 1e-9
    let v = round(a * 10) / 10 - round(b * 10) / 10
    return abs(v) < eps
}
