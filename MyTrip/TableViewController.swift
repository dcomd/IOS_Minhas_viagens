//
//  TableViewController.swift
//  MyTrip
//
//  Created by Alexandre de Oliveira Nepomuceno on 23/04/20.
//  Copyright © 2020 Alexandre de Oliveira Nepomuceno. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var viagens : [Dictionary<String,String>] = []
    var controledeNavigacao = "adicionar"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        self.controledeNavigacao = "adicionar"
        atualizarDados()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viagens.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let indetifier = "dadosCelula"
        let celula = tableView.dequeueReusableCell(withIdentifier: indetifier, for: indexPath)
        celula.textLabel?.text = viagens[indexPath.row]["local"]
        return celula
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ArmazenamentodeDados().removerViagens(indice: indexPath.row)
            atualizarDados()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.controledeNavigacao = "listar"
        performSegue(withIdentifier: "verLocal", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "verLocal"{
            let viewController = segue.destination  as! ViewController
            if controledeNavigacao == "listar"{
                if let indiceRecuperado = sender{
                    let indice = indiceRecuperado as! Int
                    viewController.viagens = viagens[indice]
                    viewController.indiceSelcionado = indice
                    
                }
            }else{
                viewController.viagens = [:]
                viewController.indiceSelcionado = -1
            }
        }
    }
    
    func atualizarDados(){
        viagens = ArmazenamentodeDados().listaViagens()
        tableView.reloadData()
    }
}
