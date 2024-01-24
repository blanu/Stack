//
//  ArithmeticStack.swift
//
//
//  Created by Dr. Brandon Wiley on 1/22/24.
//

import Foundation

postfix operator +
postfix operator -

public final class AdditiveArithmeticStack<Element>: Stack where Element: AdditiveArithmetic
{
    public typealias Element = Element

    let stack: AnyStack<Element>

    public init()
    {
        self.stack = AnyStack<Element>()
    }

    public init(_ stack: AnyStack<Element>)
    {
        self.stack = stack
    }
}

extension AdditiveArithmeticStack
{
    public func pop() throws -> (Element, AdditiveArithmeticStack<Element>)
    {
        let (result, stack2) = try self.stack.pop()
        let typedStack = AdditiveArithmeticStack(stack2)

        return (result, typedStack)
    }

    public func push(_ element: Element) throws -> Self
    {
        return Self(try self.stack.push(element))
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

extension AdditiveArithmeticStack
{
    static func math(_ stack: AdditiveArithmeticStack<Element>, _ op: (Element, Element) -> Element) throws -> AdditiveArithmeticStack<Element>
    {
        let (x, stack2) = try stack.pop()
        let (y, stack3) = try stack2.pop()
        let z = op(x, y)

        let stack4 = try stack3.push(z)
        return AdditiveArithmeticStack<Element>(stack4.stack)
    }

    static public postfix func +(_ stack: AdditiveArithmeticStack<Element>) throws -> AdditiveArithmeticStack<Element>
    {
        return try Self.math(stack, (+))
    }

    static public postfix func -(_ stack: AdditiveArithmeticStack<Element>) throws -> AdditiveArithmeticStack<Element>
    {
        return try Self.math(stack, (-))
    }
}
