//
//  NumericStack.swift
//
//
//  Created by Dr. Brandon Wiley on 1/22/24.
//

import Foundation

postfix operator *

public final class NumericStack<Element>: Stack where Element: Numeric
{
    public typealias Element = Element

    static func math(_ stack: NumericStack<Element>, _ op: (Element, Element) -> Element) throws -> NumericStack<Element>
    {
        let (x, stack2) = try stack.pop()
        let (y, stack3) = try stack2.pop()
        let z = op(x, y)

        let stack4 = try stack3.push(z)
        return NumericStack<Element>(stack4.stack)
    }

    static public postfix func *(_ stack: NumericStack<Element>) throws -> NumericStack<Element>
    {
        return try math(stack, (*))
    }

    static public postfix func +(_ stack: NumericStack<Element>) throws -> NumericStack<Element>
    {
        return try Self.math(stack, (+))
    }

    static public postfix func -(_ stack: NumericStack<Element>) throws -> NumericStack<Element>
    {
        return try Self.math(stack, (-))
    }

    public var stack: AdditiveArithmeticStack<Element>

    public init()
    {
        self.stack = AdditiveArithmeticStack<Element>()
    }

    public required init(_ stack: AdditiveArithmeticStack<Element>)
    {
        self.stack = stack
    }

    public func push(_ element: Element) throws -> Self
    {
        return Self(try self.stack.push(element))
    }

    public func pop() throws -> (Element, NumericStack<Element>)
    {
        let (result, stack2) = try self.stack.pop()
        let typedStack = Self(stack2)

        return (result, typedStack)
    }

    public func dup() throws -> Self
    {
        return Self(try self.stack.dup())
    }

    public func swap() throws -> Self
    {
        return Self(try self.stack.swap())
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
