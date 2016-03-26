import Darwin
import CQMLBind

public class Application {
    let pointer: qmlbind_application
    static private var _instance: Application!

    public init(arguments: [String]) {
        if Application._instance != nil {
            fatalError("SwiftQML: cannot create multiple Application instances")
        }
        let array = CStringArray(arguments)
        pointer = qmlbind_application_new(Int32(array.length), UnsafeMutablePointer(array.pointers))
        Application._instance = self
    }

    public func exec() -> Int {
        return Int(qmlbind_application_exec(pointer))
    }

    deinit {
        qmlbind_application_release(pointer)
    }

    static public var instance: Application {
        return _instance
    }

    static public func processEvents() {
        qmlbind_process_events()
    }
}
