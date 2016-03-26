import CQMLBind

public class Component {
    let pointer: qmlbind_component

    public init(engine: Engine) {
        pointer = qmlbind_component_new(engine.pointer)
    }

    deinit {
        qmlbind_component_release(pointer)
    }

    public func loadPath(path: String) throws {
        qmlbind_component_load_path(pointer, path)
        if let error = errorString {
            throw QMLError.ComponentError(error)
        }
    }

    public func setData(data: String, path: String) throws {
        qmlbind_component_set_data(pointer, data, path)
        if let error = errorString {
            throw QMLError.ComponentError(error)
        }
    }

    public func create() throws -> JSValue {
        return JSValue(qmlbind_component_create(pointer))
        if let error = errorString {
            throw QMLError.ComponentError(error)
        }
    }

    private var errorString: String? {
        return String.fromQMLString(qmlbind_component_get_error_string(pointer))
    }
}
