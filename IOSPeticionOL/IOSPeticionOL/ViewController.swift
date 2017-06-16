//
//  ViewController.swift
//  IOSPeticionOL
//
//  Created by Carlos on 10/06/2017.
//  Copyright © 2017 Woowrale. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate  {

    let TEXT_VOID = ""
    let TEXT_EXCEPTION_CONNECTION = "Se ha producido una excepción en la comunicación."
    let TEXT_EXCEPTION_TEXTFIELD_VOID = "No se puede buscar algún libro, porque el campo de búsqueda esta vacio."
    let URL_SEARCH = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:"
    
    @IBOutlet weak var textISBN: UITextField!
    @IBOutlet weak var textShowResponse: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        textISBN.delegate = self
        cleanTextFields()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textISBN.resignFirstResponder()
        if(textISBN.text == TEXT_VOID){
            showAlertBox(message: TEXT_EXCEPTION_TEXTFIELD_VOID)
        }else{
            textShowResponse.text = searchBook(isbn: textISBN.text!)
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        cleanTextFields()
        return true
    }
    
    private func cleanTextFields(){
        textISBN.text = TEXT_VOID
        textShowResponse.text = TEXT_VOID
    }
    
    private func searchBook(isbn: String) -> String {

        let urls = URL_SEARCH + isbn
        let url = NSURL(string: urls)
        var datos = NSData()
        do{
            datos = try NSData(contentsOf: url! as URL)
        } catch {
            showAlertBox(message: TEXT_EXCEPTION_CONNECTION)
        }
        
        let texto = NSString(data: datos as Data, encoding: String.Encoding.utf8.rawValue)
        
        return String(describing: texto)
    }
    
    func showAlertBox(message: String){
        let alertMessage = UIAlertController(title: "Conexion OpenLibrary", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertMessage.addAction(UIAlertAction(title: "Cerrar", style: UIAlertActionStyle.default,handler: nil))        
        present(alertMessage, animated: true, completion: nil)
    }
    
}

