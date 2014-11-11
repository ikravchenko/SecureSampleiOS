public protocol EntryDelegate : class {
    func onEntryAdded(newEntry: String)
    func onEntryAdditionCancelled()
}