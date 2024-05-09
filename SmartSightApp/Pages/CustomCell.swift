import UIKit
import SDWebImage
import Foundation

class CustomCell: UITableViewCell {

    static let identifier = "CustomCell"
    var item: Article?
    
    private let customImageView: UIImageView = {
        let customImageView = UIImageView()
        customImageView.contentMode = .scaleAspectFill
        customImageView.tintColor = .label
        customImageView.layer.cornerRadius = 15
        customImageView.layer.masksToBounds = true
        return customImageView
    }()
    
    private let customLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 4
        return label
    }()
    
    private let customDetailLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.numberOfLines = 4
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 12, weight: .medium)
        return label
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "star.fill"), for: .normal)
        button.tintColor = .yellow
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(article: Article) {
        self.item = article
        if let urlString = article.urlToImage {
            customImageView.sd_setImage(with: URL(string: urlString))
        }
        if !article.title.isEmpty {
            customLabel.text = article.title
        }
        
        if article.description != nil {
            customDetailLabel.text = article.description
        }
        
        if let existingArticles = MFUserDefaults.article {
            if let item = item, existingArticles.contains(where: { $0 == item }) {
                favoriteButton.tintColor = .red
            } else {
                favoriteButton.tintColor = .yellow
            }
        }    }
    
    func setupUI() {
        contentView.addSubview(customImageView)
        contentView.addSubview(customLabel)
        contentView.addSubview(customDetailLabel)
        contentView.addSubview(favoriteButton)

        customImageView.translatesAutoresizingMaskIntoConstraints = false
        customLabel.translatesAutoresizingMaskIntoConstraints = false
        customDetailLabel.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            customImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            customImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            customImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            customImageView.heightAnchor.constraint(equalToConstant: 150),
            customImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -32),

            customLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            customLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            customLabel.topAnchor.constraint(equalTo: customImageView.bottomAnchor, constant: 8),

            customDetailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            customDetailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            customDetailLabel.topAnchor.constraint(equalTo: customLabel.bottomAnchor, constant: 8),
            customDetailLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10),
            
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            favoriteButton.widthAnchor.constraint(equalToConstant: 50),
            favoriteButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        customImageView.widthAnchor.constraint(equalTo: customImageView.heightAnchor, multiplier: 1.0).isActive = true
    }
    
    @objc func favoriteButtonTapped() {
        var existingArticles = MFUserDefaults.article ?? []
        
        if let item = item {
            if let index = existingArticles.firstIndex(of: item) {
                existingArticles.remove(at: index)
            } else {
                existingArticles.append(item)
            }
        }
        
        MFUserDefaults.article = existingArticles
        
        if favoriteButton.tintColor == .red {
            favoriteButton.tintColor = .yellow
        } else {
            favoriteButton.tintColor = .red
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "favorites"), object: nil) 
    }
}
