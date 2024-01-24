//
//  AnyStack.swift
//
//
//  Created by Dr. Brandon Wiley on 1/22/24.
//

import Foundation

postfix operator ◌

public final class AnyStack<Element>: Stack
{
    public typealias Element = Element

    public let array: [Element]

    public init()
    {
        self.array = []
    }

    public init(_ array: [Element])
    {
        self.array = array
    }
}

extension AnyStack
{
    public func push(_ element: Element) throws -> AnyStack
    {
        return AnyStack(self.array + [element])
    }

    public func pop() throws -> (Element, AnyStack)
    {
        var newArray = self.array

        guard let result = newArray.popLast() else
        {
            throw StackError.underflow
        }

        return (result, AnyStack(newArray))
    }

    static public postfix func ◌(_ stack: AnyStack<Element>) throws -> (Element, AnyStack<Element>)
    {
        return try stack.pop()
    }

    public func dup() throws -> AnyStack
    {
        guard let element = self.array.last else
        {
            throw StackError.underflow
        }

        var newArray = self.array
        newArray.append(element)

        return AnyStack(newArray)
    }

    public func swap() throws -> AnyStack
    {
        guard self.array.count >= 2 else
        {
            throw StackError.underflow
        }

        var newArray = self.array
        let temp = newArray[newArray.count - 1]
        newArray[newArray.count - 1] = newArray[newArray.count - 2]
        newArray[newArray.count - 2] = temp

        return AnyStack(newArray)
    }

    public func over() throws -> AnyStack
    {
        guard self.array.count >= 2 else
        {
            throw StackError.underflow
        }

        return AnyStack(self.array + [self.array[self.array.count - 2]])
    }

    public func rot() throws -> AnyStack
    {
        guard self.array.count >= 3 else
        {
            throw StackError.underflow
        }

        let temp = self.array[self.array.count - 3]
        var newArray = self.array

        newArray.remove(at: self.array.count - 3)
        newArray.append(temp)

        return AnyStack(newArray)
    }

    public func drop() throws -> AnyStack
    {
        guard self.array.count > 0 else
        {
            throw StackError.underflow
        }

        var newArray = self.array
        let _ = newArray.popLast()
        return AnyStack(newArray)
    }

    public func tuck() throws -> AnyStack
    {
        guard self.array.count >= 2 else
        {
            throw StackError.underflow
        }

        return AnyStack(self.array + [self.array[self.array.count - 2]])
    }
}

public enum StackError: Error
{
    case underflow
}
