import CQMLBind

private func unused<T>(value: T) {
}

class Factory {
    let create: (SignalEmitter) -> AnyObject

    init(create: (SignalEmitter) -> AnyObject) {
        self.create = create
    }
}

private func toObjectUnretained(handle: UnsafeMutablePointer<qmlbind_client_object>) -> AnyObject {
    return Unmanaged.fromOpaque(OpaquePointer(handle)).takeUnretainedValue()
}

private func toObjectRetained(handle: UnsafeMutablePointer<qmlbind_client_object>) -> AnyObject {
    return Unmanaged.fromOpaque(OpaquePointer(handle)).takeRetainedValue()
}

private func newObject(
    classRef: UnsafeMutablePointer<qmlbind_client_class>,
    signalEmitter: UnsafeMutablePointer<qmlbind_signal_emitter>
) -> UnsafeMutablePointer<qmlbind_client_object> {
    let factory = Unmanaged<Factory>.fromOpaque(OpaquePointer(classRef)).takeRetainedValue()
    let obj = factory.create(SignalEmitter(signalEmitter))
    return UnsafeMutablePointer(OpaquePointer(bitPattern: Unmanaged.passRetained(obj)))
}

private func deleteObject(handle: UnsafeMutablePointer<qmlbind_client_object>) {
    unused(toObjectUnretained(handle))
}

private func callMethod(
    engine: UnsafeMutablePointer<qmlbind_engine>,
    handle: UnsafeMutablePointer<qmlbind_client_object>,
    namePtr: UnsafePointer<Int8>,
    argc: Int32,
    argv: UnsafePointer<UnsafePointer<qmlbind_value>>
) -> UnsafeMutablePointer<qmlbind_value> {
    let name = String(namePtr)
    let obj = toObjectRetained(handle)
    let mirror = Mirror(reflecting: obj)
    let method = mirror.descendant(name)
    if let method = method as? (([JSValue]) -> JSValue) {
        let args = (0 ..< argc).map { JSValue(qmlbind_value_clone(argv[Int($0)])) }
        let ret = method(args)
        return qmlbind_value_clone(ret.pointer)
    } else {
        print("no such method found: \(name)")
        return qmlbind_value_new_undefined()
    }
}

private func getProperty(
    enginePtr: UnsafeMutablePointer<qmlbind_engine>,
    handle: UnsafeMutablePointer<qmlbind_client_object>,
    namePtr: UnsafePointer<Int8>
) -> UnsafeMutablePointer<qmlbind_value> {
    let engine = Engine.instances[enginePtr]!.engine!
    let name = String(namePtr)
    let obj = toObjectRetained(handle)
    let mirror = Mirror(reflecting: obj)
    let prop = mirror.descendant(name)
    if let prop = prop as? QMLPropertyType {
        let value = prop.getJSValue(engine)
        return qmlbind_value_clone(value.pointer)
    } else {
        print("no such property found: \(name)")
        return qmlbind_value_new_undefined()
    }
}

private func setProperty(
    engine: UnsafeMutablePointer<qmlbind_engine>,
    handle: UnsafeMutablePointer<qmlbind_client_object>,
    namePtr: UnsafePointer<Int8>,
    value: UnsafePointer<qmlbind_value>
) {
    let name = String(namePtr)
    let obj = toObjectRetained(handle)
    let mirror = Mirror(reflecting: obj)
    let prop = mirror.descendant(name)
    if var prop = prop as? QMLPropertyType {
        prop.setJSValue(JSValue(qmlbind_value_clone(value)))
    } else {
        print("no such property found: \(name)")
    }
}

class MetaClass {
    let name: String
    let pointer: UnsafeMutablePointer<qmlbind_metaclass>

    init(name: String, create: (SignalEmitter) -> AnyObject) {
        self.name = name

        var callbacks = qmlbind_client_callbacks()
        callbacks.new_object = newObject
        callbacks.delete_object = deleteObject
        callbacks.call_method = callMethod
        callbacks.get_property = getProperty
        callbacks.set_property = setProperty

        let factory = Factory(create: create)
        let factoryPtr = UnsafeMutablePointer<qmlbind_client_class>(OpaquePointer(bitPattern: Unmanaged.passRetained(factory)))

        pointer = qmlbind_metaclass_new(factoryPtr, name, callbacks)
    }

    func addMethod(name: String, arity: Int) {
        qmlbind_metaclass_add_method(pointer, name, Int32(arity))
    }

    func addSignal(name: String, params: [String]) {
        let array = CStringArray(params)
        qmlbind_metaclass_add_signal(pointer, name, Int32(array.length), UnsafeMutablePointer(array.pointers))
    }

    func addProperty(name: String, notifySignal: String) {
        qmlbind_metaclass_add_property(pointer, name, notifySignal)
    }

    func register(uri: String, versionMajor: Int, versionMinor: Int, qmlName: String) {
        qmlbind_metaclass_register(pointer, uri, Int32(versionMajor), Int32(versionMinor), qmlName)
    }
}
