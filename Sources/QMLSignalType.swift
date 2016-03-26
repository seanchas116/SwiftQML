public protocol Disposable {
    func dispose()
}

public protocol QMLSignalType {
    func qml_subscribe(listener: () -> Void) -> Disposable
}
