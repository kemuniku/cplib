import lists
proc insertPrev*[T](L: var DoublyLinkedList[T], a,b: DoublyLinkedNode[T])=
    if L.head == a:
        L.head = b
        a.prev = b
        b.next = a
    else:
        a.prev.next = b
        b.prev = a.prev
        a.prev = b
        b.next = a

proc insert*[T](L: var DoublyLinkedList[T], a,b: DoublyLinkedNode[T])=
    if L.tail == a:
        L.tail = b
        a.next = b
        b.prev = a
    else:
        a.next.prev = b
        b.next = a.next
        a.next = b
        b.prev = a