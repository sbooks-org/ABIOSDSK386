import CoreGraphics
import Foundation

let windows = CGWindowListCopyWindowInfo(.optionAll, kCGNullWindowID) as! [[String: Any]]
for window in windows {
    guard let pid = window[kCGWindowOwnerPID as String] as? Int, pid == 39642 else { continue }
    let number = window[kCGWindowNumber as String] as? Int ?? -1
    let layer = window[kCGWindowLayer as String] as? Int ?? -1
    let owner = window[kCGWindowOwnerName as String] as? String ?? ""
    let name = window[kCGWindowName as String] as? String ?? ""
    let bounds = window[kCGWindowBounds as String] ?? ""
    print("id=\(number) layer=\(layer) owner=\(owner) name=\(name) bounds=\(bounds)")
}
