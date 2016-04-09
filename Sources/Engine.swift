import CQMLBind

struct WeakEngine {
    weak var engine: Engine?
}

public class Engine {
    let pointer: UnsafeMutablePointer<qmlbind_engine>
    static var instances = Dictionary<UnsafeMutablePointer<qmlbind_engine>, WeakEngine>()

    public init() {
        pointer = qmlbind_engine_new()
        Engine.instances[pointer] = WeakEngine(engine: self)
    }

    public var globalObject: JSValue {
        return JSValue(qmlbind_engine_get_global_object(pointer))
    }

    public func newObject() -> JSValue {
        return JSValue(qmlbind_engine_new_object(pointer))
    }

    public func newArray(count: Int) -> JSValue {
        return JSValue(qmlbind_engine_new_array(pointer, Int32(count)))
    }

    public func addImportPath(path: String) {
        qmlbind_engine_add_import_path(pointer, path)
    }

    public func collectGarbage() {
        qmlbind_engine_collect_garbage(pointer)
    }

    deinit {
        qmlbind_engine_release(pointer)
        Engine.instances.removeValue(forKey: pointer)
    }
}
