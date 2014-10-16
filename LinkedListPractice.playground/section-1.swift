// Playground - noun: a place where people can play

import UIKit

class Node <T> {
	var value: T?
	var next: Node?
}

class LinkedList <T> {
	var head : Node <T>?
	
	func insert(value: T) {
		
		var currentNode = Node<T>()
		currentNode.value = value
		
		if self.head? == nil {
			self.head = currentNode
		} else {
			while currentNode.next != nil {
				currentNode = currentNode.next!
			}
			var node = Node<T>()
			node.value = value
			node.next = nil
		}
	}
	
	func removeNode() {
		if self.head != nil {
			var currentNode = self.head
			while currentNode?.next != nil {
				currentNode = currentNode?.next
			}
			currentNode?.value = nil
		}
	}
}

