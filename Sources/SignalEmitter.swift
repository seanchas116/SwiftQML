import CQMLBind

class SignalEmitter {
    let pointer: UnsafeMutablePointer<qmlbind_signal_emitter>

    init(_ pointer: UnsafeMutablePointer<qmlbind_signal_emitter>) {
        self.pointer = pointer
    }

    func emit(name: String, args: [JSValue]) {
        let ptrs = args.map { $0.pointer }
        qmlbind_signal_emitter_emit(pointer, name, Int32(args.count), UnsafePointer(ptrs))
    }
}
