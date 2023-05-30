//
//  ChatContainerController.swift
//  ReactiveChat_iOS
//
//  Created by Никита Коробейников on 26.05.2023.
//

import UIKit
import SurfUtils

final class ChatContainerController: UIViewController {

    // MARK: - Views

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var chatInputView: ChatInputView!

    // MARK: - Constraints

    @IBOutlet private weak var chatInputViewBottomToSafeArea: NSLayoutConstraint!

    // MARK: - Services

    @Service(serviceType: Sender.self)
    private var chatSender: Sender?

    // MARK: - Private properties

    private var layout: LayoutType?
    private lazy var keyboardObservable = AutoConstraintKeyboardPositionManager(view: view,
                                                                                configurations: [
                                                                                    .init(constraint: chatInputViewBottomToSafeArea)
                                                                                ])

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        applyLayout(layout: layout ?? .table)
        configureInputView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardObservable.subscribeOnKeyboardNotifications()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        keyboardObservable.unsubscribeFromKeyboardNotifications()
    }

    override func willMove(toParent parent: UIViewController?) {
        if parent == nil {
            clearLayout()
        }
    }
}

// MARK: - LayoutDependable

extension ChatContainerController: LayoutDependable {

    func setLayout(layout: LayoutType) {
        self.layout = layout
    }

}

// MARK: - Private

private extension ChatContainerController {

    func configureInputView() {
        chatInputView.placeholder = "Type here"

        chatInputView.onSendTapped = { [weak self] text in
            self?.chatSender?.send(text: text)
            self?.chatInputView.clear()
        }
    }

    func applyLayout(layout: LayoutType) {

        let child: UIViewController = {
            switch layout {
            case .table:
                return TableChatViewController(nibName: nil, bundle: nil)
            case .collection:
                return CollectionChatViewController(nibName: nil, bundle: nil)
            }
        }()

        addChild(child)
        containerView.addSubview(child.view)
        containerView.stretch(view: child.view)
        child.didMove(toParent: self)

    }

    func clearLayout() {
        guard let child = children.first else {
            return
        }

        child.willMove(toParent: nil)
        child.view.removeFromSuperview()
        child.removeFromParent()
    }

}
