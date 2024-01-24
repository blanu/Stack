import XCTest
@testable import Stack

final class StackTests: XCTestCase
{
    func testIf() throws
    {
        var stack = BinaryIntegerStack<Int>()

        stack = try stack.push(1)
        stack = try stack.push(1)
        stack = try stack==
        stack = try stack.`if` { try $0.push(15) }

        print(stack.stack.stack.stack.array)
    }

    func testIfElse() throws
    {
        var stack = BinaryIntegerStack<Int>()

        stack = try stack.push(1)
        stack = try stack.push(2)
        stack = try stack==
        stack = try stack.`if` { try $0.push(15) } else: { try $0.push(20) }

        print(stack.stack.stack.stack.array)
    }
}
