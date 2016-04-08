import CQMLBind

extension String {
    static func fromQMLString(qmlStr: UnsafeMutablePointer<qmlbind_string>) -> String? {
        if qmlStr != nil {
            let str = String(validatingUTF8: qmlbind_string_get_chars(qmlStr))
            qmlbind_string_release(qmlStr)
            return str
        }
        return nil
    }
}
