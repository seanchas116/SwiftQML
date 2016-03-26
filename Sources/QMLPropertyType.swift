public protocol QMLPropertyType {
    var qml_value: JSValueConvertible { get set }
    var qml_changeSignal: QMLSignalType { get }
}
