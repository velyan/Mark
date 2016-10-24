//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

class MyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
}

protocol MyProtocol {
    
}

protocol MyRootStruct {
    
}

struct MyStruct : MyRootStruct, MyProtocol {
    
}

extension MyViewController : MyProtocol {
    
}
