//
//  ViewController.swift
//  IOSPeticionOLJson
//
//  Created by Carlos on 04/07/2017.
//  Copyright © 2017 Woowrale. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate  {
    
    let TEXT_VOID = ""
    let TEXT_TITLE = "Title:"
    let TEXT_AUTHORS = "Authors:"
    let TEXT_EXCEPTION_CONNECTION = "Se ha producido una excepción en la comunicación."
    let TEXT_EXCEPTION_TEXTFIELD_VOID = "No se ha encontrado ningun libro con el ISBN: "
    let URL_SEARCH = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:"
    let jsonConnection = JSONCOnnection()
    
    @IBOutlet weak var textISBN: UITextField!
    @IBOutlet weak var textTitle: UILabel!
    @IBOutlet weak var textAuthors: UILabel!    
    
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookAuthors: UILabel!
    @IBOutlet weak var bookImage: UIImageView!
    
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
        
        let textSearch = textISBN.text!
        
        if(textSearch == TEXT_VOID){
            showAlertBox(message: TEXT_EXCEPTION_TEXTFIELD_VOID)
        }else{
            do{           
                let book = try jsonConnection.getJsonData(codISBN: textSearch)                
                if(book.title != nil){
                    setTextLiterals()
                    bookTitle.text = book.title
                    for author in book.authors{
                        bookAuthors.text?.append(author)
                    }
                    bookImage.image = book.image
                }else{
                    showAlertBox(message: TEXT_EXCEPTION_TEXTFIELD_VOID + textSearch)
                }
            }catch{
                showAlertBox(message: TEXT_EXCEPTION_CONNECTION)
                print("Exception in method: textFieldShouldReturn")
            }
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        cleanTextFields()
        return true
    }
    
    private func cleanTextFields(){
        textISBN.text = TEXT_VOID
        textTitle.text = TEXT_VOID
        textAuthors.text = TEXT_VOID
        
        bookTitle.text = TEXT_VOID
        bookAuthors.text = TEXT_VOID
        bookImage.image = nil
    }
    
    private func setTextLiterals(){
        textTitle.text = TEXT_TITLE
        textAuthors.text = TEXT_AUTHORS
    }
    
    func showAlertBox(message: String){
        let alertMessage = UIAlertController(title: "Conexion OpenLibrary", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertMessage.addAction(UIAlertAction(title: "Cerrar", style: UIAlertActionStyle.default,handler: nil))
        present(alertMessage, animated: true, completion: nil)
    }
    
}

