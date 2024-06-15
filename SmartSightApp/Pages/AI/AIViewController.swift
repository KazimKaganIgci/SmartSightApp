//
//  AIViewController.swift
//  SmartSightApp
//
//  Created by Kazım Kağan İğci on 16.05.2024.
//

import UIKit
import OpenAI

class ChatController {
    var messages: [Message] = []
    let openAI = OpenAI(apiToken: "enter openAI token")

    func sendNewMessage(content: String) {
        let userMessage = Message(content: content, isUser: true)
        messages.append(userMessage)
        getBotReply()
    }

    func getBotReply() {
        let query = ChatQuery(
            messages: messages.map({ .init(role: .user, content: $0.content)! }),
            model: .gpt3_5Turbo
        )

        openAI.chats(query: query) { result in
            switch result {
            case .success(let success):
                guard let choice = success.choices.first, let message = choice.message.content?.string else {
                    return
                }
                DispatchQueue.main.async {
                    self.messages.append(Message(content: message, isUser: false))
                }
            case .failure(let failure):
                self.messages.append(Message(content: failure.localizedDescription, isUser: false))
            }
        }
    }
}

struct Message {
    let id = UUID()
    let content: String
    let isUser: Bool
}

class AIViewController: UIViewController {
    let chatController = ChatController()
    var tableView: UITableView!
    var textField: UITextField!
    var sendButton: UIButton!
    
    let viewModel: AIViewModel
    var messages: [Message] = []
    let openAI = OpenAI(apiToken: "enter openAI token")

    init(viewModel: AIViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        view.backgroundColor = .white
    }

    private func setupViews() {
        textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Message..."
        textField.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        textField.layer.cornerRadius = 15
        textField.delegate = self
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect

        view.addSubview(textField)

        sendButton = UIButton(type: .system)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.setTitle("Send", for: .normal)
        sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)

        view.addSubview(sendButton)

        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(MessageCell.self, forCellReuseIdentifier: "MessageCell")

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -20),
            textField.heightAnchor.constraint(equalToConstant: 40),

            sendButton.topAnchor.constraint(equalTo: textField.topAnchor),
            sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            sendButton.widthAnchor.constraint(equalToConstant: 80),
            sendButton.heightAnchor.constraint(equalTo: textField.heightAnchor),

            tableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    @objc private func sendMessage() {
        guard let text = textField.text, !text.isEmpty else { return }
        
        chatController.sendNewMessage(content: text)
        textField.text = ""
        self.tableView.reloadData()
        view.endEditing(true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.tableView.reloadData()
        }
    }

}

extension AIViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatController.messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
        let message = chatController.messages[indexPath.row]
        cell.configure(with: message)
        return cell
    }
}

extension AIViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessage()
        return true
    }
}

class MessageCell: UITableViewCell {
    func configure(with message: Message) {
        textLabel?.text = message.content
        textLabel?.textColor = .white
        textLabel?.numberOfLines = 0
        textLabel?.lineBreakMode = .byWordWrapping
        textLabel?.layer.masksToBounds = true
        textLabel?.layer.cornerRadius = 10
        backgroundColor = message.isUser ? .blue : .black
    }
}
