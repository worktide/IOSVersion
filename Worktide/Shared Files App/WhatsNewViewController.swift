//
//  WhatsNewViewController.swift
//  Worktide
//
//  Created by Kristofer Huang on 2020-01-04.
//  Copyright © 2020 Kristofer Huang. All rights reserved.
//

import UIKit

class WhatsNewViewController: UIViewController{
    
    //MARK: Item Init
    // you need to initialize items like these. IOS comes with UIKit that has these items.
    private let backgroundView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false // you always need this because we are using autolayout
        view.backgroundColor = .green //these items have properties you can change
        return view
    }()
    
    private let imageView:UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "paymentIcon")) // this is how u set an image in an image. or imageView.image = UIImage()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let skipButton:UIButton = { // some item have different properties so you can just search that up online or look through the project
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Skip", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(doneButton), for: .touchUpInside) //see func doneButton
        return button
    }()
    
    //MARK: IOS Lifecycle
    //ios has lifecycles that gets called when we call this class. this is the first that it will be called
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupView()
    }
    
    //other lifecycles but we dont need for this
    /*override func viewWillAppear(_ animated: Bool) {
        <#code#>
    }
    
    override func viewDidAppear(_ animated: Bool) {
        <#code#>
    }*/
    
    //MARK: SETUP VIEWS
    // I organize my files into functions of what I needa do
    func setupNavigation(){
        navigationController?.setNavigationBarHidden(true, animated: true) //used just to hide the navigation bar
    }
    
    func setupView(){
        
        // UIViewController which is this class comes with a view that is bascially the same screen size
        view.backgroundColor = .white // we need to set this to a color or else it will be transparent
        
        view.addSubview(backgroundView) //then we add the UI items we initialized like this
        view.addSubview(imageView)
        
        //this is to set the location and size of the views.
        backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true // means background view left side is aligned with the views left side
        backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true //backgroundview right side aligned view right side
        backgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true // background view top aligned with top of view/screen
        backgroundView.heightAnchor.constraint(equalToConstant: 300).isActive = true // the height
        
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true//center of the view/screen
        imageView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor).isActive = true//center of backgroundviews center vertically
        imageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    //MARK: LISTENERS
    //we use this to set when buttons are pressed
    @objc func doneButton(sender: UIButton!) {
        
        //switch because we might add more buttons
        switch sender {
        case skipButton:
            self.dismiss(animated: true, completion: {
                // this is for me just leave it like this.
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showViewsListener"), object: nil, userInfo: nil)
            })
            
        /*case nextButton:
            let viewController = WhatsNewViewController1()
            self.navigationController?.pushViewController(viewController, animated: true)
        *///this is how you will show the next viewcontroller.
            
        default:
            break
        }
        
        
    }
    
    
}

//this is the next view controller you needa show im just putting it into one file just for this part so its easier. Others you would usually create a new file for a new vewicontroller.
class WhatsNewViewController1:UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
    }
}
