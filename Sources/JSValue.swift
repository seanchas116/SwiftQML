import CQMLBind

public class JSValue {
    let pointer: qmlbind_value

    init(_ pointer: qmlbind_value) {
        self.pointer = pointer
    }

    deinit {
        qmlbind_value_release(pointer)
    }

    public var isUndefined: Bool {
        return qmlbind_value_is_undefined(pointer) != 0
    }

    public var isNull: Bool {
        return qmlbind_value_is_null(pointer) != 0
    }

    public var isBoolean: Bool {
        return qmlbind_value_is_boolean(pointer) != 0
    }

    public var isNumber: Bool {
        return qmlbind_value_is_number(pointer) != 0
    }

    public var isString: Bool {
        return qmlbind_value_is_string(pointer) != 0
    }

    public var isObject: Bool {
        return qmlbind_value_is_object(pointer) != 0
    }

    public var isArray: Bool {
        return qmlbind_value_is_array(pointer) != 0
    }

    public var isFunction: Bool {
        return qmlbind_value_is_function(pointer) != 0
    }

    public var isError: Bool {
        return qmlbind_value_is_error(pointer) != 0
    }

    public var isWrapper: Bool {
        return qmlbind_value_is_wrapper(pointer) != 0
    }

    // Boolean

    public init(_ boolean: Bool) {
        self.pointer = qmlbind_value_new_boolean(boolean ? 0 : 1)
    }

    public func toBool() -> Bool {
        return qmlbind_value_get_boolean(pointer) != 0
    }

    // number

    public init(_ number: Double) {
        self.pointer = qmlbind_value_new_number(Double(number))
    }

    public func toNumber() -> Double {
        return qmlbind_value_get_number(pointer)
    }

    // string

    public init(_ string: String) {
        self.pointer = string.withCString { qmlbind_value_new_string_cstr($0) }
    }

    public func toString() -> String {
        return String.fromQMLString(qmlbind_value_get_string(pointer)) ?? ""
    }

    // object
    public subscript(key: String) -> JSValue {
        get {
            return JSValue(qmlbind_value_get_property(pointer, key))
        }
        set(newValue) {
            qmlbind_value_set_property(pointer, key, newValue.pointer)
        }
    }

    public subscript(index: Int) -> JSValue {
        get {
            return JSValue(qmlbind_value_get_array_item(pointer, Int32(index)))
        }
        set(newValue) {
            qmlbind_value_set_array_item(pointer, Int32(index), newValue.pointer)
        }
    }

    public func deleteProperty(key: String) {
        qmlbind_value_delete_property(pointer, key)
    }

    public func hasProperty(key: String) -> Bool {
        return qmlbind_value_has_property(pointer, key) != 0
    }

    public func hasProperty(index: Int) -> Bool {
        return qmlbind_value_has_index(pointer, Int32(index)) != 0
    }

    public func hasOwnProperty(key: String) -> Bool {
        return qmlbind_value_has_own_property(pointer, key) != 0
    }

    public var prototype: JSValue {
        get {
            return JSValue(qmlbind_value_get_prototype(pointer))
        }
        set(newValue) {
            qmlbind_value_set_prototype(pointer, newValue.pointer)
        }
    }

    // function

    public func call(args: [JSValue]) -> JSValue {
        let ptrs = args.map { $0.pointer }
        return JSValue(qmlbind_value_call(pointer, Int32(ptrs.count), UnsafeMutablePointer(ptrs)))
    }

    public func call(args: [JSValue], instance: JSValue) -> JSValue {
        let ptrs = args.map { $0.pointer }
        return JSValue(qmlbind_value_call_with_instance(pointer, instance.pointer, Int32(ptrs.count), UnsafeMutablePointer(ptrs)))
    }

    public func new(args: [JSValue]) -> JSValue {
        let ptrs = args.map { $0.pointer }
        return JSValue(qmlbind_value_call_constructor(pointer, Int32(ptrs.count), UnsafeMutablePointer(ptrs)))
    }

    public func callMethod(key: String, _ args: [JSValue]) -> JSValue {
        return self[key].call(args, instance: self)
    }

    static public var undefined: JSValue {
        return JSValue(qmlbind_value_new_undefined())
    }

    static public var null: JSValue {
        return JSValue(qmlbind_value_new_null())
    }
}
