//
//  Fucntional.swift
//  GlovoChallenge
//
//  Created by Ibrahim Kteish on 7/23/18.
//  Copyright © 2018 Ibrahim Kteish. All rights reserved.
//

import Foundation
//Keypath setter
func prop<Root, Value>(_ kp: WritableKeyPath<Root, Value>)
  -> (@escaping (Value) -> Value)
  -> (Root)
  -> Root {
    
    return { update in
      { root in
        var copy = root
        copy[keyPath: kp] = update(copy[keyPath: kp])
        return copy
      }
    }
}
/// prop's overload so we can write it with trailing closure
/// In another world Applying a transformation without extra parentheses
func prop<Root, Value>(
  _ kp: WritableKeyPath<Root, Value>,
  _ f: @escaping (Value) -> Value
  )
  -> (Root) -> Root {
    
    return prop(kp)(f)
}

/// prop's overload that gets rid of " _ in " in case of setting
/// a new value without transforming it
func prop<Root, Value>(
  _ kp: WritableKeyPath<Root, Value>,
  _ value: Value
  )
  -> (Root) -> Root {
    
    return prop(kp) { _ in value }
}

typealias Setter<S, T, A, B> = (@escaping (A) -> B) -> (S) -> T

func over<S, T, A, B>(
  _ setter: Setter<S, T, A, B>,
  _ set: @escaping (A) -> B
  )
  -> (S) -> T {
    return setter(set)
}

func set<S, T, A, B>(
  _ setter: Setter<S, T, A, B>,
  _ value: B
  )
  -> (S) -> T {
    return over(setter) { _ in value }
}

//Keypath getter
func get<Root, Value>(_ kp: KeyPath<Root, Value>) -> (Root) -> Value {
  return { root in
    root[keyPath: kp] }
}

//Since it is prefix we don’t have to worry about precedence or associativity!
prefix operator ^
//usage ^\User.id
//or users.map(^\.id)
prefix func ^ <Root, Value>(kp: KeyPath<Root, Value>) -> (Root) -> Value {
  return get(kp)
}
prefix func ^ <Root, Value>(kp: WritableKeyPath<Root, Value>)
  -> (@escaping (Value) -> Value)
  -> (Root) -> Root {
    
    return prop(kp)
}

/// This Generic struct is a wrapper for its map method since we cannot use map outside this struct
/// due to swift limitation on infering the generic param
/// i.e: map(1) //Swift cannot infer A in this case
struct Genereic<A> {
  public static func map<A>(_ index: Int)
    -> (@escaping (A) -> A)
    -> ([A]) -> [A] {
      return { f in
        return { array in
          array.enumerated().map({ (idx, element) -> A in
            if index == idx { return f(element) } else { return element }
          })
        }
      }
  }
}


/////Operators

//defining a “pipe-forward” operator.
//left associativity to ensure that the lefthand expression evaluates first.
precedencegroup ForwardApplication {
  associativity: left
}
//conforms to the precedence group.
infix operator |>: ForwardApplication
//Generic over two types: A and B.
//The lefthand side is the value, of type A,
//while the righthand side is a function from A to B.
//finally return B by applying the value to the function.
public func |> <A,B>(value: A, fnc: (A) -> B) -> B {
  return fnc(value)
}

