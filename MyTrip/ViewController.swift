//
//  ViewController.swift
//  MyTrip
//
//  Created by Alexandre de Oliveira Nepomuceno on 23/04/20.
//  Copyright © 2020 Alexandre de Oliveira Nepomuceno. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate , CLLocationManagerDelegate{
    
    @IBOutlet weak var map: MKMapView!
    var gerenciadordeLocalizacao = CLLocationManager()
    var viagens : Dictionary<String,String> = [:]
    var indiceSelcionado : Int!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        congiguraGernciador()
        
        if let indice = indiceSelcionado{
            if indice == -1 {//adiconar
                
            }else{//listar
                exibirAnotacao(viagem : self.viagens)
            }
        }
        
        //reconhecedor de gestos
        let reconhecedorGesto = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.marcar(gesture:) ))
        reconhecedorGesto.minimumPressDuration = 2
        
        map.addGestureRecognizer( reconhecedorGesto )
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let local = locations.last!
        
        //exibe local
        let localizacao = CLLocationCoordinate2DMake(local.coordinate.latitude , local.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        
        let regiao: MKCoordinateRegion = MKCoordinateRegion(center: localizacao,span: span)
        self.map.setRegion(regiao, animated: true)
        
    }
    
    func exibirLocal( latitude: Double, longitude: Double ){
        //exibe local
        let localizacao = CLLocationCoordinate2D(latitude: latitude , longitude: longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        
        let regiao: MKCoordinateRegion = MKCoordinateRegion(center: localizacao,span: span)
        self.map.setRegion(regiao, animated: true)
        
    }
    
    func exibirAnotacao( viagem: Dictionary<String, String> ){
        
        //Exibe anotação com os dados de endereco
        if let localViagem = viagem["local"] {
            if let latitudeS = viagem["latitude"] {
                if let longitudeS = viagem["longitude"] {
                    if let latitude = Double(latitudeS) {
                        if let longitude = Double(longitudeS) {
                            
                            //Adiciona anotacao
                            let anotacao = MKPointAnnotation()
                            
                            anotacao.coordinate.latitude = latitude
                            anotacao.coordinate.longitude = longitude
                            anotacao.title = localViagem
                            
                            self.map.addAnnotation(anotacao)
                            
                            exibirLocal(latitude: latitude, longitude: longitude)
                            
                        }
                    }
                }
            }
        }
        
    }
    
    @objc func marcar(gesture: UIGestureRecognizer){
        
        if gesture.state == UIGestureRecognizer.State.began{
            //recuperar a coordenação no ato do gesto
            let pontoSelecionado = gesture.location(in: self.map)
            //recuperar ponto selecionado
            let coordenadas = map.convert(pontoSelecionado, toCoordinateFrom: self.map)
            
            //recupera endereço
//            var nomeLocal = ""
//            var enderecoLocal = ""
            var localCompleto = ""
            let localizacao = CLLocation(latitude: coordenadas.latitude , longitude: coordenadas.longitude)
            CLGeocoder().reverseGeocodeLocation(localizacao, completionHandler: {
                (local,erro) in
                
                if erro == nil{
                    if let dadosLocal = local?.first {
                        
                        if let nome = dadosLocal.name {
                            localCompleto = nome
                        }else{
                            
                            if let endereco = dadosLocal.thoroughfare {
                                localCompleto = endereco
                            }
                            
                        }
                        
                    }
                    
                    self.viagens = ["local": localCompleto,
                                    "latitude": String(coordenadas.latitude),
                                    "longitude": String(coordenadas.longitude) ]
                    ArmazenamentodeDados().salvarViagens(viagem: self.viagens)
                    //Exibe anotação com os dados de endereco
                    self.exibirAnotacao(viagem: self.viagens )
                    
                }else{
                    print("erro")
                }
                
            })
        }
    }
    
    func congiguraGernciador(){
        gerenciadordeLocalizacao.delegate = self
        gerenciadordeLocalizacao.desiredAccuracy = kCLLocationAccuracyBest
        gerenciadordeLocalizacao.requestWhenInUseAuthorization()
        gerenciadordeLocalizacao.startUpdatingLocation()
    }
    //solicitar autorizacao para abrir configuracoes
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorizedWhenInUse{
            
            let alerta = UIAlertController(title: "Necessario Autoização", message: "Necessario Autorização para funcionamento do Aplicativo.", preferredStyle: .alert)
            
            let confirma = UIAlertAction(title: "Abrir configurações", style: .default, handler:{
                (alertaConfiguracoes) in
                    if let configuracoes = URL(string: UIApplication.openSettingsURLString){
                        UIApplication.shared.open(configuracoes as URL)
                    }
               }
                
            )
            
            let cancelar = UIAlertAction(title: "cancelar", style: .default, handler: nil)
            
            alerta.addAction(confirma)
            alerta.addAction(cancelar)
            present(alerta, animated: true, completion: nil)
        }
    }

}

