//
//  MinHeap.swift
//  advent_of_code_2023
//
//  Created by Kushantha Attanayake on 12/16/23.
//

import Foundation

/// Copied from https://medium.com/devslopes-blog/swift-data-structures-heap-e3fbbdaa3129
struct Heap<T> {
    /// Function that returns true if first param has higher priority than second
    // a > b is max heap, a < b is min heap
    var comparator: (T, T) -> Bool
    private var items: [T] = [T]()
    
    init(comparator: @escaping (T, T) -> Bool) {
        self.comparator = comparator
    }
    
    //Get Index
    private func getLeftChildIndex(_ parentIndex: Int) -> Int {
        return 2 * parentIndex + 1
    }
    private func getRightChildIndex(_ parentIndex: Int) -> Int {
        return 2 * parentIndex + 2
    }
    private func getParentIndex(_ childIndex: Int) -> Int {
        return (childIndex - 1) / 2
    }
    
    // Boolean Check
    private func hasLeftChild(_ index: Int) -> Bool {
        return getLeftChildIndex(index) < items.count
    }
    private func hasRightChild(_ index: Int) -> Bool {
        return getRightChildIndex(index) < items.count
    }
    private func hasParent(_ index: Int) -> Bool {
        return getParentIndex(index) >= 0
    }
    
    // Return Item From Heap
    private func leftChild(_ index: Int) -> T {
        return items[getLeftChildIndex(index)]
    }
    private func rightChild(_ index: Int) -> T {
        return items[getRightChildIndex(index)]
    }
    private func parent(_ index: Int) -> T {
        return items[getParentIndex(index)]
    }
    
    public func peek() -> T {
      if items.count != 0 {
          return items[0]
      } else {
          fatalError()
      }
    }
    
    mutating public func poll() -> T {
      if items.count != 0 {
          let item = items[0]
          items[0] = items[items.count - 1]
          heapifyDown()
          items.removeLast()
          return item
      } else {
          fatalError()
      }
    }
    
    mutating public func add(_ item: T) {
      items.append(item)
      heapifyUp()
    }
    
    mutating func addAll( _ items: [T]){
        items.forEach { add($0) }
    }
    
    mutating private func swap(indexOne: Int, indexTwo: Int) {
      let placeholder = items[indexOne]
      items[indexOne] = items[indexTwo]
      items[indexTwo] = placeholder
    }
    
    mutating private func heapifyUp() {
      var index = items.count - 1
      while hasParent(index) && comparator(items[index], parent(index)) {
          swap(indexOne: getParentIndex(index), indexTwo: index)
          index = getParentIndex(index)
      }
    }
    
    mutating private func heapifyDown() {
      var index = 0
      while hasLeftChild(index) {
          var smallerChildIndex = getLeftChildIndex(index)
          if hasRightChild(index) && !comparator(leftChild(index), rightChild(index)) {
              smallerChildIndex = getRightChildIndex(index)
          }

          if !comparator(items[smallerChildIndex], items[index]){
              break
          } else {
              swap(indexOne: index, indexTwo: smallerChildIndex)
          }
          index = smallerChildIndex
      }
    }
    
    public func isEmpty() -> Bool {
        items.isEmpty
    }
    
    public func count() -> Int {
        items.count
    }
}
