//
//  MutableStack.swift
//
//
//  Created by Dr. Brandon Wiley on 1/22/24.
//

import Foundation

public class MutableStack<Element>
{
    var stack: AnyStack<Element>

    public init()
    {
        self.stack = AnyStack<Element>()
    }

    public init(_ stack: AnyStack<Element>)
    {
        self.stack = stack
    }

    public func become(stack: AnyStack<Element>)
    {
        self.stack = stack
    }

    public func become(transform: (AnyStack<Element>) -> AnyStack<Element>)
    {
        self.stack = transform(self.stack)
    }
}
