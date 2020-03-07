//
//  DetailView.swift
//  neversitup pretest
//
//  Created by Amornthap on 7/3/2563 BE.
//  Copyright © 2563 Ligament Studio. All rights reserved.
//

import SwiftUI

struct Detail {
    var customerGrade: String
    var id: String
    var isCustomerPremium: Bool
    var name: String
    var sex: String
}

struct DetailView: View {
    let customer: Customers
    let token: String
    @State var detail: Detail = Detail(customerGrade: "", id: "", isCustomerPremium: false, name: "", sex: "")
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("ID: ")
                Text(detail.id)
            }
            HStack {
                Text("Name: ")
                Text(detail.name)
            }
            HStack {
                Text("Customer Grade: ")
                Text(detail.customerGrade)
            }
            HStack {
                Text("Sex: ")
                Text(detail.sex)
            }
            HStack {
                Text("Customer Premium: ")
                if detail.isCustomerPremium {
                    Text("Yes.")
                } else {
                    Text("No.")
                }
            }           
            
        }.onAppear {
            self.getDetail(requestData: ["token":self.token,"customerId":self.customer.id])
        }
        
    }
    
    func getDetail(requestData: [String: String]) {
        
        let url = URL(string:"http://neversitup.pythonanywhere.com/getCustomerDetail")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonRequest: Data
        do {
            jsonRequest = try JSONSerialization.data(withJSONObject: requestData, options:[])
            request.httpBody = jsonRequest
            print(requestData)
        } catch {
            print("Error: cannot create JSON from receivedData")
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print("error calling POST")
                print(error!)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            do {
                if let jsonData = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]  {
                    guard let deteilData = jsonData["data"] as? [String: Any] else {
                        print("Could not get todoID as int from JSON")
                        return
                    }
                    self.detail.customerGrade = deteilData["customerGrade"] as! String
                    self.detail.id = deteilData["id"] as! String
                    self.detail.isCustomerPremium = deteilData["isCustomerPremium"] as! Bool
                    self.detail.name = deteilData["name"] as! String
                    self.detail.sex = deteilData["sex"] as! String
                }
            } catch  {
                print("error parsing response from POST on /login")
                return
            }
        }.resume()
        
    }
}
