public protocol QMLPropertyType {
    var qml_value: JSValueConvertible { get set }
    var qml_changeSignal: QMLSignalType { get }
}

extension QMLPropertyType {
    func getJSValue(engine: Engine) -> JSValue {
        return qml_value.qml_toJSValue(engine)
    }
    mutating func setJSValue(jsvalue: JSValue) {
        qml_value = qml_value.dynamicType.qml_fromJSValue(jsvalue)
    }
}
