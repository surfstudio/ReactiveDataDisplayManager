//
//  HelloController.swift
//  ReactiveChat_iOS
//
//  Created by Никита Коробейников on 26.05.2023.
//

import UIKit

final class HelloController: UIViewController {

    // MARK: - Views

    @IBOutlet private weak var nameField: UITextField! {
        didSet {
            nameField.delegate = self
        }
    }

    // MARK: - Constraints

    @IBOutlet private weak var nameFieldCenterY: NSLayoutConstraint!

    // MARK: - Services

    @Service(serviceType: Authenticator.self)
    private var authenticator: Authenticator?

    @Service(serviceType: StateKeeper.self)
    private var stateKeeper: StateKeeper?

    // MARK: - Private properties

    private var lastSelectedLayout: LayoutType?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        stateKeeper?.addDelegate(delegate: self, with: String(describing: Self.self))
    }

    override func willMove(toParent parent: UIViewController?) {
        if parent == nil {
            stateKeeper?.removeDelegate(by: String(describing: Self.self))
        }
    }

    // MARK: - Routing

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "Chat",
              let layout = lastSelectedLayout,
              let destinationController = segue.destination as? LayoutDependable else {
            return
        }

        destinationController.setLayout(layout: layout)
    }

    // MARK: - IBActions

    @IBAction private func nameEntered(_ sender: Any) {
        guard let name = nameField.text else {
            return
        }
        authenticator?.auth(by: name)
    }
}

// MARK: - UITextFieldDelegate

extension HelloController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        !(textField.text?.isEmpty ?? true)
    }

}

// MARK: - AuthDelegate

extension HelloController: AuthDelegate {

    func onAuthanticated() {
        nameField.resignFirstResponder()
        openLayoutSelectionSheet()
    }

}

// MARK: - Routing

private extension HelloController {

    func openLayoutSelectionSheet() {

        showSheet(title: "Choose layout",
                  items: LayoutType.allCases,
                  completion: { [weak self] layout in
            self?.lastSelectedLayout = layout
            self?.openChat()
        })

    }

    func openChat() {
        performSegue(withIdentifier: "Chat", sender: nil)
    }

}
