import UIKit

class OrientationController {

    private init() {}

    static let shared = OrientationController()

    var currentOrientation: UIInterfaceOrientationMask = .portrait

    // 画面向き制御のアンロック
    func unlockOrientation() {
        currentOrientation = .all
    }

    // 画面を指定した向きでロック
    func lockOrientation(to orientation: UIInterfaceOrientationMask, onWindow window: UIWindow) {

        currentOrientation = orientation

        guard var topController = window.rootViewController else {
            return
        }
        // 最前面のViewControllerを取得
        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
        }
        // 端末の画面の向きをcurrentOrientationの値で更新
        topController.setNeedsUpdateOfSupportedInterfaceOrientations()
    }
}
