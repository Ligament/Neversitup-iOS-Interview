//
//  ContentView.swift
//  neversitup pretest
//
//  Created by Amornthap on 7/3/2563 BE.
//  Copyright © 2563 Ligament Studio. All rights reserved.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @State var username: String = ""
    @State var password: String = ""
    @State var loginFail: Bool = false
    @State var isLogin: Bool = false
    @State var token: String = ""
    var body: some View {
        VStack {
            if isLogin {
                CustomerDetailView(isLoginActive: $isLogin, token: token).environment(\.managedObjectContext, self.managedObjectContext).animation(.spring())
                    .transition(.slide)
            } else {
                TextField("Username", text: $username)
                    .padding()
                    .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.94))
                    .cornerRadius(5.0)
                    .padding()
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.94))
                    .cornerRadius(5.0)
                    .padding()
                if loginFail {
                    Text("Username or Password not correct. Try again.")
                        .offset(y: -10)
                        .foregroundColor(.red)
                }
                Button(action: {
                    if !self.username.isEmpty, !self.password.isEmpty, self.submit(requestData: ["username": self.username, "password": self.password])  {
                        self.loginFail = false
                    } else {
                        self.loginFail = true
                    }
                } ) {
                    LoginButtonView()
                    
                }
            }
        }
    }
    
    func addData(_ customerData: [String: String]){
        let customer = Customers(context: managedObjectContext)
        customer.id = customerData["id"]!
        customer.name = customerData["name"]!
        do {
            try managedObjectContext.save()
            print("save it")
        } catch {
            print(error)
        }
    }
    
    func submit(requestData: [String: String]) -> Bool {
        
        let url = URL(string:"http://neversitup.pythonanywhere.com/login")!
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
            return false
        }
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
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
                guard let receivedData = try JSONSerialization.jsonObject(with: responseData,
                                                                          options: []) as? [String: Any] else {
                                                                            print("Could not get JSON from responseData as dictionary")
                                                                            return
                }
                guard let customersData = receivedData["customers"] as? NSArray else {
                    print("Could not get todoID as int from JSON")
                    return
                }
                guard let tk = receivedData["token"] as? String else {
                    return
                }
                self.token = tk
                for cData in customersData {
                    if let d = cData as? [String: String] {
                        self.addData(d)
                    }
                }
                self.isLogin = true
            } catch  {
                print("error parsing response from POST on /login")
                return
            }
        }
        task.resume()
        
        return true
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif

struct LoginButtonView: View {
    var body: some View {
        Text("LOGIN")
            .font(.headline)
            .foregroundColor(.black)
            .padding()
            .frame(width: 220, height: 60)
            .background(/*@START_MENU_TOKEN@*/Color(hue: 0.252, saturation: 0.748, brightness: 0.964, opacity: 0.528)/*@END_MENU_TOKEN@*/)
            .cornerRadius(15.0)
    }
}
