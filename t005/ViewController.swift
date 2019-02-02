import UIKit

class User
{
    let name:String
    init(name: String)
    {
        self.name = name
    }
}

class Contact
{
    let name:String
    init(name: String)
    {
        self.name = name
    }
}

protocol ContactsListUI {
    func show(contacts: [Contact])
}

class ContactsListViewController: UIViewController, ContactsListUI {
    private let presenter: ContactsListPresenter
    
    init(presenter: ContactsListPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        self.presenter.ui = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.backgroundColor = UIColor.white
        
        view.addSubview(loginButton)
        view.addSubview(registerButton)
        
        loginButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        registerButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registerButton.bottomAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 60).isActive = true
    }
    
    func show(contacts: [Contact]) {
    }
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor(red: 142.0/255.0, green: 68.0/255.0, blue: 173.0/255.0, alpha: 1.0)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        //button.addTarget(self, action: #selector(onButtonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor(red: 142.0/255.0, green: 68.0/255.0, blue: 173.0/255.0, alpha: 1.0)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        //button.addTarget(self, action: #selector(onButtonPressed(_:)), for: .touchUpInside)
        return button
    }()
}

class ContactsListPresenter {
    var ui: ContactsListUI?
    private let getAllContacts: GetAllContacts
    
    init(getAllContacts: GetAllContacts) {
        self.getAllContacts = getAllContacts
    }
}

class GetAllContacts {
    private let contactsDataSource: ContactsDataSource
    
    init(contactsDataSource: ContactsDataSource) {
        self.contactsDataSource = contactsDataSource
    }
}

protocol ContactsDataSource {
    func getAll() -> [Contact]
}

class NetworkContactsDataSource: ContactsDataSource {
    func getAll() -> [Contact] {
        return [Contact(name: "Network Contact")]
    }
}

protocol ContactsSceneAssembler {
    func resolve() -> User
    func resolve(user: User) -> ContactsListViewController
    func resolve(user: User) -> ContactsListPresenter
    func resolve() -> GetAllContacts
    func resolve() -> ContactsDataSource
}

class Assembler: ContactsSceneAssembler {
    func resolve() -> User {
        return User(name: "Test User!")
    }
    
    func resolve(user: User) -> ContactsListViewController {
        return ContactsListViewController(presenter: resolve(user: user))
    }
    
    func resolve(user: User) -> ContactsListPresenter {
        return ContactsListPresenter(getAllContacts: resolve())
    }
    
    func resolve() -> GetAllContacts {
        return GetAllContacts(contactsDataSource: resolve())
    }
    
    func resolve() -> ContactsDataSource {
        return NetworkContactsDataSource()
    }
}
