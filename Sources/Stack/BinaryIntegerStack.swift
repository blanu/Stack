//
//  BinaryIntegerStack.swift
//
//
//  Created by Dr. Brandon Wiley on 1/22/24.
//

import Foundation

postfix operator ÷
postfix operator %
postfix operator ÷%
postfix operator <
postfix operator <=
postfix operator ==
postfix operator +
postfix operator -
postfix operator &&
postfix operator ||
postfix operator ‥
postfix operator ⤒
postfix operator ⇄
postfix operator *÷
postfix operator *÷%
postfix operator <<
postfix operator >>

infix operator ⤓

public final class BinaryIntegerStack<Element>: Stack where Element: BinaryInteger
{
    public typealias Element = Element

    let stack: NumericStack<Element>

    public init()
    {
        self.stack = NumericStack<Element>()
    }

    public init(_ stack: NumericStack<Element>)
    {
        self.stack = stack
    }
}

// Stack operations
extension BinaryIntegerStack
{
    public func pop() throws -> (Element, BinaryIntegerStack<Element>)
    {
        let (result, stack2) = try self.stack.pop()
        let typedStack = BinaryIntegerStack(stack2)

        return (result, typedStack)
    }

    static public postfix func ⤒(_ stack: BinaryIntegerStack) throws -> (Element, BinaryIntegerStack)
    {
        return try stack.pop()
    }

    public func push(_ element: Element) throws -> Self
    {
        return Self(try self.stack.push(element))
    }

    static public func ⤓(_ stack: BinaryIntegerStack, _ element: Element) throws -> BinaryIntegerStack
    {
        return try stack.push(element)
    }

    public func dup() throws -> Self
    {
        return Self(try self.stack.dup())
    }

    static public postfix func ‥(_ stack: BinaryIntegerStack) throws -> BinaryIntegerStack
    {
        return try stack.dup()
    }

    public func swap() throws -> Self
    {
        return Self(try self.stack.swap())
    }

    static public postfix func ⇄(_ stack: BinaryIntegerStack) throws -> BinaryIntegerStack
    {
        return try stack.swap()
    }

    public func over() throws -> Self
    {
        return Self(try self.stack.over())
    }

    public func rot() throws -> Self
    {
        return Self(try self.stack.rot())
    }

    public func drop() throws -> Self
    {
        return Self(try self.stack.drop())
    }

    public func tuck() throws -> Self
    {
        return Self(try self.stack.tuck())
    }
}

// Math helper utilities
extension BinaryIntegerStack
{
    func monad(_ op: (Element) -> Element) throws -> BinaryIntegerStack<Element>
    {
        let (x, stack2) = try self.pop()
        let z = op(x)

        let stack3 = try stack2.push(z)
        return BinaryIntegerStack<Element>(stack3.stack)
    }

    func dyad(_ op: (Element, Element) -> Element) throws -> BinaryIntegerStack<Element>
    {
        let (x, stack2) = try self.pop()

        return try stack2.monad { op($0, x) }
    }

    func triad(_ op: (Element, Element, Element) -> Element) throws -> BinaryIntegerStack<Element>
    {
        let (x, stack2) = try self.pop()

        return try stack2.dyad { op($0, $1, x) }
    }
}

// AdditiveArithmetic operations
extension BinaryIntegerStack
{
    static public postfix func +(_ stack: BinaryIntegerStack<Element>) throws -> BinaryIntegerStack<Element>
    {
        return try stack.dyad(+)
    }

    static public postfix func -(_ stack: BinaryIntegerStack<Element>) throws -> BinaryIntegerStack<Element>
    {
        return try stack.dyad(-)
    }
}

// Numeric operations
extension BinaryIntegerStack
{
    static public postfix func *(_ stack: BinaryIntegerStack<Element>) throws -> BinaryIntegerStack<Element>
    {
        return try stack.dyad(*)
    }
}

// BinaryIntegerStack monadic operations
extension BinaryIntegerStack
{
    static public postfix func <<(_ stack: BinaryIntegerStack<Element>) throws -> BinaryIntegerStack<Element>
    {
        return try stack.monad { $0 << 1 }
    }

    static public postfix func >>(_ stack: BinaryIntegerStack<Element>) throws -> BinaryIntegerStack<Element>
    {
        return try stack.monad { $0 >> 1 }
    }
}

// BinaryIntegerStack dyadic operations
extension BinaryIntegerStack
{
    static public postfix func ÷(_ stack: BinaryIntegerStack<Element>) throws -> BinaryIntegerStack<Element>
    {
        return try stack.dyad(/)
    }

    static public postfix func %(_ stack: BinaryIntegerStack<Element>) throws -> BinaryIntegerStack<Element>
    {
        return try stack.dyad(%)
    }

    static public postfix func ÷%(_ stack: BinaryIntegerStack<Element>) throws -> BinaryIntegerStack<Element>
    {
        let (x, stack2) = try stack.pop()
        let (y, stack3) = try stack2.pop()

        let (a, b) = x.quotientAndRemainder(dividingBy: y)
        let stack4 = try stack3.push(b)
        let stack5 = try stack4.push(a)

        return BinaryIntegerStack<Element>(stack5.stack)
    }

    public func min(_ stack: BinaryIntegerStack<Element>) throws -> BinaryIntegerStack<Element>
    {
        return try stack.dyad { Swift.min($0, $1) }
    }

    public func max(_ stack: BinaryIntegerStack<Element>) throws -> BinaryIntegerStack<Element>
    {
        return try stack.dyad { Swift.max($0, $1) }
    }
}

// BinaryIntegerStack triadic operations
extension BinaryIntegerStack
{
    // FIXME - this needs to be implemented for each integer type separately because it uses a double precission integer for the result of the multiplication.
    static public postfix func *÷(_ stack: BinaryIntegerStack<Element>) throws -> BinaryIntegerStack<Element>
    {
        return try stack.triad { ($0 * $1) / $2 }
    }

    // This one, too.
    static public postfix func *÷%(_ stack: BinaryIntegerStack<Element>) throws -> BinaryIntegerStack<Element>
    {
        let (x, stack2) = try stack.pop()
        let (y, stack3) = try stack2.pop()
        let (z, stack4) = try stack3.pop()

        let a = x * y

        let (b, c) = a.quotientAndRemainder(dividingBy: z)
        let stack5 = try stack4.push(c)
        let stack6 = try stack5.push(b)

        return BinaryIntegerStack<Element>(stack6.stack)    }
}

extension BinaryIntegerStack
{
    public func cond(_ op: (Element, Element) -> Bool) throws -> BinaryIntegerStack<Element>
    {
        let (x, stack2) = try self.pop()
        let (y, stack3) = try stack2.pop()
        let z: Element = op(x, y) ? 1 : 0

        let stack4 = try stack3.push(z)
        return BinaryIntegerStack<Element>(stack4.stack)
    }

    static public postfix func <(_ stack: BinaryIntegerStack<Element>) throws -> BinaryIntegerStack<Element>
    {
        return try stack.cond(<)
    }

    static public postfix func <=(_ stack: BinaryIntegerStack<Element>) throws -> BinaryIntegerStack<Element>
    {
        return try stack.cond(<=)
    }

    static public postfix func ==(_ stack: BinaryIntegerStack<Element>) throws -> BinaryIntegerStack<Element>
    {
        return try stack.cond(==)
    }

    static public postfix func &&(_ stack: BinaryIntegerStack<Element>) throws -> BinaryIntegerStack<Element>
    {
        let (x, stack2) = try stack.pop()
        let (y, stack3) = try stack2.pop()

        let a = x != 0
        let b = y != 0

        let z: Element = a && b ? 1 : 0

        let stack4 = try stack3.push(z)
        return BinaryIntegerStack<Element>(stack4.stack)
    }

    static public postfix func ||(_ stack: BinaryIntegerStack<Element>) throws -> BinaryIntegerStack<Element>
    {
        let (x, stack2) = try stack.pop()
        let (y, stack3) = try stack2.pop()

        let a = x != 0
        let b = y != 0

        let z: Element = a || b ? 1 : 0

        let stack4 = try stack3.push(z)
        return BinaryIntegerStack<Element>(stack4.stack)
    }
}

extension BinaryIntegerStack
{
    public func `if`(then: (BinaryIntegerStack) throws -> BinaryIntegerStack, else: ((BinaryIntegerStack) throws -> BinaryIntegerStack)? = nil) throws -> BinaryIntegerStack
    {
        let (x, stack2) = try self.pop()
        if x == 1
        {
            return try then(stack2)
        }
        else
        {
            if let elseClause = `else`
            {
                return try elseClause(stack2)
            }
            else
            {
                return stack2
            }
        }
    }

    public func not() throws -> BinaryIntegerStack
    {
        let (x, stack2) = try self.pop()
        if x == 0
        {
            return try stack2.push(1)
        }
        else
        {
            return try stack2.push(0)
        }
    }

    public func loop(_ body: (BinaryIntegerStack) throws -> BinaryIntegerStack) throws -> BinaryIntegerStack
    {
        let (x, stack2) = try self.pop()
        let (y, stack3) = try stack2.pop()

        guard y < x else
        {
            return self
        }

        var working = stack3
        var index = y

        while index < x
        {
            working = try body(working)
            index += 1
        }

        return BinaryIntegerStack<Element>(working.stack)
    }

    public func loop(plus: Element, _ body: (BinaryIntegerStack) throws -> BinaryIntegerStack) throws -> BinaryIntegerStack
    {
        let (x, stack2) = try self.pop()
        let (y, stack3) = try stack2.pop()

        guard y < x else
        {
            return self
        }

        var working = stack3
        var index = y

        while index < x
        {
            working = try body(working)
            index += plus
        }

        return BinaryIntegerStack<Element>(working.stack)
    }
}
