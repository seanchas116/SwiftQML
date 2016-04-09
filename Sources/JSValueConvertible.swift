public protocol JSValueConvertible {
    func qml_toJSValue(engine: Engine) -> JSValue
    static func qml_fromJSValue(value: JSValue) -> Self
}
