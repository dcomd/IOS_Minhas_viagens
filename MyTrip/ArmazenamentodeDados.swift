//
//  ArmazenamentodeDados.swift
//  MyTrip
//
//  Created by Alexandre de Oliveira Nepomuceno on 24/04/20.
//  Copyright © 2020 Alexandre de Oliveira Nepomuceno. All rights reserved.
//

import UIKit

class ArmazenamentodeDados {
    
    let chave = "locaisViagens"
    var viagens : [ Dictionary<String,String> ] = []
    
    func getDefaults() -> UserDefaults{
        return UserDefaults.standard
    }
   
    func salvarViagens(viagem: Dictionary<String,String> ){
        self.viagens = listaViagens()
        self.viagens.append(viagem)
        getDefaults().set(viagens, forKey: chave)
        getDefaults().synchronize()
    }
    
    func listaViagens() -> [Dictionary<String,String>]{
      let dados = getDefaults().object(forKey: chave)
        if dados != nil{
            return dados as! Array
        }else
        {
            return []
        }
    }
    
    func removerViagens(indice: Int){
        self.viagens = listaViagens()
        viagens.remove(at: indice)
        getDefaults().set(viagens, forKey: chave)
        getDefaults().synchronize()
        
    }
}
