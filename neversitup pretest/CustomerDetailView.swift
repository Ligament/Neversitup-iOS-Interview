//
//  CustomerDetailView.swift
//  neversitup pretest
//
//  Created by Amornthap on 7/3/2563 BE.
//  Copyright © 2563 Ligament Studio. All rights reserved.
//

import SwiftUI
import CoreData

struct CustomerDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @FetchRequest(
        entity: Customers.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Customers.name, ascending: false)]
    ) var customers: FetchedResults<Customers>
    @Binding var isLoginActive: Bool
    let token: String
    var body: some View {
        NavigationView {
            List(customers) { customer in
                NavigationLink(destination: DetailView(customer: customer, token: self.token)) {
                    Text(customer.name)
                }
            }
            .navigationBarTitle("Detail")
            .navigationBarItems(trailing: Button(action: {
                //                    self.showOrderSheet = true
            }, label: {
                Button(action: {
                    self.isLoginActive = false
                    deleteAllData(entity: "Customers")
                }) {
                    Text("Logout")
                }
            }))
        }
    }
}

func deleteAllData(entity: String){
    
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let managedContext = appDelegate.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
    fetchRequest.returnsObjectsAsFaults = false
    
    do {
        let arrUsrObj = try managedContext.fetch(fetchRequest)
        for usrObj in arrUsrObj as! [NSManagedObject] {
            managedContext.delete(usrObj)
        }
        try managedContext.save()
    } catch let error as NSError {
        print("delete fail--",error)
    }
    
}
