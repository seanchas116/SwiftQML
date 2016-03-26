import CQMLBind

public class Engine {
    let pointer: qmlbind_engine

    public init() {
        pointer = qmlbind_engine_new()
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
    }
}
