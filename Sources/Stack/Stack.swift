//
//  Stack.swift
//
//
//  Created by Dr. Brandon Wiley on 1/22/24.
//

import Foundation

public protocol Stack
{
    associatedtype Element

    func push(_ element: Element) throws -> Self
    func pop() throws -> (Element, Self)
    func dup() throws -> Self
    func swap() throws -> Self
    func over() throws -> Self
    func rot() throws -> Self
    func drop() throws -> Self
    func tuck() throws -> Self
}
