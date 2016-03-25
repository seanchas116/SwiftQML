import Darwin
import CQMLBind

public class Application {
    private let ptr: qmlbind_application
    static private var _instance: Application!

    init(args: [String]) {
        if Application._instance != nil {
            fatalError("SwiftQML: cannot create multiple Application instances")
        }
        let array = CStringArray(args)
        ptr = qmlbind_application_new(Int32(array.length), UnsafeMutablePointer(array.pointers))
        Application._instance = self
    }

    func exec() -> Int {
        return Int(qmlbind_application_exec(ptr))
    }

    deinit {
        qmlbind_application_release(ptr)
    }

    static var instance: Application {
        return _instance
    }

    static func processEvents() {
        qmlbind_process_events()
    }
}
